#include "application.h"
#include "rpcconnection.h"

#include <shv/iotqt/rpc/rpcresponsecallback.h>
#include <shv/coreqt/log.h>
#include <shv/chainpack/datachange.h>

#include <QDebug>

using namespace shv::chainpack;

Application::Application(int &argc, char **argv)
	: Super(argc, argv)
	, m_brokerListModel(new BrokerListModel(this))
	, m_subscriptionModel(new SubscriptionModel(this))
	, m_crypt(shv::core::utils::Crypt::createGenerator(17456, 3148, 2147483647))
	, m_rpcConnection(new RpcConnection(this))
{
	connect(m_rpcConnection, &RpcConnection::brokerConnectedChanged, this, [this](bool is_connected) {
		m_subscriptionModel->clear();
		emit brokerConnectedChanged(is_connected);
		emit methodCallInProcess(false);
	});
	connect(m_rpcConnection, &RpcConnection::brokerLoginError, this, [this](const shv::chainpack::RpcError &err) {
		qWarning() << "connect to broker error:" << err.toString();
		emit connetToBrokerError(QString::fromStdString(err.toString()));
		emit methodCallInProcess(false);
	});
	connect(m_rpcConnection, &RpcConnection::rpcMessageReceived, this, [this](const shv::chainpack::RpcMessage &msg) {
		if(msg.isSignal()) {
			RpcSignal sig(msg);
			auto shv_path = QString::fromStdString(msg.shvPath().asString());
			auto method = QString::fromStdString(msg.method().asString());
			//auto value = shv::coreqt::rpc::rpcValueToQVariant(sig.params());
			auto val = sig.params();
			//auto qdt = shv::coreqt::rpc::rpcValueToQVariant(val.metaValue(DataChange::MetaType::Tag::DateTime)).toDateTime();
			//if(!qdt.isValid())
			//	qdt = QDateTime::currentDateTime();
			auto qdt = QDateTime::currentDateTime();
			val.setMetaData({});
			auto qval = shv::coreqt::rpc::rpcValueToQVariant(val);
			emit signalArrived(shv_path, method, qdt, qval);
		}
	});
}

void Application::connectToBroker(int connection_id)
{
	emit methodCallInProcess(true);
	m_rpcConnection->close();
	auto props = m_brokerListModel->brokerPropertiesStruct(connection_id);
	m_rpcConnection->setConnectionString(props.connectionString());
	qDebug() << "connecting to broker:" << m_rpcConnection->connectionUrl().toDisplayString();
	m_rpcConnection->open();
}

void Application::callLs(const QString &shv_path)
{
	callRpcMethod(shv_path, "ls", {}, this,
		[this, shv_path](int rq_id, const auto &result) {
			//shvInfo() << result.toStringList().join(',');
			emit nodesLoaded(shv_path, result.toStringList());
		},
		[this, shv_path](int rq_id, const auto &error) {
			// ls() might not be defined for node, show methods anyway
			emit nodesLoaded(shv_path, QStringList());
		}
	);
}

void Application::callDir(const QString &shv_path)
{
	callRpcMethod(shv_path, "dir", {}, this,
		[this, shv_path](int rq_id, const QVariant &result) {
			QVariantList dir;
			for(const auto &v : result.toList()) {
				auto rv = shv::coreqt::rpc::qVariantToRpcValue(v);
				auto mm = MetaMethod::fromRpcValue(rv);
				if (mm.isValid()) {
					auto method = shv::coreqt::rpc::rpcValueToQVariant(mm.toRpcValue()).toMap();
					dir << method;
				}
				else {
					shvWarning() << "Unsupported method description type:" << v.typeName() << shv::coreqt::rpc::qVariantToRpcValue(v).toCpon();
				}
			}
			emit methodsLoaded(shv_path, dir);
		}
	);
}

int Application::callMethod(const QString &shv_path, const QString &method, const QVariant &params)
{
	return callRpcMethod(shv_path, method, params, this,
		[this, shv_path](int rq_id, const auto &result) {
			auto cpon = shv::coreqt::rpc::qVariantToRpcValue(result).toCpon();
			shvInfo() << cpon;
			emit methodCallResult(rq_id, QString::fromStdString(cpon), false);
		},
		[this, shv_path](int rq_id, const auto &error) {
			qDebug() << error.toString();
			emit methodCallResult(rq_id, QString::fromStdString(error.toString()), true);
		}
	);
}

QString Application::variantToCpon(const QVariant &v)
{
	if(!v.isValid() || v.isNull())
		return {};
	auto rv = shv::coreqt::rpc::qVariantToRpcValue(v);
	auto cpon = rv.toCpon("  ");
	return QString::fromStdString(cpon);
}

QVariant Application::cponToVariant(const QString &cpon)
{
	std::string err;
	auto rv = shv::chainpack::RpcValue::fromCpon(cpon.toStdString(), &err);
	return shv::coreqt::rpc::rpcValueToQVariant(rv);
}

QString Application::checkCpon(const QString &cpon)
{
	std::string err;
	shv::chainpack::RpcValue::fromCpon(cpon.toStdString(), &err);
	return QString::fromStdString(err);
}

QString Application::appVersion() const
{
	return QCoreApplication::applicationVersion();
}

int Application::callRpcMethod(const QString &shv_path, const QString &method, const QVariant &params, const QObject *context
							 , std::function<void (int rq_id, const QVariant &)> success_callback
							 , std::function<void (int rq_id, const shv::chainpack::RpcError &)> error_callback)
{
	if(context == nullptr && (success_callback || error_callback))
		shvWarning() << shv_path << method << "Context object is NULL";
	auto *rpcc = shv::iotqt::rpc::RpcCall::create(m_rpcConnection);
	auto rq_id = m_rpcConnection->nextRequestId();
	emit methodCallInProcess(true);
	rpcc->setShvPath(shv_path)
			->setMethod(method)
			->setParams(shv::coreqt::rpc::qVariantToRpcValue(params))
			->setRequestId(rq_id);
	connect(rpcc, &shv::iotqt::rpc::RpcCall::maybeResult, this, [rq_id, this]() {
		emit methodCallInProcess(false);
	});
	if (rpcc) {
		if(success_callback) {
			connect(rpcc, &shv::iotqt::rpc::RpcCall::result, context, [success_callback, rq_id](const ::shv::chainpack::RpcValue &result) {
				QVariant rv = shv::coreqt::rpc::rpcValueToQVariant(result);
				success_callback(rq_id, rv);
			});
		}
		if(error_callback) {
			connect(rpcc, &shv::iotqt::rpc::RpcCall::error, context, [rq_id, error_callback](const shv::chainpack::RpcError &error) {
				error_callback(rq_id, error);
			});
		}
		else {
			connect(rpcc, &shv::iotqt::rpc::RpcCall::error, [method, shv_path](const shv::chainpack::RpcError &error) {
				shvError() << "Call method:" << method << "on path:" << shv_path << "error:" << error.toString();
			});
		}
		return rpcc->start();
	}
	else {
		shvWarning() << shv_path << method << "RPC connection is not open";
		if(error_callback)
			error_callback(rq_id, shv::chainpack::RpcError("RPC connection is not open"));
	}
	return 0;
}

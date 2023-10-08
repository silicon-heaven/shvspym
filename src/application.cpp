#include "application.h"
#include "rpcconnection.h"
#include "settings.h"

#include <shv/iotqt/rpc/rpcresponsecallback.h>
#include <shv/coreqt/log.h>

Application::Application(int &argc, char **argv)
	: Super(argc, argv)
	, m_brokerListModel(new BrokerListModel(this))
	, m_crypt(shv::core::utils::Crypt::createGenerator(17456, 3148, 2147483647))
	, m_rpcConnection(new RpcConnection(this))
	, m_settings(new Settings(this))
{
	connect(m_rpcConnection, &RpcConnection::brokerConnectedChanged, this, &Application::brokerConnectedChanged);
	connect(m_rpcConnection, &RpcConnection::brokerLoginError, this, [this](const shv::chainpack::RpcError &err) {
		shvError() << "connect to broker error:" << err.toString();
		emit connetToBrokerError(QString::fromStdString(err.toString()));
	});
}

void Application::connectToBroker(int connection_id)
{
	shvInfo() << __PRETTY_FUNCTION__;
	m_rpcConnection->close();
	auto props = m_brokerListModel->brokerPropertiesStruct(connection_id);
	m_rpcConnection->setConnectionString(props.connectionString());
	shvInfo() << "connecting to broker:" << m_rpcConnection->connectionUrl().toDisplayString();
	m_rpcConnection->open();
}

void Application::callLs(const QString &shv_path)
{
	callRpcMethod(shv_path, "ls", {}, this,
		[this, shv_path](int rq_id, const auto &result) {
			//shvInfo() << result.toStringList().join(',');
			emit nodesLoaded(shv_path, result.toStringList());
		}
	);
}

void Application::callDir(const QString &shv_path)
{
	callRpcMethod(shv_path, "dir", {}, this,
		[this, shv_path](int rq_id, const QVariant &result) {
			QVariantList dir;
			for(const auto &v : result.toList()) {
				QVariantMap method;
				if(v.userType() == qMetaTypeId<QString>()) {
					method = QVariantMap{{"name", v.toString()}};
				}
				else if(v.userType() == qMetaTypeId<QVariantMap>()) {
					method = v.toMap();
				}
				else {
					shvWarning() << "Unsupported method description type:" << shv::coreqt::rpc::qVariantToRpcValue(v).toCpon();
				}
				if(!method.contains("flags")) {
					method["flags"] = 0; // flags is required property
				}
				dir << method;
			}
			emit methodsLoaded(shv_path, dir);
		}
	);
}

int Application::callMethod(const QString &shv_path, const QString &method)
{
	return callRpcMethod(shv_path, method, {}, this,
		[this, shv_path](int rq_id, const auto &result) {
			auto cpon = shv::coreqt::rpc::qVariantToRpcValue(result).toCpon();
			shvInfo() << cpon;
			emit methodCallResult(rq_id, QString::fromStdString(cpon), false);
		},
		[this, shv_path](int rq_id, const auto &error) {
			shvError() << error.toString();
			emit methodCallResult(rq_id, QString::fromStdString(error.toString()), true);
		}
	);
}

int Application::callRpcMethod(const QString &shv_path, const QString &method, const QVariant &params, const QObject *context
							 , std::function<void (int rq_id, const QVariant &)> success_callback
							 , std::function<void (int rq_id, const shv::chainpack::RpcError &)> error_callback)
{
	if(context == nullptr && (success_callback || error_callback))
		shvWarning() << shv_path << method << "Context object is NULL";
	auto *rpcc = shv::iotqt::rpc::RpcCall::create(m_rpcConnection);
	auto rq_id = m_rpcConnection->nextRequestId();
	rpcc->setShvPath(shv_path)
			->setMethod(method)
			->setParams(shv::coreqt::rpc::qVariantToRpcValue(params))
			->setRequestId(rq_id);
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

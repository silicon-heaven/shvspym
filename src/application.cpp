#include "application.h"
#include "rpcconnection.h"

#include <shv/iotqt/rpc/rpcresponsecallback.h>
#include <shv/coreqt/log.h>

Application::Application(int &argc, char **argv)
	: Super(argc, argv)
	, m_brokerListModel(new BrokerListModel(this))
	, m_crypt(shv::core::utils::Crypt::createGenerator(17456, 3148, 2147483647))
	, m_rpcConnection(new RpcConnection(this))
{
	connect(m_rpcConnection, &RpcConnection::brokerConnectedChanged, this, &Application::brokerConnectedChanged);
	connect(m_rpcConnection, &RpcConnection::brokerLoginError, this, [this](const shv::chainpack::RpcError &err) {
		emit connetToBrokerError(QString::fromStdString(err.toString()));
	});
}

void Application::connectToBroker(int connection_id)
{
	m_rpcConnection->close();
	auto props = m_brokerListModel->brokerPropertiesStruct(connection_id);
	m_rpcConnection->setConnectionString(props.connectionString());
	m_rpcConnection->open();
}

void Application::lsNodes(const QString &shv_path)
{
	callMethod(shv_path, "ls", {}, this,
		[this, shv_path](const auto &result) {
			shvInfo() << result.toStringList().join(',');
			emit nodesLoaded(shv_path, result.toStringList());
		}
	);
}

void Application::callMethod(const QString &shv_path, const QString &method, const QVariant &params, const QObject *context
							 , std::function<void (const QVariant &)> success_callback
							 , std::function<void (const shv::chainpack::RpcError &)> error_callback)
{
	if(context == nullptr && (success_callback || error_callback))
		shvWarning() << shv_path << method << "Context object is NULL";
	auto *rpcc = shv::iotqt::rpc::RpcCall::create(m_rpcConnection);
	rpcc->setShvPath(shv_path)
			->setMethod(method)
			->setParams(shv::coreqt::rpc::qVariantToRpcValue(params));
	if (rpcc) {
		if(success_callback) {
			connect(rpcc, &shv::iotqt::rpc::RpcCall::result, context, [success_callback](const ::shv::chainpack::RpcValue &result) {
				QVariant rv = shv::coreqt::rpc::rpcValueToQVariant(result);
				success_callback(rv);
			});
		}
		if(error_callback) {
			connect(rpcc, &shv::iotqt::rpc::RpcCall::error, context, [error_callback](const shv::chainpack::RpcError &error) {
				error_callback(error);
			});
		}
		else {
			connect(rpcc, &shv::iotqt::rpc::RpcCall::error, [method, shv_path](const shv::chainpack::RpcError &error) {
				shvError() << "Call method:" << method << "on path:" << shv_path << "error:" << error.toString();
			});
		}
		rpcc->start();
	}
	else {
		shvWarning() << shv_path << method << "RPC connection is not open";
		if(error_callback)
			error_callback(shv::chainpack::RpcError("RPC connection is not open"));
	}
}

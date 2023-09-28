#include "application.h"
#include "rpcconnection.h"

Application::Application(int &argc, char **argv)
	: Super(argc, argv)
	, m_brokerListModel(new BrokerListModel(this))
	, m_crypt(shv::core::utils::Crypt::createGenerator(17456, 3148, 2147483647))
	, m_rpcConnection(new RpcConnection(this))
{
}

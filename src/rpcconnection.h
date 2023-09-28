#ifndef RPCCONNECTION_H
#define RPCCONNECTION_H

#include <shv/iotqt/rpc/clientconnection.h>

class RpcConnection : public shv::iotqt::rpc::ClientConnection
{
	Q_OBJECT

	using Super = shv::iotqt::rpc::ClientConnection;
public:
	explicit RpcConnection(QObject *parent = nullptr);
};

#endif // RPCCONNECTION_H

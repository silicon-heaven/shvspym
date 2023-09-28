#ifndef APPLICATION_H
#define APPLICATION_H

#include "brokerlistmodel.h"

#include <shv/core/utils/crypt.h>

#include <QGuiApplication>
#include <QObject>

class RpcConnection;

class Application : public QGuiApplication
{
	Q_OBJECT
	using Super = QGuiApplication;

	Q_PROPERTY(QObject* brokerListModel READ brokerListModelObject)
public:
	Application(int &argc, char **argv);

	static Application* instance() {return qobject_cast<Application*>(Super::instance());}
	QObject* brokerListModelObject() { return m_brokerListModel; }

	const shv::core::utils::Crypt& crypt() {return m_crypt;}

private:
	BrokerListModel *m_brokerListModel;
	shv::core::utils::Crypt m_crypt;
	RpcConnection *m_rpcConnection;
};

#endif // APPLICATION_H

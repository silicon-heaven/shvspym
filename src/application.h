#ifndef APPLICATION_H
#define APPLICATION_H

#include "brokerlistmodel.h"

#include <shv/core/utils/crypt.h>

#include <QGuiApplication>
#include <QObject>

namespace shv::chainpack { class RpcError; }
class RpcConnection;

class Application : public QGuiApplication
{
	Q_OBJECT
	using Super = QGuiApplication;

	Q_PROPERTY(QObject* brokerListModel READ brokerListModelObject CONSTANT)

public:
	Application(int &argc, char **argv);

	Q_INVOKABLE void connectToBroker(int connection_id);
	Q_INVOKABLE void lsNodes(const QString &shv_path);

	Q_SIGNAL void brokerConnectedChanged(bool is_connected);
	Q_SIGNAL void connetToBrokerError(const QString &errmsg);
	Q_SIGNAL void nodesLoaded(const QString &shv_path,  const QStringList &nodes);

	static Application* instance() {return qobject_cast<Application*>(Super::instance());}
	QObject* brokerListModelObject() { return m_brokerListModel; }

	const shv::core::utils::Crypt& crypt() {return m_crypt;}

private:
	void callMethod(const QString &shv_path, const QString &method, const QVariant &params = QVariant(),
							const QObject *context = nullptr,
							std::function<void(const QVariant &)> success_callback = nullptr,
							std::function<void (const shv::chainpack::RpcError &)> error_callback = nullptr);
private:
	BrokerListModel *m_brokerListModel;
	shv::core::utils::Crypt m_crypt;
	RpcConnection *m_rpcConnection;
};

#endif // APPLICATION_H

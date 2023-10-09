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

	Q_PROPERTY(QString appVersion READ appVersion CONSTANT)
	Q_PROPERTY(QObject* brokerListModel READ brokerListModelObject CONSTANT)
	Q_PROPERTY(QObject* settings READ settings CONSTANT)

public:
	Application(int &argc, char **argv);

	Q_INVOKABLE void connectToBroker(int connection_id);
	Q_INVOKABLE void callLs(const QString &shv_path);
	Q_INVOKABLE void callDir(const QString &shv_path);
	Q_INVOKABLE int callMethod(const QString &shv_path, const QString &method);

	Q_SIGNAL void brokerConnectedChanged(bool is_connected);
	Q_SIGNAL void connetToBrokerError(const QString &errmsg);
	Q_SIGNAL void nodesLoaded(const QString &shv_path,  const QStringList &nodes);
	Q_SIGNAL void methodsLoaded(const QString &shv_path,  const QVariantList &methods);
	Q_SIGNAL void methodCallResult(int request_id, const QString &result, bool is_error);

	static Application* instance() {return qobject_cast<Application*>(Super::instance());}

	const shv::core::utils::Crypt& crypt() {return m_crypt;}

private:
	QString appVersion() const;
	QObject* brokerListModelObject() { return m_brokerListModel; }
	QObject* settings() { return m_settings; }

	int callRpcMethod(const QString &shv_path, const QString &method, const QVariant &params = QVariant(),
							const QObject *context = nullptr,
							std::function<void (int, const QVariant &)> success_callback = nullptr,
							std::function<void (int, const shv::chainpack::RpcError &)> error_callback = nullptr);
private:
	BrokerListModel *m_brokerListModel;
	shv::core::utils::Crypt m_crypt;
	RpcConnection *m_rpcConnection;
	QObject *m_settings;
};

#endif // APPLICATION_H

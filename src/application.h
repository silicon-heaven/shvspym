#ifndef APPLICATION_H
#define APPLICATION_H

#include "brokerlistmodel.h"
#include "subscriptionmodel.h"

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
	Q_PROPERTY(QObject* subscriptionModel READ subscriptionModelObject CONSTANT)
	Q_PROPERTY(QObject* settings READ settings CONSTANT)

public:
	Application(int &argc, char **argv);

	Q_INVOKABLE void connectToBroker(int connection_id);
	Q_INVOKABLE void callLs(const QString &shv_path);
	Q_INVOKABLE void callDir(const QString &shv_path);
	Q_INVOKABLE int callMethod(const QString &shv_path, const QString &method, const QVariant &params);

	Q_INVOKABLE QString variantToCpon(const QVariant &v);
	Q_INVOKABLE QVariant cponToVariant(const QString &cpon);
	Q_INVOKABLE QString checkCpon(const QString &cpon);

	Q_SIGNAL void brokerConnectedChanged(bool is_connected);
	Q_SIGNAL void connetToBrokerError(const QString &errmsg);
	Q_SIGNAL void nodesLoaded(const QString &shv_path,  const QStringList &nodes);
	Q_SIGNAL void methodsLoaded(const QString &shv_path,  const QVariantList &methods);
	Q_SIGNAL void methodCallResult(int request_id, const QString &result, bool is_error);
	Q_SIGNAL void methodCallInProcess(bool is_running);
	Q_SIGNAL void signalArrived(const QString &shv_path, const QString &method, const QDateTime &timestamp, const QVariant &value);

	static Application* instance() {return qobject_cast<Application*>(Super::instance());}

	const shv::core::utils::Crypt& crypt() {return m_crypt;}

	int callRpcMethod(const QString &shv_path, const QString &method, const QVariant &params = QVariant(),
							const QObject *context = nullptr,
							std::function<void (int, const QVariant &)> success_callback = nullptr,
							std::function<void (int, const shv::chainpack::RpcError &)> error_callback = nullptr);
private:
	QString appVersion() const;
	QObject* brokerListModelObject() { return m_brokerListModel; }
	QObject* subscriptionModelObject() { return m_subscriptionModel; }
	QObject* settings() { return m_settings; }
private:
	BrokerListModel *m_brokerListModel;
	SubscriptionModel *m_subscriptionModel;
	shv::core::utils::Crypt m_crypt;
	RpcConnection *m_rpcConnection;
	QObject *m_settings;
};

#endif // APPLICATION_H

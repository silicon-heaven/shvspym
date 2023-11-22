#pragma once

#include <QAbstractListModel>

class SubscriptionModel : public QAbstractListModel
{
	Q_OBJECT

	using Super = QAbstractListModel;
public:
	struct SubscriptionProperties
	{
		QString shvPath;
		QString method;
		bool isActive;
	};
public:
	enum SubscriptionRoles {
		ShvPathRole = Qt::UserRole + 1,
		MethodRole,
		IsActiveRole,
		ColumnCount
	};

public:
	explicit SubscriptionModel(QObject *parent = nullptr);

	Q_INVOKABLE int subscribeSignal(const QString &shv_path, const QString &method, bool subscribe);

	Q_SIGNAL void signalSubscribedChanged(const QString &shv_path, const QString &method, bool is_subscribed);

	void clear();

	int columnCount(const QModelIndex &parent = {}) const override { return ColumnCount; }
	int rowCount(const QModelIndex &parent = {}) const override { return m_subscriptions.count(); }
	QVariant data(const QModelIndex &index, int role) const override;
	QHash<int, QByteArray> roleNames() const override;
private:
	QList<SubscriptionProperties> m_subscriptions;
};


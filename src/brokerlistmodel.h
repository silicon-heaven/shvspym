#ifndef BROKERLISTMODEL_H
#define BROKERLISTMODEL_H

#include <QAbstractListModel>

class BrokerListModel : public QAbstractListModel
{
	Q_OBJECT

	using Super = QAbstractListModel;
public:
	struct BrokerProperties
	{
		int connectionId;
		QString name;
		QString scheme;
		QString host;
		int port = 0;
		QString user;
		QString password;

		QString connectionStringShort() const;
		QString connectionString() const;

		QVariantMap toMap() const;
		static BrokerProperties fromMap(const QVariantMap &m);
	};
public:
	enum BrokerPropertiesRoles {
		ConnectionIdRole = Qt::UserRole + 1,
		NameRole,
		ConnectionStringRole,
	};

public:
	explicit BrokerListModel(QObject *parent = nullptr);

	Q_INVOKABLE int addBroker(const QVariantMap &properties);
	Q_INVOKABLE void updateBroker(int connection_id, const QVariantMap &properties);
	Q_INVOKABLE void removeBroker(int connection_id);
	Q_INVOKABLE QVariantMap brokerProperties(int connection_id) const;

	BrokerProperties brokerPropertiesStruct(int connection_id) const;

	//QString connectionStringShort() const;

	int rowCount(const QModelIndex &parent = {}) const override { return m_brokers.count(); }
	QVariant data(const QModelIndex &index, int role) const override;
	QHash<int, QByteArray> roleNames() const override;
private:
	void saveBrokers();
	void loadBrokers();
private:
	QList<BrokerProperties> m_brokers;
};

#endif // BROKERLISTMODEL_H

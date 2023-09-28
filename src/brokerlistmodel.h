#ifndef BROKERLISTMODEL_H
#define BROKERLISTMODEL_H

#include <QAbstractListModel>

class BrokerListModel : public QAbstractListModel
{
	Q_OBJECT

	using Super = QAbstractListModel;
public:
	enum BrokerPropertiesRoles {
		ConnectionIdRole = Qt::UserRole + 1,
		NameRole,
	};

public:
	explicit BrokerListModel(QObject *parent = nullptr);

	int rowCount(const QModelIndex &parent = {}) const override { return m_brokers.count(); }
	QVariant data(const QModelIndex &index, int role) const override;
	QHash<int, QByteArray> roleNames() const override;
private:
	struct BrokerProperties
	{
		QString connectionId;
		QString name;
		QString connectionString;
	};
	QList<BrokerProperties> m_brokers;
};

#endif // BROKERLISTMODEL_H

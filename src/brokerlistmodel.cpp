#include "brokerlistmodel.h"

BrokerListModel::BrokerListModel(QObject *parent)
	: Super{parent}
{
	m_brokers = {
		{.connectionId = "connection01", .name = "Nirvana", .connectionString = "tcp://test:test@nirvana.elektroline.cz"},
		{.connectionId = "connection02", .name = "Nirvana2", .connectionString = "tcp://test2:test@nirvana.elektroline.cz"},
	};
}

QVariant BrokerListModel::data(const QModelIndex &index, int role) const
{
	auto row = index.row();
	if(row >= 0 && row < rowCount()) {
		const auto &props = m_brokers.at(row);
		switch (role) {
		case ConnectionIdRole: return props.connectionId;
		case NameRole: return props.name;
		default: break;
		}
	}
	return {};
}

QHash<int, QByteArray> BrokerListModel::roleNames() const
{
	static QHash<int, QByteArray> roles = []() {
		QHash<int, QByteArray> roles;
		roles[ConnectionIdRole] = "connectionId";
		roles[NameRole] = "name";
		return roles;
	}();
	return roles;
}

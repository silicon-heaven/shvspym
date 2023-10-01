#include "brokerlistmodel.h"

#include <QSettings>

//using namespace std::string_literals;

BrokerListModel::BrokerListModel(QObject *parent)
	: Super{parent}
{
	m_brokers = {
		{.connectionId = 1, .name = "Nirvana", .connectionString = "tcp://test:test@nirvana.elektroline.cz"},
		{.connectionId = 2, .name = "Nirvana2", .connectionString = "tcp://test2:test@nirvana.elektroline.cz"},
	};
}

int BrokerListModel::addBroker(const QVariantMap &properties)
{
	for(int new_id = 1; ; ++new_id) {
		bool exists = false;
		for(const auto &props : m_brokers) {
			if(props.connectionId == new_id) {
				exists = true;
				break;
			}
		}
		if(!exists) {
			auto pp = BrokerProperties::fromMap(properties);
			pp.connectionId = new_id;
			beginInsertRows({}, m_brokers.size(), m_brokers.size());
			m_brokers.append(pp);
			endInsertRows();
			return new_id;
		}
	}
}

void BrokerListModel::updateBroker(int connection_id, const QVariantMap &properties)
{
	for(qsizetype i = 0; i < m_brokers.size(); ++i) {
		if(m_brokers[i].connectionId == connection_id) {
			m_brokers[i] = BrokerProperties::fromMap(properties);
			emit dataChanged(index(i), index(i));
			return;
		}
	}
}

void BrokerListModel::removeBroker(int connection_id)
{
	for(qsizetype i = 0; i < m_brokers.size(); ++i) {
		if(m_brokers[i].connectionId == connection_id) {
			beginRemoveRows({}, i, i);
			m_brokers.removeAt(i);
			endRemoveRows();
			return;
		}
	}
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

namespace {
constexpr auto ConnectionId = "connectionId";
constexpr auto Name = "name";

constexpr auto Brokers = "brokers";
}

void BrokerListModel::saveBrokers()
{
	QSettings settings;
	QVariantList lst;
	for(const auto &props : m_brokers) {
		lst << props.toMap();
	}
	settings.setProperty(Brokers, lst);
}

void BrokerListModel::loadBrokers()
{
	beginResetModel();
	QSettings settings;
	auto lst = settings.property(Brokers).toList();
	for(const auto &v : lst) {
		m_brokers << BrokerProperties::fromMap(v.toMap());
	}
	endResetModel();
}

QHash<int, QByteArray> BrokerListModel::roleNames() const
{
	static QHash<int, QByteArray> roles = []() {
		QHash<int, QByteArray> roles;
		roles[ConnectionIdRole] = ConnectionId;
		roles[NameRole] = Name;
		return roles;
	}();
	return roles;
}

QVariantMap BrokerListModel::BrokerProperties::toMap() const
{
	QVariantMap ret;
	ret[ConnectionId] = connectionId;
	ret[Name] = name;
	return ret;
}

BrokerListModel::BrokerProperties BrokerListModel::BrokerProperties::fromMap(const QVariantMap &m)
{
	return BrokerProperties {
		.connectionId = m.value(ConnectionId).toInt(),
		.name = m.value(Name).toString(),
	};
}

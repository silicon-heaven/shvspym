#include "brokerlistmodel.h"

#include <shv/coreqt/rpc.h>
#include <shv/coreqt/log.h>

#include <QSettings>

//using namespace std::string_literals;
using namespace shv::chainpack;
using namespace std;

BrokerListModel::BrokerListModel(QObject *parent)
	: Super{parent}
{
	loadBrokers();
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
			saveBrokers();
			return new_id;
		}
	}
}

void BrokerListModel::updateBroker(int connection_id, const QVariantMap &properties)
{
	if(connection_id == 0) {
		addBroker(properties);
		return;
	}
	for(qsizetype i = 0; i < m_brokers.size(); ++i) {
		if(m_brokers[i].connectionId == connection_id) {
			m_brokers[i] = BrokerProperties::fromMap(properties);
			emit dataChanged(index(i), index(i));
			saveBrokers();
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
			saveBrokers();
			return;
		}
	}
}

QVariantMap BrokerListModel::brokerProperties(int connection_id) const
{
	for(qsizetype i = 0; i < m_brokers.size(); ++i) {
		if(m_brokers[i].connectionId == connection_id) {
			return m_brokers[i].toMap();
		}
	}
	return {};
}

QVariant BrokerListModel::data(const QModelIndex &index, int role) const
{
	auto row = index.row();
	if(row >= 0 && row < rowCount()) {
		const auto &props = m_brokers.at(row);
		switch (role) {
		case ConnectionIdRole: return props.connectionId;
		case NameRole: return props.name;
		case ConnectionStringRole: return props.connectionStringShort();
		default: break;
		}
	}
	return {};
}

namespace {
constexpr auto ConnectionId = "connectionId";
constexpr auto ConnectionString = "connectionString";
constexpr auto Name = "name";
constexpr auto Scheme = "scheme";
constexpr auto Host = "host";

constexpr auto Brokers = "brokers";
}

void BrokerListModel::saveBrokers()
{
	QSettings settings;
	RpcValue::List lst;
	for(const auto &props : m_brokers) {
		auto m = props.toMap();
		lst.push_back(shv::coreqt::rpc::qVariantToRpcValue(m));
	}
	auto cpon = RpcValue{lst}.toCpon();
	settings.setValue(Brokers, QString::fromStdString(cpon));
}

void BrokerListModel::loadBrokers()
{
	beginResetModel();
	QSettings settings;
	auto cpon = settings.value(Brokers).toString().toStdString();
	if(cpon.empty())
		return;
	string err;
	auto rv = RpcValue::fromCpon(cpon, &err);
	if(err.empty()) {
		for(const auto &v : rv.asList()) {
			auto m = shv::coreqt::rpc::rpcValueToQVariant(v).toMap();
			m_brokers << BrokerProperties::fromMap(m);
		}
	}
	else {
		shvError() << "Parse config error:" << err;
	}
	endResetModel();
}

QHash<int, QByteArray> BrokerListModel::roleNames() const
{
	static QHash<int, QByteArray> roles = []() {
		QHash<int, QByteArray> roles;
		roles[ConnectionIdRole] = ConnectionId;
		roles[NameRole] = Name;
		roles[ConnectionStringRole] = ConnectionString;
		return roles;
	}();
	return roles;
}

QString BrokerListModel::BrokerProperties::connectionStringShort() const
{
	QString ret = scheme;
	ret += "://";
	ret += host;
	return ret;
}

QVariantMap BrokerListModel::BrokerProperties::toMap() const
{
	QVariantMap ret;
	ret[ConnectionId] = connectionId;
	ret[Name] = name;
	ret[Scheme] = scheme;
	ret[Host] = host;
	return ret;
}

BrokerListModel::BrokerProperties BrokerListModel::BrokerProperties::fromMap(const QVariantMap &m)
{
	return BrokerProperties {
		.connectionId = m.value(ConnectionId).toInt(),
				.name = m.value(Name).toString(),
				.scheme = m.value(Scheme).toString(),
				.host = m.value(Host).toString(),
	};
}

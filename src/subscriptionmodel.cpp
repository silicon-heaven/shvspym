#include "subscriptionmodel.h"
#include "application.h"

#include <shv/chainpack/rpcvalue.h>
#include <shv/chainpack/rpcmessage.h>
#include <shv/chainpack/rpc.h>
#include <shv/coreqt/rpc.h>
#include <shv/coreqt/log.h>

#include <QSettings>

//using namespace std::string_literals;
using namespace shv::chainpack;
using namespace std;

SubscriptionModel::SubscriptionModel(QObject *parent)
	: Super{parent}
{
}

int SubscriptionModel::subscribeSignal(const QString &shv_path, const QString &method, bool subscribe)
{
	qDebug() << "subscribe:" << shv_path << method << "subscribe:" << subscribe;
	auto *app = Application::instance();
	auto sub_meth = subscribe? Rpc::METH_SUBSCRIBE: Rpc::METH_UNSUBSCRIBE;
	auto params = shv::coreqt::rpc::rpcValueToQVariant(RpcValue::Map{
														   {Rpc::PAR_PATH, shv_path.toStdString()},
														   {Rpc::PAR_METHOD, method.toStdString()},
													   });
	return app->callRpcMethod(Rpc::DIR_BROKER_APP, sub_meth, params, this,
		[this, shv_path, method, subscribe](int rq_id, const auto &result) {
			for(qsizetype i = 0; i < m_subscriptions.size(); ++i) {
				auto &subs = m_subscriptions[i];
				if(subs.shvPath == shv_path) {
					subs.isActive = subscribe;
					emit dataChanged(createIndex(i, 0), createIndex(i, columnCount() - 1));
					emit signalSubscribedChanged(shv_path, method, subscribe);
					return;
				}
			}
			if(subscribe) {
				beginInsertRows({}, m_subscriptions.size(), m_subscriptions.size());
				SubscriptionProperties subs;
				subs.shvPath = shv_path;
				subs.method = method;
				subs.isActive = true;
				m_subscriptions.append(subs);
				endInsertRows();
			}
			emit signalSubscribedChanged(shv_path, method, subscribe);
		},
		[this, shv_path](int rq_id, const auto &error) {
			qDebug() << error.toString();
		}
	);
}

void SubscriptionModel::clear()
{
	beginResetModel();
	m_subscriptions.clear();
	endResetModel();
}

QVariant SubscriptionModel::data(const QModelIndex &index, int role) const
{
	auto row = index.row();
	if(row >= 0 && row < rowCount()) {
		const auto &props = m_subscriptions.at(row);
		switch (role) {
		case ShvPathRole: return props.shvPath;
		case MethodRole: return props.method;
		case IsActiveRole: return props.isActive;
		default: break;
		}
	}
	return {};
}

namespace {
constexpr auto ShvPath = "shvPath";
constexpr auto Method = "method";
constexpr auto IsActive = "isActive";
}

QHash<int, QByteArray> SubscriptionModel::roleNames() const
{
	static QHash<int, QByteArray> roles = []() {
		QHash<int, QByteArray> roles;
		roles[ShvPathRole] = ShvPath;
		roles[MethodRole] = Method;
		roles[IsActiveRole] = IsActive;
		return roles;
	}();
	return roles;
}


#include "application.h"

#include <QStandardItemModel>

Application::Application(int &argc, char **argv)
	: Super(argc, argv)
	, m_crypt(shv::core::utils::Crypt::createGenerator(17456, 3148, 2147483647))
{
	treeModel = new QStandardItemModel(this);
	QStandardItem *parent_item = treeModel->invisibleRootItem();
	for (int i = 0; i < 4; ++i) {
		QStandardItem *item = new QStandardItem(QString("item %0").arg(i));
		parent_item->appendRow(item);
		parent_item = item;
	}

}

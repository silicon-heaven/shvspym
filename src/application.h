#ifndef APPLICATION_H
#define APPLICATION_H

#include <shv/core/utils/crypt.h>

#include <QGuiApplication>
#include <QObject>

class QStandardItemModel;

class Application : public QGuiApplication
{
	Q_OBJECT
	using Super = QGuiApplication;
public:
	Application(int &argc, char **argv);

	static Application* instance() {return qobject_cast<Application*>(Super::instance());}

	const shv::core::utils::Crypt& crypt() {return m_crypt;}

	QStandardItemModel *treeModel;
private:
	shv::core::utils::Crypt m_crypt;
};

#endif // APPLICATION_H

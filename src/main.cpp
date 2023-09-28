#include "application.h"
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStandardItemModel>

int main(int argc, char *argv[])
{
	Application app(argc, argv);

	QQmlApplicationEngine engine;
	QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() {
		QCoreApplication::exit(-1);
	},
	Qt::QueuedConnection);

	//engine.setInitialProperties({{ "treeModel", app.treeModel }});
	engine.rootContext()->setContextProperty("treeModel", app.treeModel);
	engine.loadFromModule("shvspymqml", "Main");

	return app.exec();
}

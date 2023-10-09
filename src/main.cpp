#include "application.h"
#include "version.h"

#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStandardItemModel>

int main(int argc, char *argv[])
{
	QCoreApplication::setOrganizationName("Elektroline");
	QCoreApplication::setOrganizationDomain("elektroline.cz");
	QCoreApplication::setApplicationName("shvspym");
	QCoreApplication::setApplicationVersion(APP_VERSION);

	Application app(argc, argv);
	//app.setWindowIcon(QIcon(":/images/shvspy.svg"));

	QQmlApplicationEngine engine;
	QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() {
		QCoreApplication::exit(-1);
	},
	Qt::QueuedConnection);

	QStringList builtInStyles = {
		QLatin1String("Basic"),
		QLatin1String("Fusion"),
		QLatin1String("Imagine"),
		QLatin1String("Material"),
		QLatin1String("Universal")
	};
	engine.setInitialProperties({{ "builtInStyles", builtInStyles }});
	engine.rootContext()->setContextProperty("app", &app);
	engine.loadFromModule("shvspymqml", "Main");

	return app.exec();
}

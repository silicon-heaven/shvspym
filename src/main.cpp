#include "application.h"
#include "version.h"

#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStandardItemModel>

QtMessageHandler old_msg_handler = {};

void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
	QString file = context.file;
	if(auto ix = file.lastIndexOf('/'); ix >= 0)
		file = file.mid(ix + 1);
	auto msg2 = QStringLiteral("[%1:%2] %3").arg(file).arg(context.line).arg(msg);
	old_msg_handler(type, context, msg2);
}

int main(int argc, char *argv[])
{
	old_msg_handler = qInstallMessageHandler(myMessageOutput);

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

	engine.rootContext()->setContextProperty("app", &app);
	engine.loadFromModule("shvspym", "Main");

	return app.exec();
}

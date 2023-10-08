#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QColor>

class Settings : public QObject
{
	Q_OBJECT

	//Q_PROPERTY(bool isDarkModeActive READ isDarkModeActive NOTIFY isDarkModeActiveChanged)
	Q_PROPERTY(int fontSize READ fontSize CONSTANT)
	Q_PROPERTY(QColor backgroundColor READ backgroundColor CONSTANT)
	Q_PROPERTY(QColor headerColor READ headerColor CONSTANT)
	Q_PROPERTY(QColor headerTextColor READ headerTextColor CONSTANT)
	Q_PROPERTY(QColor buttonColor READ buttonColor CONSTANT)
	Q_PROPERTY(QColor buttonBorderColor READ buttonBorderColor CONSTANT)
	Q_PROPERTY(QColor delegateColor READ delegateColor CONSTANT)
	Q_PROPERTY(QColor delegateAltColor READ delegateAltColor CONSTANT)
public:
	explicit Settings(QObject *parent = nullptr);

private:
	int fontSize() { return m_fontSize; }
	QColor backgroundColor() { return m_backgroundColor; }
	QColor headerColor() { return m_headerColor; }
	QColor headerTextColor() { return m_headerTextColor; }
	QColor buttonColor() { return m_buttonColor; }
	QColor buttonBorderColor() { return m_buttonBorderColor; }
	QColor delegateColor() { return m_delegateColor; }
	QColor delegateAltColor() { return m_delegateAltColor; }

	void setThemeColor(const QColor &c);

private:
	int m_fontSize = 16;
	QColor m_backgroundColor;
	QColor m_headerColor;
	QColor m_headerTextColor;
	QColor m_buttonColor;
	QColor m_buttonBorderColor;
	QColor m_delegateColor;
	QColor m_delegateAltColor;

};

#endif // SETTINGS_H


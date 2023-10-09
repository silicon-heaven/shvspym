#include "settings.h"

Settings::Settings(QObject *parent)
	: QObject{parent}
{
	setThemeColor(QColor::fromString("#3f8716"));
}

void Settings::setThemeColor(const QColor &c)
{
	m_backgroundColor = Qt::white;
	m_headerColor = c;
	m_headerTextColor = Qt::white;
	m_buttonColor = c.lighter();
	m_buttonBorderColor = c;
	m_delegateAltColor = c.lighter().lighter().lighter();
	m_delegateColor = Qt::white;
}

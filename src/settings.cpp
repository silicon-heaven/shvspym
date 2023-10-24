#include "settings.h"

Settings::Settings(QObject *parent)
	: QObject{parent}
{
	setThemeColor(QColor::fromString("#3f8716"), QColor::fromString("cornflowerblue"));
}

void Settings::setThemeColor(const QColor &c1, const QColor &c2)
{
	m_backgroundColor = Qt::white;
	m_headerColor = c1;
	m_headerTextColor = Qt::white;

	m_buttonColor = c1.lighter();
	m_buttonBorderColor = c1;

	m_delegateColor = c1.lighter().lighter().lighter();
	m_delegateAltColor = Qt::white;

	m_delegateColor2 = c2.lighter();
	m_delegateAltColor2 = Qt::white;
}

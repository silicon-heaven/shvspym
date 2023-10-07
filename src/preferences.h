#ifndef PREFERENCES_H
#define PREFERENCES_H

#include <QObject>

class Preferences : public QObject
{
	Q_OBJECT

	Q_PROPERTY(int listDelegateHeight MEMBER m_listDelegateHeight CONSTANT)
public:
	explicit Preferences(QObject *parent = nullptr);

private:
	int m_listDelegateHeight = 50;

};

#endif // PREFERENCES_H

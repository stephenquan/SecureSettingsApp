//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

#ifndef __SecureSettings__
#define __SecureSettings__

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

#include <QObject>

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

class SecureSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int status READ status NOTIFY statusChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY statusTextChanged)

public:
    SecureSettings(QObject* parent = nullptr);
    virtual ~SecureSettings();

    Q_INVOKABLE QString value(const QString& key);
    Q_INVOKABLE void setValue(const QString& key, const QString& value);
    Q_INVOKABLE void deleteValue(const QString& key);

signals:
    void statusChanged();
    void statusTextChanged();

protected:
    static QString m_Service;

    int m_Status;
    QString m_StatusText;

    int status() const { return m_Status; }
    void setStatus(int status);

    QString statusText() const { return m_StatusText; }
    void setStatusText(const QString& statusText);

};

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

#endif

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

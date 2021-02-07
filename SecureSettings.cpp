//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

#include "SecureSettings.h"
#ifdef Q_OS_MACOS
#include "SecKeychainItem.h"
#endif

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

QString SecureSettings::m_Service("StephenQuan.SecureSettingsApp");

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

SecureSettings::SecureSettings(QObject* parent) :
    QObject(parent)
{
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

SecureSettings::~SecureSettings()
{
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

QString SecureSettings::value(const QString& key)
{
#ifdef Q_OS_MACOS
    SecKeychainItem item(m_Service, key);
    QString password = item.password();
    setStatus(item.status());
    setStatusText(item.errorMessage());
    return password;
#else
    return QString();
#endif
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

void SecureSettings::setValue(const QString& key, const QString& value)
{
#ifdef Q_OS_MACOS
    SecKeychainItem item(m_Service, key);
    item.setPassword(value);
    setStatus(item.status());
    setStatusText(item.errorMessage());
#else
    Q_UNUSED(key)
#endif
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

void SecureSettings::deleteValue(const QString& key)
{
#ifdef Q_OS_MACOS
    SecKeychainItem item(m_Service, key);
    item.deleteItem();
    setStatus(item.status());
    setStatusText(item.errorMessage());
#else
    Q_UNUSED(key)
#endif
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

void SecureSettings::setStatus(int status)
{
    if (status == m_Status)
    {
        return;
    }

    m_Status = status;

    emit statusChanged();
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

void SecureSettings::setStatusText(const QString& statusText)
{
    if (statusText == m_StatusText)
    {
        return;
    }

    m_StatusText = statusText;

    emit statusTextChanged();
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

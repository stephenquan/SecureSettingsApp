//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

#include "SecKeychainItem.h"
#include <Security/Security.h>
#include <Foundation/NSString.h>
#include <Foundation/NSData.h>
#include <QDebug>

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

SecKeychainItem::SecKeychainItem(QString service, QString account) :
    m_Service(service),
    m_Account(account),
    m_Length(0),
    m_Data(nullptr),
    m_ItemRef(nullptr)
{
    findItem();
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

SecKeychainItem::~SecKeychainItem()
{
    clear();
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

bool SecKeychainItem::findItem()
{
    clear();

    QByteArray serviceUTF8 = m_Service.toUtf8();
    QByteArray accountUTF8 = m_Account.toUtf8();

    OSStatus status = SecKeychainFindGenericPassword(
                NULL,
                static_cast<UInt32>(serviceUTF8.size()),
                serviceUTF8.constData(),
                static_cast<UInt32>(accountUTF8.size()),
                accountUTF8.constData(),
                &m_Length,
                &m_Data,
                &reinterpret_cast<SecKeychainItemRef&>(m_ItemRef)
                );

    setStatus(static_cast<int>(status));

    if (status != errSecSuccess)
    {
        qDebug() << Q_FUNC_INFO
                 << "line: " << __LINE__
                 << "status: " << status
                 <<  "error: " << m_ErrorMessage;
        return false;
    }

    return true;
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

void SecKeychainItem::setStatus(int status)
{
    m_Status = status;
    m_ErrorMessage = QString::fromCFString(SecCopyErrorMessageString(status, NULL));

    if (static_cast<OSStatus>(status) != errSecSuccess)
    {
        qDebug() << Q_FUNC_INFO
                 << "line: " << __LINE__
                 << "status: " << m_Status
                 << "error: " << m_ErrorMessage;
    }
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

void SecKeychainItem::clear()
{
    if (m_ItemRef != nullptr)
    {
        CFRelease(reinterpret_cast<SecKeychainItemRef&>(m_ItemRef));
        m_ItemRef = nullptr;
    }

    if (m_Data)
    {
        SecKeychainItemFreeContent(NULL, m_Data);
        m_Data = nullptr;
    }

    m_Length = 0;
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

QString SecKeychainItem::password() const
{
    if (!m_Data || !m_Length)
    {
        return QString();
    }

    NSData* nsData = [NSData dataWithBytes:m_Data length:m_Length];
    NSString* nsPassword = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    return QString::fromNSString(nsPassword);
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

void SecKeychainItem::setPassword(const QString& password)
{
    if (m_ItemRef != nullptr)
    {
        modifyPassword(password);
        return;
    }

    addPassword(password);
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

bool SecKeychainItem::addPassword(const QString& password)
{
    clear();

    QByteArray serviceUTF8 = m_Service.toUtf8();
    QByteArray accountUTF8 = m_Account.toUtf8();
    QByteArray passwordUTF8 = password.toUtf8();

    OSStatus status = SecKeychainAddGenericPassword(
                NULL,
                static_cast<UInt32>(serviceUTF8.length()),
                serviceUTF8.constData(),
                static_cast<UInt32>(accountUTF8.length()),
                accountUTF8.constData(),
                static_cast<UInt32>(passwordUTF8.length()),
                passwordUTF8.constData(),
                &reinterpret_cast<SecKeychainItemRef&>(m_ItemRef)
                );

    setStatus(static_cast<int>(status));

    if (status != errSecSuccess)
    {
        qDebug() << Q_FUNC_INFO
                 << "line: " << __LINE__
                 << "status: " << m_Status
                 << "error: " << m_ErrorMessage;
        return false;
    }

    return findItem();
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

bool SecKeychainItem::modifyPassword(const QString& password)
{
    if (m_ItemRef == nullptr)
    {
        return false;
    }

    QByteArray passwordUTF8 = password.toUtf8();

    OSStatus status = SecKeychainItemModifyAttributesAndData(
                reinterpret_cast<SecKeychainItemRef&>(m_ItemRef),
                NULL,
                static_cast<UInt32>(passwordUTF8.length()),
                passwordUTF8.constData()
                );

    setStatus(static_cast<int>(status));

    if (status != errSecSuccess)
    {
        qDebug() << Q_FUNC_INFO
                 << "line: " << __LINE__
                 << "status: " << m_Status
                 << "error: " << m_ErrorMessage;
        return false;
    }

    return findItem();
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

bool SecKeychainItem::deleteItem()
{
    if (m_ItemRef == nullptr)
    {
        //setStatus(errSecSuccess);
        return true;
    }

    OSStatus status = SecKeychainItemDelete(
                reinterpret_cast<SecKeychainItemRef&>(m_ItemRef)
                );

    setStatus(static_cast<int>(status));

    if (status != errSecSuccess)
    {
        qDebug() << Q_FUNC_INFO
                 << "line: " << __LINE__
                 << "status: " << m_Status
                 << "error: " << m_ErrorMessage;
        return false;
    }

    clear();

    return true;
}

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

#ifndef __SecKeychainItem__
#define __SecKeychainItem__

#include <QString>

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

class SecKeychainItem
{
public:
    SecKeychainItem(QString service, QString account);
    ~SecKeychainItem();

    bool valid() const { return m_ItemRef != nullptr && m_Data != nullptr; }
    int status() const { return m_Status; }
    QString errorMessage() const { return m_ErrorMessage; }
    QString password() const;
    void setPassword(const QString& password);
    bool deleteItem();

protected:
    QString m_Service;
    QString m_Account;
    u_int32_t m_Length;
    void* m_Data;
    void* m_ItemRef;
    int m_Status;
    QString m_ErrorMessage;

    void clear();

    bool findItem();

    bool addPassword(const QString& password);
    bool modifyPassword(const QString& password);

    void setStatus(int status);

};

//----------------------------------------------------------------------
//
//----------------------------------------------------------------------

#endif

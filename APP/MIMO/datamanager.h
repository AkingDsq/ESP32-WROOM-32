#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>
#include <QStandardPaths>
#include <QDir>
#include <QCryptographicHash>

class DataManager : public QObject
{
    Q_OBJECT
public:
    explicit DataManager(QObject *parent = nullptr);
    ~DataManager();

    // 初始化数据库
    bool initDatabase();
    // 添加用户
    bool addUser(QString name, int age, QString email);
    // 获取所有用户
    QVariantList getAllUsers();
    // 更新用户
    bool updateUser(int id, QString name, int age, QString email);
    // 删除用户
    bool deleteUser(int id);
    // 搜索用户
    QVariantList searchUsers(QString keyword);

    // User preferences
    bool saveUserPreferences(QString username, QVariantMap preferences);
    QVariantMap getUserPreferences(QString username);

    // 房间管理
    bool addRoom(QString username, QString roomName);
    bool deleteRoom(QString username, QString roomName);
    QStringList getRooms(QString username);

    // 设备管理
    bool saveDeviceSettings(const QString &username, const QString &deviceId, const QVariantMap &settings);
    QVariantMap getDeviceSettings(const QString &username, const QString &deviceId);

    // 测试
    QString lastError() const { return m_lastError; }

private:
    QSqlDatabase m_db;
    QString m_lastError;

    bool createTables();
    bool executeQuery(QSqlQuery query);

public slots:
    // User authentication
    bool checkUserExists(QString username);
    bool checkPhoneExists(QString phone);
    bool validateUser(QString username, QString password);
    bool registerUser(QString username, QString password, QString phone);
    bool updateUserLastLogin(QString username);
signals:
};

#endif // DATAMANAGER_H

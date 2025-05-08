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
#include <QTimer>

/******************************************************************************
 *
 * @file       datamanager.h
 * @brief      数据库相关，注册，登入，保存用户数据，加载用户数据
 *
 * @author     dsq
 * @date       2025/05/08
 * @history
 *****************************************************************************/

class DataManager : public QObject
{
    Q_OBJECT
    // 温度和湿度数据属性
    Q_PROPERTY(QVariantList tempData READ tempData NOTIFY dataChanged)
    Q_PROPERTY(QVariantList humidityData READ humidityData NOTIFY dataChanged)
    Q_PROPERTY(QVariantList timeLabels READ timeLabels NOTIFY dataChanged)
    Q_PROPERTY(int dataDisplayMode READ dataDisplayMode WRITE setDataDisplayMode NOTIFY dataDisplayModeChanged)

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
    // 获取用户创建时间
    QDateTime getUserCreatedTime(QString username);

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

    //===============温湿度===================//
    // 获取图表数据
    QVariantList tempData() const { return m_tempData; }
    QVariantList humidityData() const { return m_humidityData; }
    QVariantList timeLabels() const { return m_timeLabels; }

    //============================================//

private:
    QSqlDatabase m_db;
    QString m_lastError;

    bool createTables();
    bool executeQuery(QSqlQuery query);

    //=============//
    QVariantList m_tempData;
    QVariantList m_humidityData;
    QVariantList m_timeLabels;
    QTimer *m_cleanupTimer;
    void cleanupOldData();
    int m_dataDisplayMode = 0;

    void addInitialSensorData();
    //=================//

public slots:
    // User authentication
    bool checkUserExists(QString username);
    bool checkPhoneExists(QString phone);
    bool validateUser(QString username, QString password);
    bool registerUser(QString username, QString password, QString phone);
    bool updateUserLastLogin(QString username);

    //
    bool addSensorData(double temperature, double humidity);
    bool loadDataForPeriod(int periodType); // 0=今天, 1=本周
    int dataDisplayMode() { return m_dataDisplayMode; }
    void setDataDisplayMode(int mode) {
        if (m_dataDisplayMode != mode) {
            m_dataDisplayMode = mode;
            loadDataForPeriod(m_dataDisplayMode);
            emit dataDisplayModeChanged();
        }
    }

signals:
    //==========温度数据更新============//
    void dataChanged();
    void dataDisplayModeChanged();
};

#endif // DATAMANAGER_H

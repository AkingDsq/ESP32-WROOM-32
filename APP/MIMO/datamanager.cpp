#include "datamanager.h"

DataManager::DataManager(QObject *parent)
    : QObject{parent}
{
    // 初始化
    if(initDatabase()) qDebug() << "初始化成功";

    // 设置数据清理定时器 - 每天执行一次
    m_cleanupTimer = new QTimer(this);
    connect(m_cleanupTimer, &QTimer::timeout, this, &DataManager::cleanupOldData);
    m_cleanupTimer->start(24 * 60 * 60 * 1000); // 24小时
    // 在启动时执行一次清理
    cleanupOldData();
}
DataManager::~DataManager()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
}

bool DataManager::initDatabase()
{
    // 初始化数据库位置
    QString dbPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dbPath);

    // 创建目录如果不存在
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    // 文件
    QString dbFilePath = dir.absoluteFilePath("mimo.db");
    qDebug() << "数据库位置:" << dbFilePath;

    // if(QFile::exists(dbFilePath)){
    //     if(QFile::remove(dbFilePath)){
    //         qDebug() << "数据库已删除";
    //     }
    // }

    // 初始化数据库
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(dbFilePath);

    if (!m_db.open()) {
        m_lastError = "数据库打开失败: " + m_db.lastError().text();
        qDebug() << m_lastError;
        return false;
    }

    // 创建表
    if (!createTables()) {
        m_lastError = "建表失败";
        qDebug() << m_lastError;
        return false;
    }

    return true;
}

bool DataManager::createTables()
{
    qDebug() << "创建表格";
    // 用户表id,username,password,phone,last_login,created_at
    QSqlQuery userTableQuery;
    if (!userTableQuery.exec(
            "CREATE TABLE IF NOT EXISTS users ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "username TEXT UNIQUE NOT NULL, "
            "password TEXT NOT NULL, "
            "phone TEXT, "
            "last_login TEXT, "
            "created_at TEXT NOT NULL)")) {
        m_lastError = "创建users table失败: " + userTableQuery.lastError().text();
        return false;
    }

    // // 个性化表
    // QSqlQuery prefsTableQuery;
    // if (!prefsTableQuery.exec(
    //         "CREATE TABLE IF NOT EXISTS user_preferences ("
    //         "id INTEGER PRIMARY KEY AUTOINCREMENT, "
    //         "username TEXT NOT NULL, "
    //         "key TEXT NOT NULL, "
    //         "value TEXT, "
    //         "UNIQUE(username, key), "
    //         "FOREIGN KEY(username) REFERENCES users(username))")) {
    //     m_lastError = "Failed to create preferences table: " + prefsTableQuery.lastError().text();
    //     return false;
    // }

    // // 房间表
    // QSqlQuery roomsTableQuery;
    // if (!roomsTableQuery.exec(
    //         "CREATE TABLE IF NOT EXISTS rooms ("
    //         "id INTEGER PRIMARY KEY AUTOINCREMENT, "
    //         "username TEXT NOT NULL, "
    //         "room_name TEXT NOT NULL, "
    //         "created_at TEXT NOT NULL, "
    //         "UNIQUE(username, room_name), "
    //         "FOREIGN KEY(username) REFERENCES users(username))")) {
    //     m_lastError = "Failed to create rooms table: " + roomsTableQuery.lastError().text();
    //     return false;
    // }

    // // 设备表
    // QSqlQuery devicesTableQuery;
    // if (!devicesTableQuery.exec(
    //         "CREATE TABLE IF NOT EXISTS devices ("
    //         "id INTEGER PRIMARY KEY AUTOINCREMENT, "
    //         "username TEXT NOT NULL, "
    //         "device_id TEXT NOT NULL, "
    //         "device_name TEXT, "
    //         "device_type TEXT, "
    //         "room_name TEXT, "
    //         "created_at TEXT NOT NULL, "
    //         "UNIQUE(username, device_id), "
    //         "FOREIGN KEY(username) REFERENCES users(username), "
    //         "FOREIGN KEY(username, room_name) REFERENCES rooms(username, room_name))")) {
    //     m_lastError = "Failed to create devices table: " + devicesTableQuery.lastError().text();
    //     return false;
    // }

    // // 设备设置表
    // QSqlQuery deviceSettingsTableQuery;
    // if (!deviceSettingsTableQuery.exec(
    //         "CREATE TABLE IF NOT EXISTS device_settings ("
    //         "id INTEGER PRIMARY KEY AUTOINCREMENT, "
    //         "username TEXT NOT NULL, "
    //         "device_id TEXT NOT NULL, "
    //         "key TEXT NOT NULL, "
    //         "value TEXT, "
    //         "updated_at TEXT NOT NULL, "
    //         "UNIQUE(username, device_id, key), "
    //         "FOREIGN KEY(username, device_id) REFERENCES devices(username, device_id))")) {
    //     m_lastError = "Failed to create device_settings table: " + deviceSettingsTableQuery.lastError().text();
    //     return false;
    // }

    // 温湿度数据表
    QSqlQuery sensor_dataTableQuery;
    if (!sensor_dataTableQuery.exec(
            "CREATE TABLE IF NOT EXISTS sensor_data ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "timestamp INTEGER NOT NULL,"
            "temperature REAL,"
            "humidity REAL"
            ")")) {
        m_lastError = "创建温度数据表失败: " + sensor_dataTableQuery.lastError().text();
        return false;
    }
    // 为timestamp创建索引以加速查询
    QSqlQuery indexQuery;
    if (!indexQuery.exec("CREATE INDEX IF NOT EXISTS idx_timestamp ON sensor_data(timestamp)")) {
        qDebug() << "创建时间戳索引失败: " + indexQuery.lastError().text();
        // 这里不返回false，因为索引创建失败不是致命错误
    }
    //addInitialSensorData();

    // 初始化各数据库表格
    QSqlQuery checkUserQuery;
    checkUserQuery.prepare("SELECT COUNT(*) FROM users");
    if (!executeQuery(checkUserQuery) || !checkUserQuery.next()) {
        return false;
    }

    int userCount = checkUserQuery.value(0).toInt();
    qDebug() << "userCount:" << userCount;
    if (userCount == 0) {
        // 添加初始用户
        QSqlQuery insertUserQuery;
        QString password = "123456";
        QString hashedPassword = QString(QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex());

        insertUserQuery.prepare(
            "INSERT INTO users (username, password, phone, last_login, created_at) "
            "VALUES (:username, :password, :phone, :last_login, :created_at)");
        insertUserQuery.bindValue(":username", "AkingDsq");
        insertUserQuery.bindValue(":password", hashedPassword);
        insertUserQuery.bindValue(":phone", "18079463112");
        insertUserQuery.bindValue(":last_login", QDateTime::currentDateTime().toString(Qt::ISODate));
        insertUserQuery.bindValue(":created_at", QDateTime::currentDateTime().toString(Qt::ISODate));

        if (!executeQuery(insertUserQuery)) {
            return false;
        }

        // // Add default rooms
        // QStringList defaultRooms = {"客厅", "卧室", "厨房", "卫生间", "办公室"};
        // for (const QString &room : defaultRooms) {
        //     addRoom("AkingDsq", room);
        // }
    }

    //================初始化温湿度表============================//
    // 加载今日数据作为默认数据
    loadDataForPeriod(0);

    return true;
}

bool DataManager::executeQuery(QSqlQuery query)
{
    if (!query.exec()) {
        m_lastError = "语句失败: " + query.lastError().text();
        qDebug() << m_lastError;
        qDebug() << "当前语句是: " << query.lastQuery();
        return false;
    }
    return true;
}
// 获取用户创建时间
QDateTime DataManager::getUserCreatedTime(QString username)
{
    QDateTime createTime;

    QSqlQuery query;
    query.prepare("SELECT created_at FROM users WHERE username = :username");
    query.bindValue(":username", username);

    if (!executeQuery(query)) {
        return createTime;
    }

    if (query.next()) {
        // 获取字段值并转换
        createTime = query.value(0).toDateTime();
    }

    return createTime;
}

// 检测用户username是否存在
bool DataManager::checkUserExists(QString username)
{
    QSqlQuery query;
    query.prepare("SELECT COUNT(*) FROM users WHERE username = :username");
    query.bindValue(":username", username);

    if (!executeQuery(query) || !query.next()) {
        return false;
    }

    return query.value(0).toInt() > 0;
}
// 检测手机号是否存在
bool DataManager::checkPhoneExists(QString phone){
    QSqlQuery query;
    query.prepare("SELECT COUNT(*) FROM users WHERE phone = :phone");
    query.bindValue(":phone", phone);

    if (!executeQuery(query) || !query.next()) {
        return false;
    }

    return query.value(0).toInt() > 0;
}

// 检查用户名与密码是否匹配
bool DataManager::validateUser(QString username, QString password)
{
    // 加密
    QString hashedPassword = QString(QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex());

    QSqlQuery query;
    query.prepare("SELECT COUNT(*) FROM users WHERE username = :username AND password = :password");
    query.bindValue(":username", username);
    query.bindValue(":password", hashedPassword);

    if (!executeQuery(query) || !query.next()) {
        return false;
    }

    bool valid = query.value(0).toInt() > 0;
    if (valid) {
        // Update last login time if valid
        updateUserLastLogin(username);
    }

    return valid;
}
// 注册用户
bool DataManager::registerUser(QString username, QString password, QString phone)
{
    // 检测是否存在
    if (checkUserExists(username)) {
        m_lastError = "用户已存在";
        return false;
    }

    // 加密密码
    QString hashedPassword = QString(QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex());

    QSqlQuery query;
    query.prepare(
        "INSERT INTO users (username, password, phone, last_login, created_at) "
        "VALUES (:username, :password, :phone, :last_login, :created_at)");
    query.bindValue(":username", username);
    query.bindValue(":password", hashedPassword);
    query.bindValue(":phone", phone);
    query.bindValue(":last_login", QDateTime::currentDateTime().toString(Qt::ISODate));
    query.bindValue(":created_at", QDateTime::currentDateTime().toString(Qt::ISODate));

    return executeQuery(query);
}
// 更新用户上次登入时间
bool DataManager::updateUserLastLogin(QString username)
{
    QSqlQuery query;
    query.prepare("UPDATE users SET last_login = :last_login WHERE username = :username");
    query.bindValue(":last_login", QDateTime::currentDateTime().toString(Qt::ISODate));
    query.bindValue(":username", username);

    return executeQuery(query);
}
// // 保存用户偏好
// bool DataManager::saveUserPreferences(QString username, QVariantMap preferences)
// {
//     // Start a transaction for multiple inserts
//     m_db.transaction();

//     bool success = true;

//     for (auto it = preferences.begin(); it != preferences.end(); ++it) {
//         QSqlQuery query;
//         query.prepare(
//             "INSERT OR REPLACE INTO user_preferences (username, key, value) "
//             "VALUES (:username, :key, :value)");
//         query.bindValue(":username", username);
//         query.bindValue(":key", it.key());
//         query.bindValue(":value", it.value().toString());

//         if (!executeQuery(query)) {
//             success = false;
//             break;
//         }
//     }

//     if (success) {
//         m_db.commit();
//     } else {
//         m_db.rollback();
//     }

//     return success;
// }
// // 获取
// QVariantMap DataManager::getUserPreferences(QString username)
// {
//     QVariantMap preferences;

//     QSqlQuery query;
//     query.prepare("SELECT key, value FROM user_preferences WHERE username = :username");
//     query.bindValue(":username", username);

//     if (!executeQuery(query)) {
//         return preferences;
//     }

//     while (query.next()) {
//         QString key = query.value(0).toString();
//         QString value = query.value(1).toString();
//         preferences[key] = value;
//     }

//     return preferences;
// }
// // 添加房间
// bool DataManager::addRoom(QString username, QString roomName)
// {
//     QSqlQuery query;
//     query.prepare(
//         "INSERT OR IGNORE INTO rooms (username, room_name, created_at) "
//         "VALUES (:username, :room_name, :created_at)");
//     query.bindValue(":username", username);
//     query.bindValue(":room_name", roomName);
//     query.bindValue(":created_at", QDateTime::currentDateTime().toString(Qt::ISODate));

//     return executeQuery(query);
// }
// // 删除房间
// bool DataManager::deleteRoom(QString username, QString roomName)
// {
//     QSqlQuery query;
//     query.prepare("DELETE FROM rooms WHERE username = :username AND room_name = :room_name");
//     query.bindValue(":username", username);
//     query.bindValue(":room_name", roomName);

//     return executeQuery(query);
// }
// // 获取房间
// QStringList DataManager::getRooms(QString username)
// {
//     QStringList rooms;

//     QSqlQuery query;
//     query.prepare("SELECT room_name FROM rooms WHERE username = :username ORDER BY created_at");
//     query.bindValue(":username", username);

//     if (!executeQuery(query)) {
//         return rooms;
//     }

//     while (query.next()) {
//         rooms.append(query.value(0).toString());
//     }

//     return rooms;
// }

// bool DataManager::saveDeviceSettings(const QString &username, const QString &deviceId, const QVariantMap &settings)
// {
//     // Ensure the device exists
//     QSqlQuery checkQuery;
//     checkQuery.prepare("SELECT COUNT(*) FROM devices WHERE username = :username AND device_id = :device_id");
//     checkQuery.bindValue(":username", username);
//     checkQuery.bindValue(":device_id", deviceId);

//     if (!executeQuery(checkQuery) || !checkQuery.next()) {
//         return false;
//     }

//     int deviceCount = checkQuery.value(0).toInt();
//     if (deviceCount == 0) {
//         // Create device record first
//         QSqlQuery insertDeviceQuery;
//         insertDeviceQuery.prepare(
//             "INSERT INTO devices (username, device_id, device_name, device_type, created_at) "
//             "VALUES (:username, :device_id, :device_id, 'unknown', :created_at)");
//         insertDeviceQuery.bindValue(":username", username);
//         insertDeviceQuery.bindValue(":device_id", deviceId);
//         insertDeviceQuery.bindValue(":created_at", QDateTime::currentDateTime().toString(Qt::ISODate));

//         if (!executeQuery(insertDeviceQuery)) {
//             return false;
//         }
//     }

//     // Start a transaction for multiple inserts
//     m_db.transaction();

//     bool success = true;
//     QString currentDateTime = QDateTime::currentDateTime().toString(Qt::ISODate);

//     for (auto it = settings.begin(); it != settings.end(); ++it) {
//         QSqlQuery query;
//         query.prepare(
//             "INSERT OR REPLACE INTO device_settings (username, device_id, key, value, updated_at) "
//             "VALUES (:username, :device_id, :key, :value, :updated_at)");
//         query.bindValue(":username", username);
//         query.bindValue(":device_id", deviceId);
//         query.bindValue(":key", it.key());
//         query.bindValue(":value", it.value().toString());
//         query.bindValue(":updated_at", currentDateTime);

//         if (!executeQuery(query)) {
//             success = false;
//             break;
//         }
//     }

//     if (success) {
//         m_db.commit();
//     } else {
//         m_db.rollback();
//     }

//     return success;
// }

// QVariantMap DataManager::getDeviceSettings(const QString &username, const QString &deviceId)
// {
//     QVariantMap settings;

//     QSqlQuery query;
//     query.prepare("SELECT key, value FROM device_settings WHERE username = :username AND device_id = :device_id");
//     query.bindValue(":username", username);
//     query.bindValue(":device_id", deviceId);

//     if (!executeQuery(query)) {
//         return settings;
//     }

//     while (query.next()) {
//         QString key = query.value(0).toString();
//         QString value = query.value(1).toString();
//         settings[key] = value;
//     }

//     return settings;
// }

//===============================================温湿度表=================================================//
// 添加数据
bool DataManager::addSensorData(double temperature, double humidity)
{
    QSqlQuery query;
    query.prepare("INSERT INTO sensor_data (timestamp, temperature, humidity) "
                  "VALUES (:timestamp, :temperature, :humidity)");

    qint64 timestamp = QDateTime::currentSecsSinceEpoch();
    query.bindValue(":timestamp", timestamp);
    query.bindValue(":temperature", temperature);
    query.bindValue(":humidity", humidity);

    if (!query.exec()) {
        qDebug() << "添加传感器数据失败: " + query.lastError().text();
        return false;
    }

    // 重新加载当前周期的数据
    loadDataForPeriod(m_dataDisplayMode);  // 默认加载今日数据
    return true;
}
// 加载数据,0: 加载最近1天，1加载最近7天
bool DataManager::loadDataForPeriod(int periodType)
{
    m_tempData.clear();
    m_humidityData.clear();
    m_timeLabels.clear();

    QSqlQuery query;
    qint64 startTimestamp;
    qint64 endTimestamp = QDateTime::currentDateTime().toSecsSinceEpoch();

    // 动态计算起点时间
    QDateTime startTime = QDateTime::currentDateTime();
    if (periodType == 0) {  // 过去24小时
        startTime = startTime.addDays(-1);
    } else {  // 过去7天
        startTime = startTime.addDays(-7);
    }
    startTimestamp = startTime.toSecsSinceEpoch();

    query.prepare("SELECT timestamp, temperature, humidity "
                  "FROM sensor_data WHERE timestamp >= :start AND timestamp <= :end ORDER BY timestamp");
    query.bindValue(":start", startTimestamp);
    query.bindValue(":end", endTimestamp);

    if (!query.exec()) {
        qDebug() << "加载传感器数据失败: " + query.lastError().text();
        return false;
    }

    while (query.next()) {
        qint64 timestamp = query.value(0).toLongLong();
        QDateTime dateTime = QDateTime::fromSecsSinceEpoch(timestamp);

        m_tempData.append(query.value(1).toDouble());
        m_humidityData.append(query.value(2).toDouble());

        // 格式化时间标签
        QString timeLabel;
        if (periodType == 0) {
            timeLabel = dateTime.toString("HH:mm");
        } else {
            timeLabel = dateTime.toString("ddd HH:mm");
        }
        m_timeLabels.append(timeLabel);
    }

    emit dataChanged();
    return true;
}
// 清理旧数据的实现
void DataManager::cleanupOldData()
{
    qDebug() << "执行数据清理作业...";

    QSqlQuery query;
    qint64 oneWeekAgo = QDateTime::currentSecsSinceEpoch() - (7 * 24 * 60 * 60); // 7天前的时间戳

    // 开始事务处理
    m_db.transaction();

    // 清理传感器数据表
    query.prepare("DELETE FROM sensor_data WHERE timestamp < :old_time");
    query.bindValue(":old_time", oneWeekAgo);

    if (!query.exec()) {
        m_db.rollback();
        qDebug() << "清理旧数据失败: " + query.lastError().text();
        return;
    }

    // 清理事件表
    query.prepare("DELETE FROM events WHERE timestamp < :old_time");
    query.bindValue(":old_time", oneWeekAgo);

    if (!query.exec()) {
        m_db.rollback();
        qDebug() << "清理旧事件数据失败: " + query.lastError().text();
        return;
    }

    // 提交事务
    if (!m_db.commit()) {
        m_db.rollback();
        qDebug() << "提交事务失败: " + m_db.lastError().text();
        return;
    }

    qDebug() << "数据清理完成";

    // 通知界面更新数据
    loadDataForPeriod(m_dataDisplayMode);
}
//================================================================================================//

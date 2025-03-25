#include "datamanager.h"

DataManager::DataManager(QObject *parent)
    : QObject{parent}
{

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
        m_lastError = "Failed to create users table: " + userTableQuery.lastError().text();
        return false;
    }

    // 个性化表
    QSqlQuery prefsTableQuery;
    if (!prefsTableQuery.exec(
            "CREATE TABLE IF NOT EXISTS user_preferences ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "username TEXT NOT NULL, "
            "key TEXT NOT NULL, "
            "value TEXT, "
            "UNIQUE(username, key), "
            "FOREIGN KEY(username) REFERENCES users(username))")) {
        m_lastError = "Failed to create preferences table: " + prefsTableQuery.lastError().text();
        return false;
    }

    // 房间表
    QSqlQuery roomsTableQuery;
    if (!roomsTableQuery.exec(
            "CREATE TABLE IF NOT EXISTS rooms ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "username TEXT NOT NULL, "
            "room_name TEXT NOT NULL, "
            "created_at TEXT NOT NULL, "
            "UNIQUE(username, room_name), "
            "FOREIGN KEY(username) REFERENCES users(username))")) {
        m_lastError = "Failed to create rooms table: " + roomsTableQuery.lastError().text();
        return false;
    }

    // Devices table
    QSqlQuery devicesTableQuery;
    if (!devicesTableQuery.exec(
            "CREATE TABLE IF NOT EXISTS devices ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "username TEXT NOT NULL, "
            "device_id TEXT NOT NULL, "
            "device_name TEXT, "
            "device_type TEXT, "
            "room_name TEXT, "
            "created_at TEXT NOT NULL, "
            "UNIQUE(username, device_id), "
            "FOREIGN KEY(username) REFERENCES users(username), "
            "FOREIGN KEY(username, room_name) REFERENCES rooms(username, room_name))")) {
        m_lastError = "Failed to create devices table: " + devicesTableQuery.lastError().text();
        return false;
    }

    // Device settings table
    QSqlQuery deviceSettingsTableQuery;
    if (!deviceSettingsTableQuery.exec(
            "CREATE TABLE IF NOT EXISTS device_settings ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "username TEXT NOT NULL, "
            "device_id TEXT NOT NULL, "
            "key TEXT NOT NULL, "
            "value TEXT, "
            "updated_at TEXT NOT NULL, "
            "UNIQUE(username, device_id, key), "
            "FOREIGN KEY(username, device_id) REFERENCES devices(username, device_id))")) {
        m_lastError = "Failed to create device_settings table: " + deviceSettingsTableQuery.lastError().text();
        return false;
    }

    // 初始化各数据库表格
    QSqlQuery checkUserQuery;
    checkUserQuery.prepare("SELECT COUNT(*) FROM users");
    if (!executeQuery(checkUserQuery) || !checkUserQuery.next()) {
        return false;
    }

    int userCount = checkUserQuery.value(0).toInt();
    if (userCount == 0) {
        // Create default user
        QSqlQuery insertUserQuery;
        QString hashedPassword = QString(QCryptographicHash::hash("password", QCryptographicHash::Sha256).toHex());

        insertUserQuery.prepare(
            "INSERT INTO users (username, password, phone, created_at) "
            "VALUES (:username, :password, :phone, :created_at)");
        insertUserQuery.bindValue(":username", "AkingDsq");
        insertUserQuery.bindValue(":password", hashedPassword);
        insertUserQuery.bindValue(":phone", "13800138000");
        insertUserQuery.bindValue(":created_at", QDateTime::currentDateTime().toString(Qt::ISODate));

        if (!executeQuery(insertUserQuery)) {
            return false;
        }

        // Add default rooms
        QStringList defaultRooms = {"客厅", "卧室", "厨房", "卫生间", "办公室"};
        for (const QString &room : defaultRooms) {
            addRoom("AkingDsq", room);
        }
    }

    return true;
}

bool DataManager::executeQuery(QSqlQuery query)
{
    if (!query.exec()) {
        m_lastError = "Query failed: " + query.lastError().text();
        qDebug() << m_lastError;
        qDebug() << "Query was: " << query.lastQuery();
        return false;
    }
    return true;
}

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

bool DataManager::validateUser(QString username, QString password)
{
    // Hash the provided password
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

bool DataManager::registerUser(QString username, QString password, QString phone)
{
    // Check if user already exists
    if (checkUserExists(username)) {
        m_lastError = "Username already taken";
        return false;
    }

    // Hash the password for security
    QString hashedPassword = QString(QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex());

    QSqlQuery query;
    query.prepare(
        "INSERT INTO users (username, password, phone, created_at) "
        "VALUES (:username, :password, :phone, :created_at)");
    query.bindValue(":username", username);
    query.bindValue(":password", hashedPassword);
    query.bindValue(":phone", phone);
    query.bindValue(":created_at", QDateTime::currentDateTime().toString(Qt::ISODate));

    return executeQuery(query);
}

bool DataManager::updateUserLastLogin(QString username)
{
    QSqlQuery query;
    query.prepare("UPDATE users SET last_login = :last_login WHERE username = :username");
    query.bindValue(":last_login", QDateTime::currentDateTime().toString(Qt::ISODate));
    query.bindValue(":username", username);

    return executeQuery(query);
}

bool DataManager::saveUserPreferences(QString username, QVariantMap preferences)
{
    // Start a transaction for multiple inserts
    m_db.transaction();

    bool success = true;

    for (auto it = preferences.begin(); it != preferences.end(); ++it) {
        QSqlQuery query;
        query.prepare(
            "INSERT OR REPLACE INTO user_preferences (username, key, value) "
            "VALUES (:username, :key, :value)");
        query.bindValue(":username", username);
        query.bindValue(":key", it.key());
        query.bindValue(":value", it.value().toString());

        if (!executeQuery(query)) {
            success = false;
            break;
        }
    }

    if (success) {
        m_db.commit();
    } else {
        m_db.rollback();
    }

    return success;
}

QVariantMap DataManager::getUserPreferences(QString username)
{
    QVariantMap preferences;

    QSqlQuery query;
    query.prepare("SELECT key, value FROM user_preferences WHERE username = :username");
    query.bindValue(":username", username);

    if (!executeQuery(query)) {
        return preferences;
    }

    while (query.next()) {
        QString key = query.value(0).toString();
        QString value = query.value(1).toString();
        preferences[key] = value;
    }

    return preferences;
}

bool DataManager::addRoom(QString username, QString roomName)
{
    QSqlQuery query;
    query.prepare(
        "INSERT OR IGNORE INTO rooms (username, room_name, created_at) "
        "VALUES (:username, :room_name, :created_at)");
    query.bindValue(":username", username);
    query.bindValue(":room_name", roomName);
    query.bindValue(":created_at", QDateTime::currentDateTime().toString(Qt::ISODate));

    return executeQuery(query);
}

bool DataManager::deleteRoom(QString username, QString roomName)
{
    QSqlQuery query;
    query.prepare("DELETE FROM rooms WHERE username = :username AND room_name = :room_name");
    query.bindValue(":username", username);
    query.bindValue(":room_name", roomName);

    return executeQuery(query);
}

QStringList DataManager::getRooms(QString username)
{
    QStringList rooms;

    QSqlQuery query;
    query.prepare("SELECT room_name FROM rooms WHERE username = :username ORDER BY created_at");
    query.bindValue(":username", username);

    if (!executeQuery(query)) {
        return rooms;
    }

    while (query.next()) {
        rooms.append(query.value(0).toString());
    }

    return rooms;
}

bool DataManager::saveDeviceSettings(const QString &username, const QString &deviceId, const QVariantMap &settings)
{
    // Ensure the device exists
    QSqlQuery checkQuery;
    checkQuery.prepare("SELECT COUNT(*) FROM devices WHERE username = :username AND device_id = :device_id");
    checkQuery.bindValue(":username", username);
    checkQuery.bindValue(":device_id", deviceId);

    if (!executeQuery(checkQuery) || !checkQuery.next()) {
        return false;
    }

    int deviceCount = checkQuery.value(0).toInt();
    if (deviceCount == 0) {
        // Create device record first
        QSqlQuery insertDeviceQuery;
        insertDeviceQuery.prepare(
            "INSERT INTO devices (username, device_id, device_name, device_type, created_at) "
            "VALUES (:username, :device_id, :device_id, 'unknown', :created_at)");
        insertDeviceQuery.bindValue(":username", username);
        insertDeviceQuery.bindValue(":device_id", deviceId);
        insertDeviceQuery.bindValue(":created_at", QDateTime::currentDateTime().toString(Qt::ISODate));

        if (!executeQuery(insertDeviceQuery)) {
            return false;
        }
    }

    // Start a transaction for multiple inserts
    m_db.transaction();

    bool success = true;
    QString currentDateTime = QDateTime::currentDateTime().toString(Qt::ISODate);

    for (auto it = settings.begin(); it != settings.end(); ++it) {
        QSqlQuery query;
        query.prepare(
            "INSERT OR REPLACE INTO device_settings (username, device_id, key, value, updated_at) "
            "VALUES (:username, :device_id, :key, :value, :updated_at)");
        query.bindValue(":username", username);
        query.bindValue(":device_id", deviceId);
        query.bindValue(":key", it.key());
        query.bindValue(":value", it.value().toString());
        query.bindValue(":updated_at", currentDateTime);

        if (!executeQuery(query)) {
            success = false;
            break;
        }
    }

    if (success) {
        m_db.commit();
    } else {
        m_db.rollback();
    }

    return success;
}

QVariantMap DataManager::getDeviceSettings(const QString &username, const QString &deviceId)
{
    QVariantMap settings;

    QSqlQuery query;
    query.prepare("SELECT key, value FROM device_settings WHERE username = :username AND device_id = :device_id");
    query.bindValue(":username", username);
    query.bindValue(":device_id", deviceId);

    if (!executeQuery(query)) {
        return settings;
    }

    while (query.next()) {
        QString key = query.value(0).toString();
        QString value = query.value(1).toString();
        settings[key] = value;
    }

    return settings;
}

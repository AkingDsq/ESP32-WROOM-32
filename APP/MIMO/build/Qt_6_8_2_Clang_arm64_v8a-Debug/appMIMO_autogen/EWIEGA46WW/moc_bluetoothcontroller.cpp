/****************************************************************************
** Meta object code from reading C++ file 'bluetoothcontroller.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.8.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../bluetoothcontroller.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'bluetoothcontroller.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 68
#error "This file was generated using the moc from 6.8.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN19BlueToothControllerE_t {};
} // unnamed namespace


#ifdef QT_MOC_HAS_STRINGDATA
static constexpr auto qt_meta_stringdata_ZN19BlueToothControllerE = QtMocHelpers::stringData(
    "BlueToothController",
    "temperatureChanged",
    "",
    "temperature",
    "humidityChanged",
    "humidity",
    "connectionStatusChanged",
    "connected",
    "commandSent",
    "success",
    "commandVoiceSent",
    "checkBluetoothPermission",
    "checkLocationPermission",
    "checkMicrophonePermission",
    "startScan",
    "connectDevice",
    "address",
    "QBluetoothDeviceInfo",
    "info",
    "sendCommand",
    "command",
    "sendVoiceCommand",
    "onDeviceDiscovered",
    "onScanFinished",
    "serviceDiscovered",
    "QBluetoothUuid",
    "uuid",
    "serviceStateChanged",
    "QLowEnergyService::ServiceState",
    "state",
    "characteristicChanged",
    "QLowEnergyCharacteristic",
    "characteristic",
    "newValue",
    "controllerStateChanged",
    "QLowEnergyController::ControllerState",
    "errorOccurred",
    "QLowEnergyController::Error",
    "error"
);
#else  // !QT_MOC_HAS_STRINGDATA
#error "qtmochelpers.h not found or too old."
#endif // !QT_MOC_HAS_STRINGDATA

Q_CONSTINIT static const uint qt_meta_data_ZN19BlueToothControllerE[] = {

 // content:
      12,       // revision
       0,       // classname
       0,    0, // classinfo
      19,   14, // methods
       2,  179, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       5,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    1,  128,    2, 0x06,    3 /* Public */,
       4,    1,  131,    2, 0x06,    5 /* Public */,
       6,    1,  134,    2, 0x06,    7 /* Public */,
       8,    1,  137,    2, 0x06,    9 /* Public */,
      10,    1,  140,    2, 0x06,   11 /* Public */,

 // slots: name, argc, parameters, tag, flags, initial metatype offsets
      11,    0,  143,    2, 0x0a,   13 /* Public */,
      12,    0,  144,    2, 0x0a,   14 /* Public */,
      13,    0,  145,    2, 0x0a,   15 /* Public */,
      14,    0,  146,    2, 0x0a,   16 /* Public */,
      15,    2,  147,    2, 0x0a,   17 /* Public */,
      19,    1,  152,    2, 0x0a,   20 /* Public */,
      21,    1,  155,    2, 0x0a,   22 /* Public */,
      22,    1,  158,    2, 0x08,   24 /* Private */,
      23,    0,  161,    2, 0x08,   26 /* Private */,
      24,    1,  162,    2, 0x08,   27 /* Private */,
      27,    1,  165,    2, 0x08,   29 /* Private */,
      30,    2,  168,    2, 0x08,   31 /* Private */,
      34,    1,  173,    2, 0x08,   34 /* Private */,
      36,    1,  176,    2, 0x08,   36 /* Private */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::Bool,    7,
    QMetaType::Void, QMetaType::Bool,    9,
    QMetaType::Void, QMetaType::Bool,    9,

 // slots: parameters
    QMetaType::Bool,
    QMetaType::Bool,
    QMetaType::Bool,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString, 0x80000000 | 17,   16,   18,
    QMetaType::Void, QMetaType::QString,   20,
    QMetaType::Void, QMetaType::QString,   20,
    QMetaType::Void, 0x80000000 | 17,   18,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 25,   26,
    QMetaType::Void, 0x80000000 | 28,   29,
    QMetaType::Void, 0x80000000 | 31, QMetaType::QByteArray,   32,   33,
    QMetaType::Void, 0x80000000 | 35,   29,
    QMetaType::Void, 0x80000000 | 37,   38,

 // properties: name, type, flags, notifyId, revision
       3, QMetaType::QString, 0x00015001, uint(0), 0,
       5, QMetaType::QString, 0x00015001, uint(1), 0,

       0        // eod
};

Q_CONSTINIT const QMetaObject BlueToothController::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_ZN19BlueToothControllerE.offsetsAndSizes,
    qt_meta_data_ZN19BlueToothControllerE,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_tag_ZN19BlueToothControllerE_t,
        // property 'temperature'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // property 'humidity'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<BlueToothController, std::true_type>,
        // method 'temperatureChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QString, std::false_type>,
        // method 'humidityChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QString, std::false_type>,
        // method 'connectionStatusChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        // method 'commandSent'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        // method 'commandVoiceSent'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        // method 'checkBluetoothPermission'
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        // method 'checkLocationPermission'
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        // method 'checkMicrophonePermission'
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        // method 'startScan'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'connectDevice'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QString, std::false_type>,
        QtPrivate::TypeAndForceComplete<QBluetoothDeviceInfo, std::false_type>,
        // method 'sendCommand'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QString, std::false_type>,
        // method 'sendVoiceCommand'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QString, std::false_type>,
        // method 'onDeviceDiscovered'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QBluetoothDeviceInfo, std::false_type>,
        // method 'onScanFinished'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'serviceDiscovered'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QBluetoothUuid, std::false_type>,
        // method 'serviceStateChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QLowEnergyService::ServiceState, std::false_type>,
        // method 'characteristicChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QLowEnergyCharacteristic, std::false_type>,
        QtPrivate::TypeAndForceComplete<QByteArray, std::false_type>,
        // method 'controllerStateChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QLowEnergyController::ControllerState, std::false_type>,
        // method 'errorOccurred'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QLowEnergyController::Error, std::false_type>
    >,
    nullptr
} };

void BlueToothController::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<BlueToothController *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->temperatureChanged((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 1: _t->humidityChanged((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 2: _t->connectionStatusChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 3: _t->commandSent((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 4: _t->commandVoiceSent((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 5: { bool _r = _t->checkBluetoothPermission();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 6: { bool _r = _t->checkLocationPermission();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 7: { bool _r = _t->checkMicrophonePermission();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 8: _t->startScan(); break;
        case 9: _t->connectDevice((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QBluetoothDeviceInfo>>(_a[2]))); break;
        case 10: _t->sendCommand((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 11: _t->sendVoiceCommand((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 12: _t->onDeviceDiscovered((*reinterpret_cast< std::add_pointer_t<QBluetoothDeviceInfo>>(_a[1]))); break;
        case 13: _t->onScanFinished(); break;
        case 14: _t->serviceDiscovered((*reinterpret_cast< std::add_pointer_t<QBluetoothUuid>>(_a[1]))); break;
        case 15: _t->serviceStateChanged((*reinterpret_cast< std::add_pointer_t<QLowEnergyService::ServiceState>>(_a[1]))); break;
        case 16: _t->characteristicChanged((*reinterpret_cast< std::add_pointer_t<QLowEnergyCharacteristic>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QByteArray>>(_a[2]))); break;
        case 17: _t->controllerStateChanged((*reinterpret_cast< std::add_pointer_t<QLowEnergyController::ControllerState>>(_a[1]))); break;
        case 18: _t->errorOccurred((*reinterpret_cast< std::add_pointer_t<QLowEnergyController::Error>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 9:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 1:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QBluetoothDeviceInfo >(); break;
            }
            break;
        case 12:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QBluetoothDeviceInfo >(); break;
            }
            break;
        case 14:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QBluetoothUuid >(); break;
            }
            break;
        case 15:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QLowEnergyService::ServiceState >(); break;
            }
            break;
        case 16:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QLowEnergyCharacteristic >(); break;
            }
            break;
        case 17:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QLowEnergyController::ControllerState >(); break;
            }
            break;
        case 18:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QLowEnergyController::Error >(); break;
            }
            break;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _q_method_type = void (BlueToothController::*)(QString );
            if (_q_method_type _q_method = &BlueToothController::temperatureChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
        {
            using _q_method_type = void (BlueToothController::*)(QString );
            if (_q_method_type _q_method = &BlueToothController::humidityChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 1;
                return;
            }
        }
        {
            using _q_method_type = void (BlueToothController::*)(bool );
            if (_q_method_type _q_method = &BlueToothController::connectionStatusChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 2;
                return;
            }
        }
        {
            using _q_method_type = void (BlueToothController::*)(bool );
            if (_q_method_type _q_method = &BlueToothController::commandSent; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 3;
                return;
            }
        }
        {
            using _q_method_type = void (BlueToothController::*)(bool );
            if (_q_method_type _q_method = &BlueToothController::commandVoiceSent; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 4;
                return;
            }
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->temperature(); break;
        case 1: *reinterpret_cast< QString*>(_v) = _t->humidity(); break;
        default: break;
        }
    }
}

const QMetaObject *BlueToothController::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *BlueToothController::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_ZN19BlueToothControllerE.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int BlueToothController::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 19)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 19;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 19)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 19;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    return _id;
}

// SIGNAL 0
void BlueToothController::temperatureChanged(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void BlueToothController::humidityChanged(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void BlueToothController::connectionStatusChanged(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void BlueToothController::commandSent(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}

// SIGNAL 4
void BlueToothController::commandVoiceSent(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 4, _a);
}
QT_WARNING_POP

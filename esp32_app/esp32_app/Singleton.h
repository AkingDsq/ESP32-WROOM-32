#ifndef SINGLETON_H
#define SINGLETON_H

#include "const.h"
// 单例类模板
template <typename T>
class Singleton {
protected:
    Singleton() = default;
    Singleton(const Singleton<T>&) = delete;
    Singleton& operator=(const Singleton<T>& st) = delete;

    static std::shared_ptr<T> _instance;
public:
    static std::shared_ptr<T> getInstance() {
        static std::once_flag s_flag;
        std::call_once(s_flag, [&]() {
          _instance = std::shared_ptr<T>(new T);
        });
        return _instance;
    }

};
// 静态成员初始化
template<typename T> 
std::shared_ptr<T> Singleton<T>::_instance = nullptr;

#endif
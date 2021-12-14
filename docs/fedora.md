# Fedora 35 host
Этот документ описывает установку и конфигурацию минимальной среды Fedora 35, используемой как базовая конфигурация для компонентов системы, основанных на Linux.
Fedora является свободно распространяемой системой, совместимой с RHEL. Команды и конфигурации для Fedora будут в основном или с минимальными изменениями применимы на RHEL.

# Материалы
* [Fedora Server ISO](https://getfedora.org/en/server/download/)

# Установка
## VMware Workstation/Fusion - ручная
Создать VM, сконфигурировать виртуальный DVD на скаченный ISO, задать параметры VM: CPU, RAM, диск, сеть (bridged).
Интерактивная установка Fedora 35 по умолчанию использует графическую среду и требует небольшого количества определений:
* поддерживаемый язык: English
* Временной пояс: текущий
* пользователь: сконфигурировать юзера, выбрать опцию администрирования. Следует иметь в виду, что по умолчанию root недоступен, его пароль не установлен и доступ к привелегированным функциям осуществляется только через sudo. 
* сеть: включить, система должна получить IP адрес если доступен DHCP. Если DHCP нет, сконфигурировать параметры сети статически вручную
* диск: выбрать диск, сконфигурированный для VM
После завершения установки VM перестартует и поднимется в текстовой консоли.

После установки доступны следующие методы доступа: ssh и веб консоль на https://<адрес>:9090 - оба с юзером, сконфигурированным во время установки.


# Конфигурация
* обновить до текушего уровня: `dnf update -y`
* выключить веб консоль за ненадобностью: `systemctl disable --now cockpit.socket`
* установить системные компоненты: `dnf install -y buildah`
* удалить кэш: `dnf clean all`

Опустить VM, создать снапшот системы в VMWare для того, что бы можно было легко вернуться к изначальной, чистой конфигурации системы.
# BIND DNS
 DNS (Domain Name Service) - сервис, возвращающий значение IP адреса по DNS имени и DNS имя - по IP адресу.
  
# Глобальные опции
Домен выбран локальным, что бы не создавать дубликатов/конфликтов с именами в домене 
* DNS domain: example.local
* DNS forwarders: 87.226.162.62, 8.8.8.8, 8.8.4.4 - внешние DNS серверы, на которые перенаправляются запросы на внешние DNS имена, которые не резолвятся локально. Из соображений производительности рекомендуется использовать серверы интернет провайдера. Как запасной вариант можно использовать серверы, известные своей надежностью.
* Config (ro)(root:bind): /etc/bind
* Data (rw)(bind:bind): /var/ 
* Ports: 53/udp, 53/tcp

# Установка
* Server/VM: Fedora 35 minimal server
* IP: 192.168.0.6
* Host name: dns1.example.local

Установка пакета сервиса:
```
dnf install -y bind bind-utils
systemctl start named
systemctl enable named
```

Конфигурация:
* conf/dns/named.conf			-> /etc/named.conf (root:named 640)
* conf/dns/example.local.db		-> /var/named/example.local.db (named:named 640)
* conf/dns/example.local.rev	-> /var/named/example.local.rev (named:named 640)

Проверка:
```
named-checkconf
named-checkzone example.local /var/named/example.local.db
named-checkzone 192.168.0.7 /var/named/example.local.rev
```

Рестарт: `systemctl restart named`

Firewall:
```
firewall-cmd  --add-service=dns --zone=public  --permanent
firewall-cmd --reload
```

# Конфигурация клиентов

## Статическое определение
Для клиентов со статическим определением параметров сети конфигурация DNS сервера производится в файле /etc/resolv.conf: добавить строку `nameserver 192.168.0.207` в файл.

## NetworkManager
Добавить строку `DNS=192.168.0.6` в /etc/systemd/resolved.conf и перестартовать `systemctl restart systemd-resolved.service`

## Параметер DHCP
См. docs/dhcp.md

----------------

# DNS в контейнере
TBD
## Предварительные требования
* [Контайнер](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/building_running_and_managing_containers/index#con_understanding-the-ubi-micro-images_assembly_types-of-container-images): [ubi8/ubi-micro](https://catalog.redhat.com/software/containers/ubi8/ubi-micro/5ff3f50a831939b08d1b832a)
* buildah, podman, scopeo
 
## Построение контейнера
Особенностью микро UBI образов является отсутствие какого-либо встроенного менеджера пакетов, таких как YUM. Это позволяет минимизировать размер образов и уменьшить число включенных компонентов.
С помощью методики построения с использованием buildah системные пакеты могут быть установлены в контейнер, файловая система которого смонтирована в директорию.

Установка инструменты: `yum module install -y container-tools`

Построение контейнера с bind:
```
microcontainer=$(buildah from registry.access.redhat.com/ubi8/ubi-micro)
yum install \
    --installroot $micromount \
    --releasever 8 \
    --setopt install_weak_deps=false \
    --nodocs -y \
    bind bind-utils
yum clean all --installroot $micromount
buildah umount $microcontainer
buildah commit $microcontainer ubi-micro-bind
```

Посмотреть контейнеры: `podman images ubi-micro-bind`
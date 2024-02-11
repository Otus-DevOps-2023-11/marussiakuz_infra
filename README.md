# marussiakuz_infra
marussiakuz Infra repository

ДЗ 6:

Проблемы конфигурации приложения при добавлении еще одного ресурса для нового инстанса
приложения:

1. Управление конфигурацией: При изменении конфигурации приложения или окружения,  придется внести эти изменения на каждый инстанс отдельно, что может быть трудоемким и подвержено ошибкам.
2. Синхронизация состояния: Если несколько инстансов приложения работают независимо, они могут иметь разные версии данных или состояния приложения. Это может привести к неконсистентности данных при обращении к приложению через балансировщик.

Описание сделанного:
1. В main.tf добавлен ресурс для создания инстанса VM в YC в количестве указанном в переменной instance_count с provisioners для начальной настройки системы, для запуска скрипта деплоя приложения на создаваемом инстансе и для запуска сервера приложения.
2. В lb.tf добавлен ресурс для создания HTTP балансировщика.
3. В outputs.tf заданы выходные переменные для адресов инсансов и балансировщика.

ДЗ 5:

1. Создан сервисный аккаунт для packer в Yandex Cloud с ролью editor
2. Создан параметризованный шаблон ubuntu16.json с описанием образа VM с предустановленными ruby и mongodb. Образ был собран и на его основе создана VM. В VM вручную задеплоено и запущено приложение puma.
Проверить можно здесь: http://158.160.139.73:9292/
3. Создан шаблон immutable.json с описанием образа VM c предустановленными ruby/mongodb и созданием systemd сервиса для Puma, который запускается при старте VM. Создана VM на основе образа с помощью скрипта create-reddit-vm.sh
Проверить можно здесь: http://178.154.202.6:9292/


testapp_IP = 158.160.114.150 
testapp_port = 9292

yc compute instance create \
 --name reddit-app \
 --hostname reddit-app \
 --memory=4 \
 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
 --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
 --metadata-from-file user-data=metadata.yaml \
 --metadata serial-port-enable=1 \
 --zone ru-central1-a

 \
view the logs of the script:

ssh yc-user@158.160.114.150 \
sudo journalctl -u setup.service -f

_ _ _

bastion_IP = 158.160.105.151
someinternalhost_IP = 10.128.0.7

Command to connect to someinternalhost: ssh -J marussia@158.160.105.151 marussia@10.128.0.7

Solution option for connecting from the console using the command ssh someinternalhost:

Add to ~/.ssh/config:
'Host someinternalhost
   HostName 10.128.0.7
   User marussia
   ProxyJump marussia@158.160.105.151'

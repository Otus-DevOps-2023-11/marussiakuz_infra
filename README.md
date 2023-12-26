# marussiakuz_infra
marussiakuz Infra repository

bastion_IP = 158.160.105.151
someinternalhost_IP = 10.128.0.7

Command to connect to someinternalhost: ssh -J marussia@158.160.105.151 marussia@10.128.0.7

Solution option for connecting from the console using the command ssh someinternalhost:

Add to ~/.ssh/config:
'Host someinternalhost
   HostName 10.128.0.7
   User marussia
   ProxyJump marussia@158.160.105.151'

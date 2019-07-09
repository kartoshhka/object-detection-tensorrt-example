# Обновляем пакеты
apt update && apt full-upgrade -y

# Настраиваем запуск графических приложений через SSH
echo -e "X11Forwarding yes\nX11DisplayOffset 10\nX11UseLocalhost no" >> /etc/ssh/sshd_config
service sshd restart

# Устанавливаем необходимое ПО
apt install xorg openbox -y

# Перезагружаем сервер
reboot

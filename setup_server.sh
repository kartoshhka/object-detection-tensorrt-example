# Обновляем пакеты
apt update && apt full-upgrade -y

# Настраиваем запуск графических приложений через SSH
if grep 'ForwardX11' ~/.ssh/config 
	then echo "X11 Forwarding done"
	else echo -e "X11Forwarding yes\nX11DisplayOffset 10\nX11UseLocalhost no" >> /etc/ssh/sshd_config
fi
service sshd restart

# Устанавливаем необходимое ПО
apt install xorg openbox -y
apt-get install linux-generic -y
apt-get install v4l2loopback-dkms
apt-get install libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio -y

# Перезагружаем сервер
reboot

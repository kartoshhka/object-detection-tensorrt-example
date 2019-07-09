# Настраиваем запуск графических приложений через SSH
echo -e "X11Forwarding yes\nX11DisplayOffset 10\nX11UseLocalhost no" >> /etc/ssh/sshd_config
service sshd restart

# Настраиваем переменные окружения, чтобы Docker видел веб-камеру и транслировал поток
echo "Настраиваем переменные среды"
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | sudo xauth -f $XAUTH nmerge -
sudo chmod 777 $XAUTH
X11PORT=`echo $DISPLAY | sed 's/^[^:]*:\([^\.]\+\).*/\1/'`
TCPPORT=`expr 6000 + $X11PORT`
sudo ufw allow from 172.17.0.0/16 to any port $TCPPORT proto tcp
DISPLAY=`echo $DISPLAY | sed 's/^[^:]*\(.*\)/172.17.0.1\1/'`


xhost +local:docker
XSOCK=/tmp/.X11-unix

# Скачиваем датасет VOC для калибровки INT8
DATA_DIR=VOCdevkit
if [ -d "$DATA_DIR" ]; then
    echo "$DATA_DIR уже загружен"
else
    echo "Загружаем набор данных VOC"
    wget http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtest_06-Nov-2007.tar
    tar -xf VOCtest_06-Nov-2007.tar
fi

# Собираем Dockerfile
if [ ! -z $(docker images -q object_detection_webcam:latest) ]; then
    echo "Dockerfile уже собран"
else
    echo "Собираем docker-образ"
    docker build -f dockerfiles/Dockerfile --tag=object_detection_webcam .
fi

# Запускаем контейнер
echo "Запускаем контейнер"
docker run --runtime=nvidia -it -v `pwd`:/mnt -e DISPLAY=$DISPLAY -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH object_detection_webcam


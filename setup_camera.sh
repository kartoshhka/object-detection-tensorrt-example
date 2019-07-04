# Добавляем модуль в ядро
sudo modprobe v4l2loopback

# Подключаем открытую веб-камеру как устройство
sudo gst-launch-1.0 --gst-disable-segtrap -vt souphttpsrc location='http://cam10.zentrale.sip-scootershop.de:10012/axis-cgi/mjpg/video.cgi?resolution=1024x768' is-live=true ! multipartdemux ! decodebin ! videoconvert ! tee ! v4l2sink device=/dev/video0

# Object Detection TensorRT Example: 
Приложение на Python, которое захватывает видеопоток с открытой веб-камеры и выполняет обнаружение объектов в режиме реального времени на GPU. Для этого используется предварительно обученная Single Shot Detection (SSD) модель с Inception V2 и оптимизацией TensorRT. Приложение предназначено для запуска на сервере с GPU и в качестве видеопотока использует онлайн-трансляцию с камеры, находящейся в открытом доступе (кафе магазина S.I.P. Scootershop в Ландсберге, Германия). Приложение распознаёт объекты на видео и обводит их ограничивающими рамками, выводя также тип объекта (метку класса).

```
sudo apt-get install python3 python3-pip python3-venv
python3 -m venv .
source bin/activate
tar -xf TensorRT-5.1.5.0.tar.gz
pip3 install TensorRT-5.1.5.0/python/tensorrt-5.1.5.0-cp35-none-linux_x86_64.whl
pip3 install TensorRT-5.1.5.0/python/graphsurgeon-0.4.1-py2.py3-none-any.whl
pip3 install TensorRT-5.1.5.0/python/uff-0.6.3-py2.py3-none-any.whl
pip3 install wheel opencv-python numpy Pillow pycuda request tensorflow==1.12.0
LD_LIBRARY_PATH=./TensorRT-5.1.5.0/targets/x86_64-linux-gnu/lib python3 ssd-model/detect_objects_webcam.py
```

Оригинальное приложение находится в репозитории NVIDIA и предназначено для запуска на локальном компьютере:
https://github.com/NVIDIA/object-detection-tensorrt-example/
### 1. На локальном компьютере (клиенте) выполните:
```
echo -e "Host *\nForwardX11 yes" >> ~/.ssh/config
```
Команда активирует запуск графического интерфейса через SSH.
Зайдите на сервер, клонируйте репозиторий и выполните следующие шаги:
### 2. Настройте сервер:
```
./setup_server.sh
```
Эта команда выполнит необходимые настройки и перезагрузит сервер.

### 3. Зайдите на сервер по SSH с атрибутом -X:
```
ssh -X root@123.123.123.1
```
### 4. Настройте окружение:
```
./setup_environment.sh
```
### 5. Запустите приложение:
```
python SSD_Model/detect_objects_webcam.py 
```

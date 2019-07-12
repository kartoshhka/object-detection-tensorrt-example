# Скачиваем датасет VOC для калибровки INT8
DATA_DIR=VOCdevkit
if [ -d "$DATA_DIR" ]; then
    echo "$DATA_DIR уже загружен"
else
    echo "Загружаем набор данных VOC"
    wget http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtest_06-Nov-2007.tar
    tar -xf VOCtest_06-Nov-2007.tar
fi

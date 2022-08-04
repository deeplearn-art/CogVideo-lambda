sudo apt-get update -y;
sudo apt-get install python3-tk -y;
sudo apt-get install pybind11-dev -y;

sudo mkdir /sharefs;
sudo chmod 777 /sharefs;

pip install -r requirements.txt;
pip install --upgrade protobuf==3.20;

git clone https://github.com/Sleepychord/Image-Local-Attention;
cd Image-Local-Attention;
python setup.py install --user;
cd ../;

#bash scripts/custom_inference.sh;
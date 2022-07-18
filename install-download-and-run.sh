sudo apt-get update;
sudo apt-get install python3-tk;
sudo apt-get install pybind11-dev;

sudo mkdir /sharefs; 
sudo chmod 777 /sharefs;

pip install -r requirements;

git clone https://github.com/Sleepychord/Image-Local-Attention;
cd Image-Local-Attention;
pip install --upgrade protobuf==3.20;
python setup.py install --user;
cd ../;

bash scripts/custom_inference.sh;

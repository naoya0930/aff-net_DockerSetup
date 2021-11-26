From nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

LABEL version="0.1"
LABEL description ="BUild affrodancenet"

RUN apt-get update

# ABOID TIMEZONE SETTING (ex: install git)
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y git curl zip unzip \
        libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler 
RUN apt-get install -y --no-install-recommends libboost-all-dev
RUN apt-get install -y libboost-all-dev  \
        libopenblas-dev liblapack-dev libatlas-base-dev \
        libgflags-dev liblapack-dev libgoogle-glog-dev liblmdb-dev \
        cmake build-essential \
        python-numpy python-setuptools

#install pip
RUN curl -O https://files.pythonhosted.org/packages/27/79/8a850fe3496446ff0d584327ae44e7500daf6764ca1a382d2d02789accf7/pip-20.3.4-py2.py3-none-any.whl
RUN python pip-20.3.4-py2.py3-none-any.whl/pip install --no-index pip-20.3.4-py2.py3-none-any.whl
RUN rm -rf pip-20.3.4-py2.py3-none-any.whl
RUN pip install --upgrade pip
RUN yes | pip install easydict opencv-contrib-python scikit-image protobuf

RUN git clone https://github.com/hongtaowu67/affordance-net.git
RUN cd affordance-net/caffe-affordance-net && \
    git clone https://github.com/naoya0930/aff-net_DockerSetup.git && \
    cp aff-net_DockerSetup/Makefile.config ./ && rm -rf aff-net_DockerSetup && \
    make all -j4 && make pycaffe 

RUN cd affordance-net/lib && make .
ENV PYTHONPATH=affordance-net/caffe-affordance-net/python:$PYTHONPATH

# you should download dataset from https://github.com/hongtaowu67/affordance-net and unzip it

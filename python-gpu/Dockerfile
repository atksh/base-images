FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

# Python and pip
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Tokyo
RUN apt-get update && apt-get install -y software-properties-common tzdata
RUN add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y python3.9 python3.9-dev python3.9-distutils \
    software-properties-common wget apt-utils patchelf git curl libprotobuf-dev protobuf-compiler cmake \
    && apt-get autoremove -y

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python get-pip.py \
    && rm get-pip.py \
    && pip install --upgrade --no-cache-dir pip setuptools wheel

# PyTorch
RUN pip install torch==1.12.1+cu113 torchvision==0.13.0+cu113 --extra-index-url https://download.pytorch.org/whl/cu113

# ORT Module
RUN pip install onnx==1.12.0 ninja==1.10.2.3
RUN pip install onnxruntime-training==1.12.0 -f https://download.onnxruntime.ai/onnxruntime_stable_cu113.html

RUN pip install torch-ort==1.12.0
ENV TORCH_CUDA_ARCH_LIST="5.2 6.0 6.1 7.0 7.5 8.0 8.6+PTX"
RUN python -m torch_ort.configure


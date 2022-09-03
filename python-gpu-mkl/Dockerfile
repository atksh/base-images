ARG TRT_CONTAINER_VERSION=21.12
FROM nvcr.io/nvidia/tensorrt:${TRT_CONTAINER_VERSION}-py3 AS builder

ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_BRANCH=v1.12.1
ARG CMAKE_CUDA_ARCHITECTURES=37;50;52;60;61;70;75;80

RUN apt-get update &&\
    apt-get install -y sudo git bash unattended-upgrades
RUN unattended-upgrade

WORKDIR /code
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:/code/cmake-3.21.0-linux-x86_64/bin:/opt/miniconda/bin:${PATH}

# Prepare onnxruntime repository & build onnxruntime with TensorRT
RUN git clone --depth 1 --branch ${ONNXRUNTIME_BRANCH} --recurse-submodules --shallow-submodules -j$(nproc) ${ONNXRUNTIME_REPO} onnxruntime &&\
    /bin/sh onnxruntime/dockerfiles/scripts/install_common_deps.sh &&\
    trt_version=${TRT_VERSION:0:3} &&\
    /bin/sh onnxruntime/dockerfiles/scripts/checkout_submodules.sh ${trt_version} &&\
    cd onnxruntime &&\
    /bin/sh build.sh --parallel --build_shared_lib --cuda_home /usr/local/cuda --cudnn_home /usr/lib/x86_64-linux-gnu/ --use_tensorrt --tensorrt_home /usr/lib/x86_64-linux-gnu/ --config Release --build_wheel --skip_tests --skip_submodule_sync --cmake_extra_defines '"CMAKE_CUDA_ARCHITECTURES='${CMAKE_CUDA_ARCHITECTURES}'"' &&\
    mv build/Linux/Release/dist/*.whl /tmp/onnxruntime_gpu_tensorrt.whl

FROM nvcr.io/nvidia/tensorrt:${TRT_CONTAINER_VERSION}-py3 AS base
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:/code/cmake-3.21.0-linux-x86_64/bin:/opt/miniconda/bin:${PATH}
RUN apt-get update \
    && apt-get install -y \
    wget git curl \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libgl1-mesa-dev \
    ffmpeg \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install -U --no-cache-dir pip setuptools wheel \
    && pip install -U requests poetry==1.2.0 \
    && poetry config virtualenvs.create false 

FROM nvcr.io/nvidia/tensorrt:${TRT_CONTAINER_VERSION}-py3 AS final
ENV PATH /usr/local/nvidia/bin:opt/miniconda/bin:${PATH}
COPY --from=base / /
COPY --from=builder /tmp/onnxruntime_gpu_tensorrt.whl /tmp/onnxruntime_gpu_tensorrt.whl
RUN pip install --no-cache-dir /tmp/onnxruntime_gpu_tensorrt.whl \
    && rm /tmp/onnxruntime_gpu_tensorrt.whl \
    && conda config --remove channels defaults \
    && conda config --add channels conda-forge \
    && conda install -c intel intelpython3_core


ARG TRT_CONTAINER_VERSION=22.08
FROM nvcr.io/nvidia/tensorrt:${TRT_CONTAINER_VERSION}-py3 AS builder

ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_BRANCH=main
ARG CMAKE_CUDA_ARCHITECTURES=60;61;70;75;80;86

RUN apt-get update &&\
    apt-get install -y sudo git bash unattended-upgrades
RUN unattended-upgrade

WORKDIR /code
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:/code/cmake-3.21.0-linux-x86_64/bin:/opt/miniconda/bin:${PATH}

# Prepare onnxruntime repository & build onnxruntime with TensorRT
RUN git clone --single-branch --branch ${ONNXRUNTIME_BRANCH} --recursive ${ONNXRUNTIME_REPO} onnxruntime &&\
    sed -i 's|Miniconda3-4.5.11-Linux-x86_64.sh|Miniconda3-py39_4.12.0-Linux-x86_64.sh|' onnxruntime/dockerfiles/scripts/install_common_deps.sh &&\
    /bin/sh onnxruntime/dockerfiles/scripts/install_common_deps.sh &&\
    trt_version=${TRT_VERSION:0:3} &&\
    /bin/sh onnxruntime/dockerfiles/scripts/checkout_submodules.sh ${trt_version} &&\
    cd onnxruntime &&\
    /bin/sh build.sh --parallel --build_shared_lib --cuda_home /usr/local/cuda --cudnn_home /usr/lib/x86_64-linux-gnu/ --use_tensorrt --tensorrt_home /usr/lib/x86_64-linux-gnu/ --config Release --build_wheel --skip_tests --skip_submodule_sync --cmake_extra_defines '"CMAKE_CUDA_ARCHITECTURES='${CMAKE_CUDA_ARCHITECTURES}'"' &&\
    pip install /code/onnxruntime/build/Linux/Release/dist/*.whl &&\
    cp -R /code/onnxruntime/build/Linux/Release/dist /opt/dist

FROM nvcr.io/nvidia/tensorrt:${TRT_CONTAINER_VERSION}-py3 AS base
COPY --from=builder /opt/dist /tmp/dist
ENV DEBIAN_FRONTEND=noninteractive
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh -O ~/miniconda.sh --no-check-certificate \
    && /bin/bash ~/miniconda.sh -b -p /opt/miniconda \
    && rm ~/miniconda.sh \
    && /opt/miniconda/bin/conda clean -ya

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:/opt/miniconda/bin:${PATH}
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

ENTRYPOINT [ "/bin/bash" ]

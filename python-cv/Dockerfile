FROM python:3.9-buster as builder
ENV OPENCV_VERSION="4.5.5"

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# OpenCV
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
  && unzip ${OPENCV_VERSION}.zip \
  && export MAKEFLAGS=-j$(nproc) \
  && mkdir opencv-${OPENCV_VERSION}/build \
  && cd opencv-${OPENCV_VERSION}/build \
  && cmake -DBUILD_TIFF=ON \
    -DBUILD_opencv_java=OFF \
    -DWITH_CUDA=OFF \
    -DWITH_OPENGL=OFF\
    -DWITH_OPENCL=OFF \
    -DWITH_IPP=ON \
    -DWITH_TBB=ON \
    -DWITH_EIGEN=ON \
    -DWITH_V4L=ON \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DPYTHON_EXECUTABLE=$(which python) \
    -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
    -DPYTHON_PACKAGES_PATH=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
    .. \
  && make \
  && make install \
  && ldconfig
# ffmpeg
RUN apt-get update && \
    apt-get install -y ffmpeg

FROM python:3.9-buster
COPY --from=builder /usr/local /usr/local
COPY --from=builder /usr/bin /usr/bin
COPY --from=builder /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu
COPY --from=builder /lib/x86_64-linux-gnu /lib/x86_64-linux-gnu

# ffmpeg-python
RUN pip install --no-cache \
    ffmpeg-python

ENTRYPOINT ["/bin/bash"]


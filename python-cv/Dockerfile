FROM python:3.9-buster as builder

RUN apt-get update \
    && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libgl1-mesa-dev \
    ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache \
    ffmpeg-python \
    opencv-python \
    opencv-contrib-python \
    Pillow

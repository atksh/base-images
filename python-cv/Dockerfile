FROM atksh/python

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

RUN pip install --no-cache-dir \
    ffmpeg-python \
    opencv-python \
    opencv-contrib-python \
    Pillow


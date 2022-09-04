FROM ghcr.io/pinto0309/openvino2tensorflow

RUN pip install deepsparse sparsify --user --no-cache-dir
ENV PATH $PATH:/home/user/.local/bin
RUN pip install torch==1.9.1+cpu torchvision==0.10.1+cpu torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html --user --no-cache-dir


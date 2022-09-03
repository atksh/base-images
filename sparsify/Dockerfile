FROM ghcr.io/pinto0309/openvino2tensorflow

RUN pip install deepsparse sparsify --user --no-cache-dir
ENV PATH $PATH:/home/user/.local/bin

CMD sparsify

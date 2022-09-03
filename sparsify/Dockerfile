FROM ghcr.io/pinto0309/openvino2tensorflow

RUN pip install deepsparse --user
RUN pip install sparsify --user
ENV PATH $PATH:/home/user/.local/bin

CMD sparsify

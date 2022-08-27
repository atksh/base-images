FROM atksh/python AS install-mkl
# Install basic software for adding apt repository and downloading source code to compile
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-transport-https ca-certificates gnupg2 gnupg-agent \
    software-properties-common curl apt-utils
# Add key
RUN curl --progress-bar https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB | apt-key add -
RUN echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list

# Install MKL
RUN apt-get update \
    && export mkl=$(apt-cache search intel-mkl-2020 | cut -d '-' -f 1,2,3,4  | tail -n 1) \
    && apt-get install -y $mkl

FROM atksh/python AS configure-mkl
COPY --from=install-mkl /opt/intel/ /opt/intel/
## update alternatives
RUN update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so     libblas.so-x86_64-linux-gnu      /opt/intel/mkl/lib/intel64/libmkl_rt.so 150
RUN update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so.3   libblas.so.3-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 150
RUN update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so   liblapack.so-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 150
RUN update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so.3 liblapack.so.3-x86_64-linux-gnu  /opt/intel/mkl/lib/intel64/libmkl_rt.so 150
## Configure dynamic linker to use MKL
RUN echo "/opt/intel/lib/intel64"     >  /etc/ld.so.conf.d/mkl.conf
RUN echo "/opt/intel/mkl/lib/intel64" >> /etc/ld.so.conf.d/mkl.conf
RUN ldconfig

FROM atksh/python AS final
COPY --from=configure-mkl / /
ENV MKL_ROOT_DIR /opt/intel/mkl
ENV LD_LIBRARY_PATH $MKL_ROOT_DIR/lib/intel64:/opt/intel/lib/intel64_lin:$LD_LIBRARY_PATH
ENV LIBRARY_PATH $MKL_ROOT_DIR/lib/intel64:$LIBRARY_PATH
ENV PKG_CONFIG_PATH $MKL_ROOT_DIR/bin/pkgconfig:$PKG_CONFIG_PATH


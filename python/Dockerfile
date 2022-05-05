FROM debian:bullseye
ENV PYTHON_VERSION v3.9.12
ENV MIMALLOC_VERSION v1.7.6

ENV PATH /usr/local/bin:$PATH
ENV LANG C.UTF-8

RUN apt-get update \
	&& apt-get install -y \
	git \
	build-essential \
	cmake \
  libbluetooth-dev \
  libbz2-dev \
  libc6-dev \
  libexpat1-dev \
  libffi-dev \
  libgdbm-dev \
  liblzma-dev \
  libncursesw5-dev \
  libreadline-dev \
  libssl-dev \
  tk-dev \
  uuid-dev \
  wget \
  xz-utils \
  zlib1g-dev

# mimalloc
WORKDIR /tmp
RUN git clone --depth 1 --branch $MIMALLOC_VERSION https://github.com/microsoft/mimalloc \
	&& cd mimalloc \
	&& mkdir build \
	&& cd build \
	&& cmake .. \
	&& make \
	&& make install

RUN git clone --depth 1 --branch $PYTHON_VERSION https://github.com/python/cpython
RUN cd cpython \
	&& cp /usr/local/lib/mimalloc-*/mimalloc.o /tmp/mimalloc.o \
	&& echo 'LIBRARY_OBJS=   \
	$(LIBRARY_OBJS_OMIT_FROZEN) \
	Python/frozen.o \
	/tmp/mimalloc.o' > new
RUN cd cpython && \
	./configure \
  --enable-loadable-sqlite-extensions \
	--enable-optimizations \
	--enable-option-checking=fatal \
	--enable-shared \
  --with-system-expat \
  --with-system-ffi \
  --with-ensurepip=yes \
	--with-lto \
  LDFLAGS="-Wl,-rpath /usr/local/lib" \
	&& perl -i -p0e 's/(LIBRARY_OBJS=.*?Python\/frozen.o)/`cat new`/se' Makefile \
	&& make -j$(nproc) \
	&& make install LDFLAGS="-Wl,--strip-all" \
  && cd /usr/local/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config \
	&& ln -s pip3 pip

RUN pip uninstall -y setuptools \
  && pip install setuptools \
  && rm -rf /usr/local/lib/python*/test \
  && rm -rf /usr/local/lib/python*/config-*-x86_64-linux-gnu

FROM debian:bullseye
COPY --from=0 /usr/local/lib/libpython*.so.1.0 /usr/local/lib
COPY --from=0 /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu
COPY --from=0 /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu
COPY --from=0 /lib/x86_64-linux-gnu/libdl.so.2 /lib/x86_64-linux-gnu
COPY --from=0 /lib/x86_64-linux-gnu/libutil.so.1 /lib/x86_64-linux-gnu
COPY --from=0 /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu
COPY --from=0 /lib64/ld-linux-x86-64.so.2 /lib64/
COPY --from=0 /usr/local/bin /usr/local/bin
COPY --from=0 /usr/local/lib/python3.9 /usr/local/lib/python3.9

ENV PYTHONMALLOC=malloc
RUN apt-get update && apt-get install -y libexpat1 libffi-dev libsqlite3-dev \
    && apt-get clean && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN MIMALLOC_SHOW_STATS=1 PYTHONMALLOCSTATS=1  python -c '[*map(str, range(1000))]'

ENTRYPOINT python

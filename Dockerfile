FROM alpine:3.9

RUN apk add --no-cache bash ruby wget bzip2 file unzip libtool cmake \
    gcc g++ pkgconf musl-dev make automake yasm gettext vim python \
    git-svn ninja subversion perl-git

RUN git config --global user.name "LLVM MinGW" && \
    git config --global user.email root@localhost

WORKDIR /build

ARG CORES=8

ENV TOOLCHAIN_PREFIX=/opt/llvm-mingw
ENV TOOLCHAIN_ARCHS="i686 x86_64 armv7 aarch64"

# Build everything and clean up, in one step
COPY *.sh libssp-Makefile ./
COPY wrappers/*.sh ./wrappers/
RUN ./build-all.sh $TOOLCHAIN_PREFIX && \
    ./strip-llvm.sh $TOOLCHAIN_PREFIX && \
    rm -rf /build

ENV PATH=$TOOLCHAIN_PREFIX/bin:$PATH

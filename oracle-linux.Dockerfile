# Use an official Oracle linux image as the base image
FROM oraclelinux:7

# Create a new user to avoid using root
RUN useradd -ms /bin/bash developer

# Set the working directory in the container to /home/developer
WORKDIR /home/developer

# Install system dependencies
RUN yum update -y && yum install -y \
    gcc gcc-c++ glibc-headers make bison python3 \
    git curl wget vim bzip2 \
    fonts-liberation libfontconfig1 libnss3


# create directory for packages we intend to install from tarballs
RUN mkdir ./packages

# specifiy gcc version that meets expectation for glibc version to be specified
ENV GCC_VERSION 8.2.0
# specifiy make version that meets expectation for glibc version to be specified
ENV MAKE_VERSION 4.4.1
# glibc version specified exceeds the minimum requirement to run reporting
ENV GLIBC_VERSION 2.28

# Install GCC
RUN mkdir ./packages/gcc
ENV GCC_DOWNLOAD_DIR ./packages/gcc
RUN cd ${GCC_DOWNLOAD_DIR} && \
    curl -O -J https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz && \
    tar -xvzf gcc-${GCC_VERSION}.tar.gz && \
    cd ./gcc-${GCC_VERSION} && \
    ./contrib/download_prerequisites && \
    mkdir build && \
    cd build && \
    ../configure --prefix=/usr/local/gcc-${GCC_VERSION} --enable-bootstrap --enable-checking=release --enable-languages=c,c++ --disable-multilib && \
    make && \
    make install && \
    echo -e '\nexport PATH=/usr/local/gcc-$GCC_VERSION/bin:$PATH\n' >> /etc/profile.d/gcc.sh && source /etc/profile.d/gcc.sh && \
    ln -sv /usr/local/gcc-$GCC_VERSION/include/ /usr/include/gcc

# Install Make
RUN mkdir ./packages/make
ENV MAKE_DOWNLOAD_DIR ./packages/make
RUN cd ${MAKE_DOWNLOAD_DIR} && \
    curl -O -J https://ftp.gnu.org/gnu/make/make-${MAKE_VERSION}.tar.gz && \
    tar -xvzf make-${MAKE_VERSION}.tar.gz && \
    mkdir build && \
    cd build && \
    ../make-${MAKE_VERSION}/configure --prefix=/usr && \
    sh build.sh && \
    make install

# Install GLIBC
RUN mkdir ./packages/glibc
ENV GLIBC_DOWNLOAD_DIR ./packages/glibc
RUN cd ${GLIBC_DOWNLOAD_DIR} && \
    curl -O -J https://ftp.gnu.org/gnu/glibc/glibc-${GLIBC_VERSION}.tar.gz && \
    tar -xzf glibc-${GLIBC_VERSION}.tar.gz && \
    mkdir build && \
    cd build && \
    export CC=/usr/local/gcc-$GCC_VERSION/bin/gcc  CXX=/usr/local/gcc-$GCC_VERSION/bin/g++ && \
    ../glibc-${GLIBC_VERSION}/configure \
    --prefix=/usr \
    --disable-profile --enable-add-ons \
    --with-headers=/usr/include --with-binutils=/usr/bin && \
    make && \
    make install

RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 20.10.0
RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

ADD --chown=developer:developer . /home/developer/kibana-dev

# Change to the new user in the Dockerfile
USER developer

# Make port available to the world outside this container
EXPOSE 5601

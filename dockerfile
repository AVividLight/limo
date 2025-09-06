FROM ubuntu:24.04
RUN apt-get update && apt-get install -y \
    cmake g++ git libboost-locale-dev libicu-dev libtbb-dev qt6-base-dev \
    libyaml-cpp-dev build-essential libssl-dev pkg-config rustup && \
    rustup default stable && \
    cargo install cbindgen && \
    ln -s /root/.cargo/bin/cbindgen /usr/local/bin/cbindgen && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN git clone --branch 0.28.1 https://github.com/loot/libloot.git /libloot
WORKDIR /libloot
RUN cmake -S ./cpp -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_DOCUMENTATION=OFF && \
    cmake --build build --parallel
CMD ["/bin/bash", "-c", "cp build/libloot.so* /output && mkdir -p /output/loot && cp -r cpp/include/loot/* /output/loot"]
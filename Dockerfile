FROM docker.io/rust:1-slim-bullseye as cargo-build

RUN apt-get update &&\
    apt-get install -y curl git libssl-dev pkg-config tar

# Copy and build code.
WORKDIR /src
COPY . .
RUN CARGO_PROFILE_RELEASE_DEBUG=1 cargo build -p dev-geth --release

# Download and extract Geth.
WORKDIR /opt/geth
RUN curl https://gethstore.blob.core.windows.net/builds/geth-linux-$(dpkg --print-architecture)-1.10.26-e5eb32ac.tar.gz -o geth.tar.gz
RUN tar --strip-components=1 -xf geth.tar.gz

# Setup the base datadir for geth.
WORKDIR /src
RUN mkdir base-datadir
RUN tar --strip-components=1 -xf base-datadir.tar -C base-datadir

FROM docker.io/debian:bullseye-slim

RUN apt-get update &&\
    apt-get install -y ca-certificates tini
COPY --from=cargo-build /src/target/release/dev-geth /usr/local/bin/dev-geth
COPY --from=cargo-build /opt/geth/geth /usr/local/bin/geth
COPY --from=cargo-build /src/base-datadir /base-datadir

ENTRYPOINT ["tini", "--"]
CMD ["dev-geth"]

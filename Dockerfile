FROM rust:1.58.1-buster as builder

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		clang \
		cmake \
		libudev-dev \
		yasm \
	; \
	rm -rf /var/lib/apt/lists/*

ARG VERSION

RUN git clone -b v${VERSION} --depth 1 https://github.com/openethereum/openethereum /root/openethereum
RUN set -ex; \
	cd /root/openethereum; \
	cargo build --release --features final

FROM debian:buster

COPY --from=builder /root/openethereum/target/release/openethereum /usr/bin/openethereum

RUN useradd -m -u 1000 -s /bin/bash runner
USER runner

ENTRYPOINT ["openethereum"]

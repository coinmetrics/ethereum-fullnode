FROM rust:stretch as builder

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		cmake \
		libudev-dev \
		yasm \
	; \
	rm -rf /var/lib/apt/lists/*

ARG VERSION

RUN git clone -b v${VERSION} --depth 1 https://github.com/paritytech/parity /root/parity
RUN set -ex; \
	cd /root/parity; \
	cargo build --release --features final

FROM debian:stretch

COPY --from=builder /root/parity/target/release/parity /usr/bin/parity

RUN useradd -m -u 1000 -s /bin/bash runner
USER runner

ENTRYPOINT ["parity"]

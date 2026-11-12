# syntax=docker/dockerfile:1
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    CONDA_DIR=/opt/conda \
    PATH=/opt/conda/bin:$PATH

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        bzip2 \
        ca-certificates \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/* \
    && case "$TARGETARCH" in \
        amd64) conda_arch=x86_64 ;; \
        arm64) conda_arch=aarch64 ;; \
        *) echo "Unsupported architecture: $TARGETARCH" >&2; exit 1 ;; \
       esac \
    && curl --fail --silent --show-error --location \
        "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${conda_arch}.sh" \
        --output /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p "$CONDA_DIR" \
    && rm /tmp/miniconda.sh \
    && conda config --system --set channel_priority strict \
    && conda clean --all --yes

COPY scripts/test-conda-package /usr/local/bin/test-conda-package
RUN chmod +x /usr/local/bin/test-conda-package

WORKDIR /work
ENTRYPOINT ["test-conda-package"]

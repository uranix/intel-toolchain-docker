# Copyright (c) 2019-2020 Intel Corporation.
# SPDX-License-Identifier: BSD-3-Clause

# requires os-tools image
ARG base_image="intel/oneapi:os-tools-ubuntu18.04"
FROM "$base_image" AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN apt-get update -y && \
apt-get install -y --no-install-recommends -o=Dpkg::Use-Pty=0 \
intel-hpckit-getting-started \
intel-oneapi-clck \
intel-oneapi-common-licensing \
intel-oneapi-common-vars \
intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic \
intel-oneapi-compiler-fortran \
intel-oneapi-dev-utilities \
intel-oneapi-mpi-devel \
build-essential \
cmake \
git \
--

# GC
RUN \
rm -rf /opt/intel/oneapi/clck && \
rm -rf /opt/intel/oneapi/conda_channel && \
rm -rf /opt/intel/oneapi/dev-utilities && \
rm -rf /opt/intel/oneapi/debugger && \
rm -rf /opt/intel/oneapi/tbb && \
find /opt/intel/oneapi/compiler/latest/linux/bin/ -type f -maxdepth 1 -delete && \
find /opt/intel/oneapi/compiler/latest/linux/lib/ -type f -maxdepth 1 -delete && \
rm -rf /opt/intel/oneapi/compiler/latest/linux/lib/clang && \
rm -rf /opt/intel/oneapi/compiler/latest/linux/lib/emu && \
rm -rf /opt/intel/oneapi/compiler/latest/linux/lib/oclfpga && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

# Squash
FROM "$base_image"
COPY --from=builder / /

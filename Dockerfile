# Start with NVIDIA CUDA 12.4 base image
FROM nvidia/cuda:12.4.0-devel-ubuntu22.04
#FROM pytorch/pytorch:2.4.1-cuda12.1-cudnn9-devel


# Set environment variables
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    openssh-server \
    build-essential \
    cmake \
    gcc \
    g++ \
    make \
    vim \
    nano \
    tmux \
    sudo \
    ninja-build \
    pkg-config \
    x11-apps \
    xauth \
    libgl1-mesa-glx \
    wget \
    curl \
    iputils-ping \
    net-tools \
    netcat \
    nmap \
    traceroute \
    tcpdump \
    telnet \
    dnsutils \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for CUDA
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}

# Set DISPLAY environment variable
ENV DISPLAY=host.docker.internal:0.0
# Add DISPLAY to bash profile for all users
RUN echo "export DISPLAY=host.docker.internal:0.0" >> /etc/bash.bashrc \
    && echo "export DISPLAY=host.docker.internal:0.0" >> /etc/skel/.bashrc

# Optional: Add CUDA paths to system-wide profile
RUN echo "export CUDA_HOME=/usr/local/cuda" >> /etc/bash.bashrc \
    && echo "export PATH=\${CUDA_HOME}/bin:\${PATH}" >> /etc/bash.bashrc \
    && echo "export LD_LIBRARY_PATH=\${CUDA_HOME}/lib64:\${LD_LIBRARY_PATH}" >> /etc/bash.bashrc

# Setup SSH
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Configure SSH for X11 forwarding
RUN sed -i 's/#X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config \
    && sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config

# ... existing code ...

# Install Mambaforge and set permissions
RUN wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" -O ~/miniforge.sh \
    && bash ~/miniforge.sh -b -p $CONDA_DIR -u \
    && rm ~/miniforge.sh \
    && ln -s $CONDA_DIR/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && ln -s $CONDA_DIR/etc/profile.d/mamba.sh /etc/profile.d/mamba.sh \
    && echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> /etc/bash.bashrc \
    && echo ". $CONDA_DIR/etc/profile.d/mamba.sh" >> /etc/bash.bashrc \
    && echo "conda activate base" >> /etc/bash.bashrc \
    && chmod -R 777 $CONDA_DIR

# Install pip in base environment and ensure permissions
RUN mamba install -y pip \
    && chmod -R 777 $CONDA_DIR/bin/pip \
    && chmod -R 777 $CONDA_DIR/pkgs

# Setup for new users
RUN echo ". /etc/profile.d/mamba.sh" >> /etc/skel/.bashrc \
    && echo "conda activate base" >> /etc/skel/.bashrc

# Initialize conda for shell interaction
RUN conda init bash


# Add SSH restart to root's bashrc
RUN echo "service ssh restart" >> /root/.bashrc

# Expose SSH port
EXPOSE 22


FROM docker.io/nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

RUN apt-get update && apt-get install -y \
    git \
    pkg-config \
    build-essential \
    libavformat-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavutil-dev \
    libswscale-dev \
    libswresample-dev \
    libavfilter-dev \
    python3 \ 
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /app

# Ensure python points to python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Upgrade pip to avoid issues
RUN pip install --upgrade pip

# Install Cython<3 and numpy to build av
RUN pip install "Cython<3" numpy

# Install av with no build isolation to use the installed Cython<3
RUN pip install av==10.0.0 --no-build-isolation

COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

RUN pip install "git+https://github.com/facebookresearch/pytorch3d.git@v0.7.5"

COPY . /app
WORKDIR /app
#RUN mkdir -p checkpoints/
#RUN wget https://download.europe.naverlabs.com/ComputerVision/DUSt3R/DUSt3R_ViTLarge_BaseDecoder_512_dpt.pth -P checkpoints/
#RUN wget https://huggingface.co/Drexubery/ViewCrafter_25/resolve/main/model.ckpt -P checkpoints/

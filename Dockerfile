FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.11 python3.11-dev python3-pip \
    git git-lfs curl wget ffmpeg libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 \
    && python3 -m pip install --upgrade pip

WORKDIR /app

# Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git ComfyUI
WORKDIR /app/ComfyUI
RUN pip install -r requirements.txt

# Install custom nodes
WORKDIR /app/ComfyUI/custom_nodes

RUN git clone https://github.com/Lightricks/ComfyUI-LTXVideo.git && \
    pip install -r ComfyUI-LTXVideo/requirements.txt

RUN git clone https://github.com/logtd/ComfyUI-Lotus.git && \
    ([ -f ComfyUI-Lotus/requirements.txt ] && pip install -r ComfyUI-Lotus/requirements.txt || true)

RUN git clone https://github.com/kijai/ComfyUI-KJNodes.git && \
    pip install -r ComfyUI-KJNodes/requirements.txt

RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git && \
    pip install -r ComfyUI-VideoHelperSuite/requirements.txt

RUN git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git && \
    pip install -r comfyui_controlnet_aux/requirements.txt

RUN git clone https://github.com/cubiq/ComfyUI_essentials.git && \
    ([ -f ComfyUI_essentials/requirements.txt ] && pip install -r ComfyUI_essentials/requirements.txt || true)

RUN git clone https://github.com/chflame163/ComfyUI_LayerStyle.git && \
    ([ -f ComfyUI_LayerStyle/requirements.txt ] && pip install -r ComfyUI_LayerStyle/requirements.txt || true)

RUN git clone https://github.com/rgthree/rgthree-comfy.git && \
    ([ -f rgthree-comfy/requirements.txt ] && pip install -r rgthree-comfy/requirements.txt || true)

RUN git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    ([ -f ComfyUI-Easy-Use/requirements.txt ] && pip install -r ComfyUI-Easy-Use/requirements.txt || true)

RUN git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git && \
    ([ -f ComfyUI-Custom-Scripts/requirements.txt ] && pip install -r ComfyUI-Custom-Scripts/requirements.txt || true)

RUN git clone https://github.com/SLAPaper/ComfyUI-Image-Selector.git && \
    ([ -f ComfyUI-Image-Selector/requirements.txt ] && pip install -r ComfyUI-Image-Selector/requirements.txt || true)

RUN git clone https://github.com/MNeMoNiCuZ/comfyui-styles_csv_loader.git && \
    ([ -f comfyui-styles_csv_loader/requirements.txt ] && pip install -r comfyui-styles_csv_loader/requirements.txt || true)

RUN git clone https://github.com/evanspearman/ComfyMath.git && \
    ([ -f ComfyMath/requirements.txt ] && pip install -r ComfyMath/requirements.txt || true)

RUN git clone https://github.com/WASasquatch/was-node-suite-comfyui.git && \
    pip install -r was-node-suite-comfyui/requirements.txt

# Copy workflow
WORKDIR /app/ComfyUI
RUN mkdir -p user/default/workflows
COPY "LTX-23 5in1.JSON" user/default/workflows/

# Models are expected to be mounted at runtime (see docker-compose.yml)
VOLUME ["/app/ComfyUI/models"]

EXPOSE 8188

CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]

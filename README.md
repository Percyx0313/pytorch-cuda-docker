# CUDA 12.4 PyTorch Development Environment

Docker environment with CUDA 12.4, PyTorch, and development tools for RTX 4090.

## Building

```bash
docker build -t pytorch_cuda124 .
```

## Running Container

### Interactive Mode
```bash
docker run -it \
    --gpus all \
    -p 8888:22 \
    -v ${PWD}/workspace:/workspace \
    -v ${PWD}/data:/data \
    --name pytorch_cuda124 \
    pytorch_cuda124 \
    /bin/bash
```

### Daemon Mode
```bash
docker run -d \
    --gpus all \
    -p 8888:22 \
    -v ${PWD}/workspace:/workspace \
    -v ${PWD}/data:/data \
    --name pytorch_cuda124 \
    pytorch_cuda124
```

## Connecting

Direct access:
```bash
docker exec -it pytorch_cuda124 /bin/bash
```

## Quick Test
```bash
nvidia-smi  # Check GPU
python -c "import torch; print(torch.cuda.is_available())"  # Check PyTorch CUDA
```

## Push to GitHub

Initialize and push to GitHub:
```bash
# Initialize git repository
git init

# Add all files
git add Dockerfile README.md

# Commit with message
git commit -m "feat: Add CUDA 12.4 PyTorch development environment for RTX 4090

- Add Dockerfile with CUDA 12.4 and PyTorch support
- Configure SSH and development tools
- Add volume mounting for workspace and data
- Include README with build and run instructions"

# Add remote repository (replace with your GitHub repo URL)
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Push to GitHub
git push -u origin main
```

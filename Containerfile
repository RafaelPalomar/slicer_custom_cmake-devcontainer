# Use Ubuntu 22.04 LTS as the base image
FROM ubuntu:22.04

# Set labels to provide metadata about the container, indicating its purpose as a devcontainer for 3D Slicer development
LABEL org.opencontainers.image.title="3D Slicer Devcontainer" \
      org.opencontainers.image.description="A development container for 3D Slicer with all dependencies installed." \
      maintainer="Rafael Palomar (rafael.palomar@ous-research.no)"

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Copy the 'extra-packages' file containing the list of packages to be installed
COPY extra-packages /

# Update and install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends $(grep -v '^#' /extra-packages) && \
    # Clean up to reduce the image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install a custom version of cmake
RUN wget -qO- "https://github.com/Kitware/CMake/releases/download/v3.29.0-rc2/cmake-3.29.0-rc2-linux-x86_64.sh" > /tmp/cmake-install.sh && \
    chmod +x /tmp/cmake-install.sh && \
    sudo /tmp/cmake-install.sh --skip-license --prefix=/opt && \
    rm /tmp/cmake-install.sh

# Example command to clone and build 3D Slicer; adjust as necessary for your specific use case
# This step might be performed outside of the Dockerfile, depending on your development workflow
# RUN git clone https://github.com/Slicer/Slicer.git && \
#     cd Slicer && \
#     ./Utilities/SetupForDevelopment.sh && \
#     mkdir Slicer-build && \
#     cd Slicer-build && \
#     cmake ../Slicer && \
#     make -j$(nproc)

# This makes possible to address git directories from within a distrobox or emacs TRAMP
RUN git config --system --add safe.directory '*'

# The entry point or command to run when the container starts can be set here
# For example, opening a bash shell or starting a specific development tool
CMD ["/bin/bash"]

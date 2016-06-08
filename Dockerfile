# Pull image from the osrf
FROM osrf/ros:indigo-desktop-full

# Install vim, (intel) graphic acceleration and some development tools
RUN \
  apt-get update && \
  apt-get install -y \
    vim \
    libgl1-mesa-glx \ 
    libgl1-mesa-dri \
    cmake-curses-gui \
  && \
  rm -rf /var/lib/apt/lists/*

# Add my local user to the docker image TODO: Hardcoded user! change to fit your system
RUN useradd -ms /bin/bash cakemix
# Change to the newly created user
USER cakemix
WORKDIR /home/cakemix

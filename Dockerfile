FROM nvidia/cuda:10.1-devel-ubuntu18.04

LABEL maintainer="Jeremy Cochoy <jeremy.cochoy@gmail.com>"

# Some basic developer tools
RUN apt-get update && apt-get -qq install -y \
            curl \
            ssh \
            rsync \
            clang \
            unzip \
            less nano vim emacs \
            openssh-client \
            cmake \
			tmux \
			screen \
			gnupg \
			git \
			bzip2 \
        	wget \
        	sudo

# Create a working directory
RUN mkdir /content
WORKDIR /content

# Install python
RUN apt -qq install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get -qq install -y python python-pip
RUN apt-get -qq install -y python3.7
# Replace the current version of python 3 by 3.7
RUN rm /usr/bin/python3
RUN ln -s /usr/bin/python3.7 /usr/bin/python3
# Install pip-3.7
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.7 get-pip.py
RUN rm get-pip.py
# Check python versions
RUN python -V
RUN python3 -V
RUN pip3 -V

# Install Graphviz
RUN apt-get -qq install -y graphviz
RUN pip3 install graphviz==0.8.4

# Install pytorch for cuda 10:
RUN pip3 install https://download.pytorch.org/whl/cu100/torch-1.1.0-cp37-cp37m-linux_x86_64.whl
RUN pip3 install https://download.pytorch.org/whl/cu100/torchvision-0.3.0-cp37-cp37m-linux_x86_64.whl

# Install jupyter
RUN pip3 install jupyter
RUN pip3 install --upgrade jupyter_http_over_ws>=0.0.1a3 && \
         jupyter serverextension enable --py jupyter_http_over_ws

# Install scipy and usual tools
RUN pip3 install matplotlib scipy numpy

# Fix jupyter and install google colab
RUN cd /usr/local/lib/python3.7/dist-packages/notebook/static/components/react/ ; curl -OL https://unpkg.com/react-dom@16/umd/react-dom.production.min.js

# Create a non-root user and switch to it
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
 && chown -R user:user /content
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

# All users can use /home/user as their home directory
ENV HOME=/home/user
RUN chmod 777 /home/user

# Install script
COPY start_jupyter.sh /home/user/
CMD ~/start_jupyter.sh

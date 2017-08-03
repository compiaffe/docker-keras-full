# docker-debian-cuda - Debian 9 with CUDA Toolkit

FROM gw000/keras:2.0.6-py3-tf-cpu
MAINTAINER gw0 [http://gw.tnode.com/] <gw.2017@ena.one>


# install py3-tf-cpu/gpu (Python 3, TensorFlow, CPU/GPU)
# Already installed in upstream

# install additional debian packages
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # system tools
    less \
    procps \
    vim-tiny \
    # build dependencies
    build-essential \
    libffi-dev \
    # visualization (Python 2 and 3)
    python3-matplotlib \
    python3-pillow \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install additional python packages
 RUN pip3 --no-cache-dir install \
    # jupyter notebook and ipython (Python 3)
    ipython \
    ipykernel \
    # data analysis (Python 3)
    pandas \
    scikit-learn \
    statsmodels \
 && python3 -m ipykernel.kernelspec

# configure console
RUN echo 'alias ll="ls --color=auto -lA"' >> /root/.bashrc \
 && echo '"\e[5~": history-search-backward' >> /root/.inputrc \
 && echo '"\e[6~": history-search-forward' >> /root/.inputrc
# default password: keras
ENV PASSWD='sha1:98b767162d34:8da1bc3c75a0f29145769edc977375a373407824'

# dump package lists
RUN dpkg-query -l > /dpkg-query-l.txt \
 && pip3 freeze > /pip3-freeze.txt

# for jupyter
EXPOSE 8888
# for tensorboard
EXPOSE 6006

WORKDIR /srv/
CMD /bin/bash -c 'jupyter notebook --no-browser --ip=* --NotebookApp.password="$PASSWD" "$@"'

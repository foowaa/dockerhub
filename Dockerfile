FROM pytorch/pytorch:1.9.0-cuda10.2-cudnn7-devel
# FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel
RUN apt-key del 7fa2af80 \
    && rm /etc/apt/sources.list.d/cuda.list \
    && rm /etc/apt/sources.list.d/nvidia-ml.list
COPY cuda-keyring_1.0-1_all.deb .
RUN dpkg -i cuda-keyring_1.0-1_all.deb

WORKDIR /me
RUN wget https://github.com/jonas/tig/releases/download/tig-2.5.4/tig-2.5.4.tar.gz
RUN tar xzvf tig-2.5.4.tar.gz
RUN cd tig-2.5.4 && make
RUN cd tig-2.5.4 && make install
RUN rm -rf tig-2.5.4
#RUN echo 'alias glog="tig"' >> ~/.zshrc && echo 'alias gstatus="tig status"' >> ~/.zshrc && source ~/.zshsrc

RUN pip install matplotlib sklearn opencv-python imageio Pillow scikit-image scipy graphviz easydict pytorch-lightning ipython torchinfo click \
    tensorboardX jieba pandas statsmodels lightgbm arrow einops fvcore pyyaml seaborn onnx tensorrt pydub moviepy natsort pudb pytz sympy \
    PySnooper loguru merry tenacity environs pypinyin attrs cattrs lmdb sh dill h5py networkx[default] librosa \
    pytorchvideo msgpack pyarrow thefuzz onnxruntime onnxruntime-gpu kornia Augmentor tormentor lightning-flash lightning-transformers lightning-bolts \
    download decord av torchnet tabulate torchdata torchaudio torchtext torchmetrics darts opencv-contrib-python \
    pycocotools ujson tensorwatch
# RUN pip install deep-forest cupy-cuda102 paddlepaddle-gpu paddlevideo cityscapesscripts pycuda 

WORKDIR /me
# install oh-my-zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
# install global
RUN wget http://tamacom.com/global/global-6.6.2.tar.gz && tar xzvf global-6.6.2.tar.gz 
RUN cd global-6.6.2 && ./configure --disable-gtagscscope && make && make install
RUN cd /me && rm -f global-6.6.2.tar.gz && rm -rf global-6.6.2
# install exa
RUN mkdir exa && cd exa && wget https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-musl-v0.10.1.zip \
    && unzip exa-linux-x86_64-musl-v0.10.1.zip && cp bin/exa /usr/sbin/exa && chmod +x /usr/sbin/exa \
    && echo 'alias lla="exa -la"' >> ~/.zshrc
RUN rm -rf /me/exa
# install tig
RUN wget https://github.com/jonas/tig/releases/download/tig-2.5.4/tig-2.5.4.tar.gz && tar xzvf tig-2.5.4.tar.gz \
    && cd tig-2.5.4 && ./configure && make && make install && rm -rf tig-2.5.4 \
    && echo 'alias glog="tig"' >> ~/.zshrc && echo 'alias gstatus="tig status"' >> ~/.zshrc && source ~/.zshsrc


#install denseflow
# WORKDIR ~
# COPY install_denseflow.sh .
# RUN chmod +x install_denseflow.sh
# RUN ./install_denseflow.sh

#install decord for GPU
# WORKDIR /me
# RUN git clone --recursive https://github.com/dmlc/decord && cd decord && mkdir build && cd build 
# RUN cmake .. -DUSE_CUDA=ON -DCMAKE_BUILD_TYPE=Release
# RUN make
# RUN cd ../python && python setup.py install --user


RUN wget https://github.com/zyedidia/micro/releases/download/v2.0.10/micro-2.0.10-amd64.deb && dpkg -i micro-2.0.10-amd64.deb && rm micro-2.0.10-amd64.deb \
    && wget https://github.com/sharkdp/fd/releases/download/v8.2.1/fd_8.2.1_amd64.deb && dpkg -i fd_8.2.1_amd64.deb && rm fd_8.2.1_amd64.deb \
    && git clone https://github.com/sharkdp/dbg-macro && ln -s $(readlink -f dbg-macro/dbg.h) /usr/include/dbg.h

# RUN pip uninstall torchtext -y && pip install torchtext

WORKDIR /me
ENTRYPOINT [ "/bin/zsh" ]
CMD ["-l"]

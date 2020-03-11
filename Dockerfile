FROM jupyter/base-notebook:python-3.7.6

USER root

WORKDIR work

RUN apt update && \
	apt install -y git make

RUN git clone https://github.com/getfem-doc/getfem.git

RUN cd getfem

RUN apt-get install -y --no-install-recommends 	automake \ 
						libtool \
						make \
 						g++ \
 						libqd-dev \
						libqhull-dev \
						libmumps-seq-dev \
						liblapack-dev \
						libopenblas-dev \
						libpython3-dev \
						ufraw \
						imagemagick \
						fig2dev \
						texlive \
						xzdec \
						fig2ps \
						gv

RUN conda install -y conda && \
	conda update -n base conda && \
	conda install -y numpy scipy Sphinx

RUN cd getfem && \
	bash autogen.sh && \
	./configure --with-pic --enable-python3 && \
	make && \
	make check && \
	make install

ENV PYTHONPATH=$PYTHONPATH:/home/$NB_USER/work/getfem/interface/src/python

COPY  examples/ examples

RUN chmod -R 777 examples

USER $NB_UID

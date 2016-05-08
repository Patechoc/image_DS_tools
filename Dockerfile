# Data science tools for Python 2.7
# - Anaconda (a practical data science plateform)
# - numpy, pandas, scrapy, scipy, scikit-learn, joblib, shapely, future, seaborn and nltk????
# - R, Rstudio, R packages
# - OpenCV (and its dependencies for python 2.7, installed through apt-get)
# - Scala and sbt
# - Julia
# inspired by https://hub.docker.com/r/magsol/lj-datascience/~/dockerfile/

FROM patrickmerlot/ubuntu_14.04

MAINTAINER Patrick Merlot <patrick.merlot@gmail.com>

USER root
RUN apt-get -y update
ENV DEBIAN_FRONTEND noninteractive


# versions
ENV ANACONDA_VERSION 2-4.0.0
ENV OPENCV_VERSION 3.0.0


# Install Anaconda.
RUN echo 'export PATH=/opt/conda/bin:$PATH' > conda.sh && mv conda.sh /etc/profile.d/
RUN wget https://repo.continuum.io/archive/Anaconda$ANACONDA_VERSION-Linux-x86_64.sh
RUN /bin/bash /Anaconda$ANACONDA_VERSION-Linux-x86_64.sh  -b -p /opt/conda && \
    rm /Anaconda$ANACONDA_VERSION-Linux-x86_64.sh
# Add the anaconda binary directory to your PATH environment variable
ENV PATH /opt/conda/bin:$PATH


# Install some extra Python libraries?
RUN /opt/conda/bin/conda install --yes joblib shapely future seaborn
ADD requirements.txt /tmp/requirements.txt
RUN /opt/conda/bin/pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt

# Now that Python is set up, install OpenCV
RUN wget https://github.com/Itseez/opencv/archive/$OPENCV_VERSION.zip && \
    unzip $OPENCV_VERSION.zip && rm $OPENCV_VERSION.zip
ADD build_opencv.sh /build_opencv.sh
RUN /bin/bash build_opencv.sh
RUN rm build_opencv.sh
ENV PATH /opt/opencv:$PATH

# Install SBT (The interactive build tool)
RUN wget https://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz && \
    tar zxvf sbt-$SBT_VERSION.tgz && rm sbt-$SBT_VERSION.tgz
RUN mv sbt /opt/sbt
ENV PATH /opt/sbt/bin:$PATH


# Finally, install Scala.
RUN wget http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz && \
    tar zxvf scala-$SCALA_VERSION.tgz && rm scala-$SCALA_VERSION.tgz && \
    mv scala-$SCALA_VERSION /opt/scala
ENV PATH /opt/scala/bin:$PATH


ENTRYPOINT ["/bin/bash"]
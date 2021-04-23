# This file provides the necessary dependencies to build and run
# the Go2Pins tool. It fetches Spot, LTSmin and then build Go2Pins.

FROM debian:sid
MAINTAINER Etienne RENAULT <renault@lrde.epita.fr>

WORKDIR /build

RUN apt-get update \
 && apt-get install -y --force-yes --no-install-recommends                                     \
    ca-certificates golang git make-guile clang gcc g++ wget python                            \
    bison flex texlive latexmk                                                                 \
    r-base-core r-recommended- r-base-dev- r-base-html-                                        \
    r-cran-data.table r-cran-ggplot2                                                           \
    latexmk texlive-latex-extra texlive-fonts-extra                                            \
    texlive-science                                                                            \
    texlive-latex-extra-doc- texlive-fonts-extra-doc-                                          \
    texlive-latex-base-doc- texlive-latex-recommended-doc-                                     \
    texlive-pictures-doc- texlive-pstricks-doc-                                                \
    texlive-fonts-recommended-doc- libltdl-dev  pdf2svg emacs                                  \
 && git clone https://gitlab.lrde.epita.fr/spot/spot.git                                       \
 && cd spot                                                                                    \
 && ./configure  --disable-python --disable-devel && make && cd tests                          \
 && make ltsmin/modelcheck                                                                     \
 && ln -s /build/spot/tests/ltsmin/modelcheck /bin/modelcheck                                  \
 && cd /build                                                                                  \
 && rm -f spot-2.9.6.tar.gz                                                                    \
 && wget http://github.com/utwente-fmt/ltsmin/releases/download/v3.0.2/ltsmin-v3.0.2-linux.tgz \
 && tar -xzvf ltsmin-v3.0.2-linux.tgz                                                          \
 && rm ltsmin-v3.0.2-linux.tgz                                                                 \
 && mv v3.0.2/ ./ltsmin-v3.0.2/                                                                \
 && ln -s /build/ltsmin-v3.0.2/bin/dve2lts-mc /bin/dve2lts-mc                                  \
 && git clone https://gitlab.lrde.epita.fr/spot/go2pins.git                                    \
 && cd go2pins                                                                                 \
 && make                                                                                       \
 && make check

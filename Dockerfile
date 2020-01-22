# This file provides the necessary dependencies to build and run
# the Go2Pins tool. It fetches Spot, LTSmin and then build Go2Pins.

FROM debian:sid
MAINTAINER Etienne RENAULT <renault@lrde.epita.fr>

WORKDIR /build

RUN apt-get update \
 && apt-get install -y --force-yes --no-install-recommends                                     \
    ca-certificates golang git make-guile clang gcc g++ wget                                   \
 && wget http://www.lrde.epita.fr/dload/spot/spot-2.8.5.tar.gz                                 \
 && tar -xzvf spot-2.8.5.tar.gz && cd spot-2.8.5                                               \
 && ./configure  --disable-python && make && cd tests                                          \
 && make ltsmin/modelcheck                                                                     \
 && ln -s /build/spot-2.8.5/tests/ltsmin/modelcheck /bin/modelcheck                            \
 && cd ..                                                                                      \
 && rm -f spot-2.8.5.tar.gz                                                                    \
 && wget http://github.com/utwente-fmt/ltsmin/releases/download/v3.0.2/ltsmin-v3.0.2-linux.tgz \
 && tar -xzvf ltsmin-v3.0.2-linux.tgz                                                          \
 && rm ltsmin-v3.0.2-linux.tgz                                                                 \
 && mv v3.0.2/ ./ltsmin-v3.0.2/                                                                \
 && ln -s /build/ltsmin-v3.0.2/bin/dve2lts-mc /bin/dve2lts-mc                                  \
 && git clone https://gitlab.lrde.epita.fr/spot/go2pins.git                                    \
 && cd go2pins                                                                                 \
 && git checkout er/pre-release                                                                \
 && make                                                                                       \
 && make check
 
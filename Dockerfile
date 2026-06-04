FROM alpine:latest
RUN apk update
RUN apk add --no-cache \
    bash \
    build-base \
    bison pkgconfig \
    ncurses-dev ncurses-static \
    libevent-dev libevent-static \
    fts-dev \
    automake autoconf 
ENV SHELL=/bin/bash
CMD ["/bin/bash"]

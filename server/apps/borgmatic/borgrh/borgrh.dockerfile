FROM alpine:3.18.2
LABEL maintainer="giovanni.fi05@gmail.com"

# Install borg and openssh
RUN apk add --no-cache \
    tzdata  \
    openssh \
    sshfs   \
    borgbackup=1.2.7-r0

ENV PS1="\h:\w \\$ "
ENTRYPOINT [ "/usr/sbin/sshd", "-D" ]

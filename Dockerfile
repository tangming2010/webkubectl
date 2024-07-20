FROM docker.m.daocloud.io/alpine:3.20.1

WORKDIR /

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN ARCH=$(uname -m) \
    && case $ARCH in aarch64) ARCH="arm64";; x86_64) ARCH="amd64";; esac \
    && echo "ARCH: " $ARCH \
    && apk add --update --no-cache bash bash-completion curl wget openssl iputils busybox-extras vim tini gettext \
    && sed -i "s/nobody:\//nobody:\/nonexistent/g" /etc/passwd \
    && curl -sLf https://dl.k8s.io/v1.30.3/bin/linux/${ARCH}/kubectl > /usr/bin/kubectl \
    && chmod +x /usr/bin/kubectl \
    && cd /opt/ \
    && wget https://kubeoperator.oss-cn-beijing.aliyuncs.com/kubepi/kubectl-aliases/kubectl-aliases.tar.gz \
    && tar zxvf kubectl-aliases.tar.gz \
    && rm -rf kubectl-aliases.tar.gz \
    && chmod -R 755 kubectl-aliases \
    && cd /tmp/ \
    && wget https://get.helm.sh/helm-v3.15.3-linux-${ARCH}.tar.gz \
    && tar -xvf helm-v3.15.3-linux-${ARCH}.tar.gz \
    && mv linux-${ARCH}/helm /usr/local/bin \
    && chmod +x /usr/local/bin/helm \
    && chmod 555 /bin/busybox \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/* \
    && chmod -R 755 /tmp \
    && mkdir -p /opt/webkubectl

RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata
COPY ./init_kube.sh /
RUN chmod +x /init_kube.sh
USER root

ENTRYPOINT ["tail", "-f", "/dev/null"]

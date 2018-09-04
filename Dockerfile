FROM centos:7

MAINTAINER ThucND

ENV WKHTMLTOPDF_VERSION  0.12.5
ENV WQY_MICROHEI_FONT_VERESION 0.2.0-0.12.beta
ENV TWEMOJI_FONT_VERESION 1.0-beta1

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

RUN yum update -y && \
yum install -y wget && \
yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel && \
yum clean all

RUN yum reinstall -q -y glibc-common
RUN localedef -c -i ja_JP -f UTF-8 ja_JP.UTF-8
ENV LANG=ja_JP.utf8

RUN set -x \
    && yum install -y \
        libXext \
        which \
        libXrender \
        unzip \
        localectl \
        ipa-pgothic-fonts \
        ipa-pmincho-fonts \
        ipa-mincho-fonts \
        vlgothic-fonts \
        vlgothic-p-fonts \
        google-noto-sans-japanese-fonts \
        xorg-x11-fonts-75dpi \
        xorg-x11-fonts-Type1 \
        openssl \
    && yum clean all \
    && mkdir -p \
        /root/.fonts \
        /root/.config/fontconfig \
        /tmp/noto \
        /tmp/twemoji \
        /tmp/wkhtmltopdf \
        /tmp/wqy-microhei-fonts \
    && curl -sSL -1 -o /tmp/wkhtmltopdf/wkhtmltox-${WKHTMLTOPDF_VERSION}-1.centos7.x86_64.rpm https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/${WKHTMLTOPDF_VERSION}/wkhtmltox-${WKHTMLTOPDF_VERSION}-1.centos7.x86_64.rpm \
    && curl -sSL -1 -o /tmp/wqy-microhei-fonts/wqy-microhei-fonts-${WQY_MICROHEI_FONT_VERESION}.el7.noarch.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/wqy-microhei-fonts-${WQY_MICROHEI_FONT_VERESION}.el7.noarch.rpm \
    && cd /tmp/wkhtmltopdf \
    && rpm -i wkhtmltox-${WKHTMLTOPDF_VERSION}-1.centos7.x86_64.rpm \
    && cd /tmp/wqy-microhei-fonts \
    && rpm -i wqy-microhei-fonts-${WQY_MICROHEI_FONT_VERESION}.el7.noarch.rpm \
    && curl -sSL -o /tmp/noto/noto_sans.zip https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip \
    && curl -sSL -o /tmp/twemoji/twemoji.zip https://github.com/eosrei/twemoji-color-font/releases/download/v${TWEMOJI_FONT_VERESION}/TwitterColorEmoji-SVGinOT-Linux-${TWEMOJI_FONT_VERESION}.zip \
    && cd /tmp/noto \
    && unzip -o noto_sans.zip \
    && mv *.otf /root/.fonts/ \
    && cd /tmp/twemoji \
    && unzip -o twemoji.zip \
    && mv *.ttf /root/.fonts/ \
    && rm -rf /tmp/noto /tmp/twemoji /tmp/wkhtmltopdf /tmp/wqy-microhei-fonts

# COPY fonts /root/.fonts/
COPY fonts.conf /root/.config/fontconfig

RUN fc-cache -fv \
    && fc-match

# Define default command.
CMD ["bash"]
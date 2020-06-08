# ArchLinux image with Python dependencies

FROM archlinux/base
MAINTAINER t.aotani

# Locale
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Update base system
RUN pacman-key --init && pacman-key --populate \
    && pacman -Syu --noconfirm --noprogressbar pacman \
    && pacman-db-upgrade \
    && pacman -Su --noconfirm --noprogressbar ca-certificates \
    && trust extract-compat \
    && pacman -Syyu --noconfirm --noprogressbar \
    && pacman -Scc --noconfirm

# Install some useful packages to the base system
RUN pacman -Sy --noconfirm --noprogressbar expect which grep sudo python-pip python jdk-openjdk sbt zsh

# Add devel user to build packages
#RUN useradd -m -d /home/devel -u 1000 -U -G users,tty -s /bin/zsh devel
#RUN echo 'devel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#USER devel
ENV TERM dumb
ENV MAKEFLAGS "-j8"


WORKDIR /root/devel/
COPY sbt-aspectj/ sbt-aspectj/
COPY autoassesmentchecker/ autoassesmentchecker/
COPY assesment-class-check/ assesment-class-check/

WORKDIR /root/devel/sbt-aspectj
RUN sbt publishLocal

WORKDIR /root/devel/assesment-class-check
RUN sbt test:compile

WORKDIR /root/devel
RUN pip install pipenv

WORKDIR /root/devel/autoassesmentchecker/python
RUN pipenv install --deploy --system

##########################################################################
# CLEAN UP SECTION - THIS GOES AT THE END                                #
##########################################################################
    # Remove stuff that still needs subitems
RUN \
    #pacman --noconfirm -R \
    # util-linux \
    #fakeroot && \


    # Remove ducktape & shim & leftover mirrorstatus.
     # rm -r /.ducktape /.shim && \
     # rm /tmp/.root.mirrorstatus.json && \

    # localepurge && \

    # Remove info, man and docs
    rm -r /usr/share/info/* && \
    rm -r /usr/share/man/* && \
    rm -r /usr/share/doc/* && \

    # was a bit worried about these at first but I haven't seen an issue yet on them.
    rm -r /usr/share/zoneinfo/* && \
    rm -r /usr/share/i18n/* && \

    # Delete any backup files like /etc/pacman.d/gnupg/pubring.gpg~
    find /. -name "*~" -type f -delete && \

    # Keep only xterm related profiles in terminfo.
    find /usr/share/terminfo/. ! -name "*xterm*" ! -name "*screen*" ! -name "*screen*" -type f -delete && \

    # Remove anything left in temp.
    rm -r /tmp/* && \

    pacman -S --noconfirm awk && \
    bash -c "echo 'y' | pacman -Scc >/dev/null 2>&1" && \
    paccache -rk0 >/dev/null 2>&1 &&  \
    pacman-optimize && \
    pacman -Runs --noconfirm gawk tar && \
    rm -r /var/lib/pacman/sync/*

#########################################################################

EXPOSE 8888

WORKDIR /root/devel/autoassesmentchecker/python
ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root"]

RUN jupyter serverextension enable --py jupyterlab
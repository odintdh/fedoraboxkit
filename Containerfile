ARG FEDORA_MAJOR_VERSION=38
ARG BASE_IMAGE_URL=registry.fedoraproject.org/fedora-toolbox

FROM ${BASE_IMAGE_URL}:${FEDORA_MAJOR_VERSION}

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="odintdh@gmail.com"

COPY scripts /tmp/scripts

COPY extra-packages /
RUN chmod +x /tmp/scripts/pre.sh && \
        /tmp/scripts/pre.sh && \
        grep -v '^#' /extra-packages | xargs dnf install -y && \
        chmod +x /tmp/scripts/post.sh && \
        /tmp/scripts/post.sh 
        
RUN rm /extra-packages
RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman 
     

ARG IMAGE
ARG TAG

FROM ${IMAGE}:${TAG}

LABEL maintainer="Meliurwen <meliruwen@gmail.com>"

COPY enable_pjpeg.patch enable_pjpeg.patch

RUN patch -p1 < enable_pjpeg.patch

ARG IMAGE
ARG TAG

FROM ${IMAGE}:${TAG}

LABEL maintainer="Meliurwen <meliruwen@gmail.com>"

COPY root/ /

ENV MEDIA_ROOT=/srv/www/media
ENV MUSIC_DIRECTORY_PATH=/srv/www/music
ENV STATIC_ROOT=/srv/www/static
ENV FUNKWHALE_FRONTEND_PATH=/srv/www/frontend

ENTRYPOINT ["/entrypoint.sh"]

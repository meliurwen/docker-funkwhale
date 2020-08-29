ARG IMAGE
ARG TAG

FROM ${IMAGE}:${TAG}

LABEL maintainer="Meliurwen <meliruwen@gmail.com>"

COPY root/ /

ENV MEDIA_ROOT=/srv/wwww/media
ENV MUSIC_DIRECTORY_PATH=/srv/wwww/music
ENV STATIC_ROOT=/srv/wwww/static
ENV FUNKWHALE_FRONTEND_PATH=/srv/wwww/frontend

ENTRYPOINT ["/entrypoint.sh"]

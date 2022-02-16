ARG REDIS_VER=6.2.6
ARG ARCH=x64
ARG OSNICK=bullseye

ARG REDISEARCH_VER=2.4.0
ARG REJSON_VER=2.0.6

FROM redislabs/redisearch:${REDISEARCH_VER} as redisearch
FROM redislabs/rejson:${REJSON_VER} as rejson
FROM redisfab/redis:${REDIS_VER}-${ARCH}-${OSNICK}

ENV LD_LIBRARY_PATH /usr/lib/redis/modules

WORKDIR /data
RUN apt-get update -qq
RUN apt-get upgrade -y
RUN rm -rf /var/cache/apt

COPY --from=redisearch ${LD_LIBRARY_PATH}/redisearch.so ${LD_LIBRARY_PATH}/
COPY --from=rejson ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/

ENTRYPOINT ["redis-server"]
CMD ["--loadmodule", "/usr/lib/redis/modules/redisearch.so", \
    "--loadmodule", "/usr/lib/redis/modules/rejson.so"]

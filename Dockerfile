FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS publish
WORKDIR /src
COPY . /src
RUN dotnet publish -c Release --output /app/publish
RUN mkdir /app/publish/Initial && \
    cp -r Data /app/publish/Initial/Data && \
    cp -r Config /app/publish/Initial/Config && \
    cp -r Spawns /app/publish/Initial/Spawns 

FROM  mcr.microsoft.com/dotnet/runtime:5.0-alpine AS final
WORKDIR /app
ENV UO_HOME /app

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache bash \
                       mono \
                       zlib-dev \
                       gosu; \
    ln -s /usr/bin/gosu /usr/local/bin/gosu; \
    addgroup uo; \
    adduser -D -S uo -s /bin/bash -h ${UO_HOME} -g "UO server user" -G uo; \
    chown -R uo:uo ${UO_HOME}

COPY --from=publish /app/publish .
COPY docker/docker-config/* /app/Initial/Config
COPY docker/uo-files /app/uo-files
COPY docker/docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh
EXPOSE 2593

ENTRYPOINT [ "/docker-entrypoint.sh" ]


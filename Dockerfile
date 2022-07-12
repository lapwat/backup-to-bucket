FROM alpine

# mysql client
RUN apk add --no-cache mysql-client

# minio client
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc
RUN chmod +x mc
RUN mv mc /bin/mc

COPY --chmod=0755 entrypoint.sh .

ENTRYPOINT ./entrypoint.sh

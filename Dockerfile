FROM alpine

RUN apk add --no-cache age mysql-client postgresql-client

# minio client
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc
RUN chmod +x mc
RUN mv mc /bin/mc

COPY --chmod=0755 entrypoint.sh .
COPY --chmod=0755 backup.sh .
COPY --chmod=0755 restore.sh .

ENTRYPOINT ["./entrypoint.sh"]

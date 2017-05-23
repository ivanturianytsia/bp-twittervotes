FROM alpine

RUN apk --update upgrade && \
    apk --update add ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

RUN mkdir /twittervotes

WORKDIR /twittervotes

ADD ./bin/twittervotes_alpine /twittervotes/twittervotes

CMD ["/twittervotes/twittervotes","-addr=:8080"]

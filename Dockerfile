FROM golang:alpine as build

RUN apk --no-cache add git

ENV REPO="github.com/codesenberg/bombardier"
ENV TAG="v1.2.4"
ENV LDFLAGS="-X main.version=${TAG}"

RUN go get -d ${REPO} && \
    cd src/${REPO} && \
    git checkout --quiet ${TAG} && \
    cd - && \
    go install -ldflags "${LDFLAGS}" ${REPO}

FROM alpine:latest

RUN apk --no-cache add ca-certificates

COPY --from=build /go/bin/bombardier /usr/local/bin/bombardier

ENTRYPOINT ["bombardier"]

CMD ["--help"]

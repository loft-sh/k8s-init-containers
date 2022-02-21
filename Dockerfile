ARG GOPATH=/tmp/go
FROM loftsh/go:1.17-alpine as build
ARG GOPATH
ENV GOPATH=${GOPATH}
ENV GOOS=linux
ENV GOARCH=amd64

WORKDIR ${GOPATH}/src/app

ADD go.mod *.go ./

RUN go build -o ${GOPATH}/bin/app

FROM gcr.io/distroless/base-debian11 as base
ARG GOPATH
ENV PATH=/app:$PATH
WORKDIR /app
COPY --from=build ${GOPATH}/bin/app .
CMD [ "app" ]

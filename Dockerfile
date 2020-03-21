FROM golang:1.13 as build

ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
COPY go.sum .
COPY example_backend/go.mod ./example_backend/
COPY example_backend/go.sum ./example_backend/

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build grpc_server.go

# build example http server
WORKDIR /app/example_backend
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build http_server.go

FROM gcr.io/distroless/base
COPY --from=build /app/grpc_server /
COPY --from=build /app/example_backend/http_server /

EXPOSE 22222

CMD ["/grpc_server"]

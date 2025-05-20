FROM golang:1.23-alpine AS build-stage

WORKDIR /app
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN go build -o /out/cct1

FROM alpine:3.14

WORKDIR /app
COPY --from=build-stage /out/cct1 /app/cct1
RUN adduser --uid 1000 -D myuser
RUN chown -R myuser:myuser /app
EXPOSE 8080

USER myuser
ENTRYPOINT [ "/app/cct1" ]
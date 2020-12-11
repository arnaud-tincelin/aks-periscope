FROM golang AS builder
RUN mkdir /app
ADD . /app
WORKDIR /app
RUN CGO_ENABLED=0 GOOS=linux go build ./cmd/aks-periscope

FROM alpine
RUN apk --no-cache add ca-certificates
ADD https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl
RUN mkdir /app
WORKDIR /app
COPY --from=builder /app/aks-periscope .
CMD ["./aks-periscope"]

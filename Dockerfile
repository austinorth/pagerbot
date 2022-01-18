FROM docker.io/library/golang:1.17 AS builder

# Create the user and group files that will be used in the running container to
# run the process as an unprivileged user.
RUN mkdir /user && \
    echo 'nobody:x:65534:65534:nobody:/:' > /user/passwd && \
    echo 'nobody:x:65534:' > /user/group

# Set the working directory outside $GOPATH to enable the support for modules.
WORKDIR /src

# Warm the build cache with a non-cgo (i.e. static) standard library build
# (a go.mod file must exist or it will not run in module-aware mode, and will
# therefore not warm the cache)
RUN go mod init temp 2>&1
RUN CGO_ENABLED=0 go build -installsuffix 'static' std

# Import the code from the context.
COPY ./ ./

# Build the executable to `/pagerbot`. Mark the build as statically linked.
RUN CGO_ENABLED=0 go build \
    -installsuffix 'static' \
    -o /pagerbot .

# Final stage: the running container.
FROM scratch AS final

# Import the user and group files from the first stage.
COPY --from=builder /user/group /user/passwd /etc/

# Import the compiled executable from the second stage.
COPY --from=builder /pagerbot /pagerbot

# Perform any further action as an unprivileged user.
USER nobody:nobody

# Run the compiled binary.
ENTRYPOINT ["/pagerbot"]
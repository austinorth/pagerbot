FROM goodeggs/platform-base:2.6.0
COPY --chown=docker:docker dist/linux_amd64/pagerbot config.yml ./

# syntax=docker/dockerfile:1
ARG RUBY_VERSION
ARG DISTRO_NAME=bullseye

FROM ruby:$RUBY_VERSION-slim-$DISTRO_NAME

ARG DISTRO_NAME

# Common dependencies
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

# Store Bundler settings in the project's root
ENV BUNDLE_APP_CONFIG=.bundle

# Uncomment this line if you want to run binstubs without prefixing with `bin/` or `bundle exec`
# ENV PATH /app/bin:$PATH

# Upgrade RubyGems and install the latest Bundler version
RUN gem update --system && \
    gem install bundler

# Create a directory for the app code
RUN mkdir -p /app
WORKDIR /app

# Document that we're going to expose port 5001
# EXPOSE 5001

# Use Bash as the default command
CMD ["/usr/bin/bash"]

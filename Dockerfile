#
# Builds a temporary image, with all the required dependencies used to compile
# the dependencies' dependencies.
# This image will be destroyed at the end of the build command.
#
FROM ruby:2.6.3-alpine3.9 AS build-env

ARG RAILS_ROOT=/application/
ARG BUILD_PACKAGES="build-base"
ARG DEV_PACKAGES=""
ARG RUBY_PACKAGES="tzdata"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $BUILD_PACKAGES \
                                $DEV_PACKAGES \
                                $RUBY_PACKAGES && \
    mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY Gemfile* $RAILS_ROOT

RUN touch ~/.gemrc && \
    echo "gem: --no-ri --no-rdoc" >> ~/.gemrc && \
    gem install rubygems-update && \
    update_rubygems && \
    gem install bundler && \
    bundle install --jobs $(nproc) && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . $RAILS_ROOT

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Builds the final image with the minimum of system packages
# and copy the gem's sources, Bundler gems and Yarn packages.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FROM ruby:2.6.3-alpine3.9

ARG RAILS_ROOT=/application/
ARG PACKAGES="bash tzdata"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache $PACKAGES && \
    mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

# Add a group or add a user to a group
#
#  -g GID   Group id
#  -S       Create a system group
#
# Create new user, or add USER to GROUP
#
#  -h DIR   Home directory
#  -g GECOS GECOS field
#  -s SHELL Login shell
#  -G GRP   Group
#  -S       Create a system user
#  -D       Don't assign a password
#  -H       Don't create home directory
#  -u UID   User id
#  -k SKEL  Skeleton directory (/etc/skel)
RUN addgroup -S \
             nobrainer && \
    adduser -s /bin/sh \
            -G nobrainer\
            -S \
            -u 1000 \
            nobrainer && \
    chown -R nobrainer:nobrainer $RAILS_ROOT

COPY --from=build-env /usr/local/bundle/ /usr/local/bundle/
COPY --chown=nobrainer:nobrainer --from=build-env $RAILS_ROOT $RAILS_ROOT

USER nobrainer

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "-T"]

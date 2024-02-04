FROM ruby:2.7

ARG NODE_VERSION=18.x
ARG NODE_KEYRING=/usr/share/keyrings/nodesource.gpg
RUN wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor > $NODE_KEYRING \
  && echo "deb [signed-by=$NODE_KEYRING] https://deb.nodesource.com/node_$NODE_VERSION nodistro main" > /etc/apt/sources.list.d/nodesource.list \
  && echo "deb-src [signed-by=$NODE_KEYRING] https://deb.nodesource.com/node_$NODE_VERSION nodistro main" >> /etc/apt/sources.list.d/nodesource.list

RUN apt update && apt install -y build-essential imagemagick libmagickwand-dev nodejs hledger

WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app
RUN gem install bundler:1.17.3
RUN bundle install

COPY . /app

EXPOSE 80

CMD ["bundle", "exec", "smashing", "start", "-p", "80"]

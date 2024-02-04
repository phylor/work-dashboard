FROM ruby:2.7-slim

RUN apt update && apt install -y build-essential imagemagick libmagickwand-dev

WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app
RUN gem install bundler:1.17.3
RUN bundle install

COPY . /app

EXPOSE 80

CMD ["bundle", "exec", "smashing", "start", "-p", "80"]

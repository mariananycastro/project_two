FROM ruby:3.3.0

WORKDIR /app
COPY . /app

RUN bundle install

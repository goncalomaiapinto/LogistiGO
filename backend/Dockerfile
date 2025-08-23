FROM ruby:3.2

WORKDIR /app

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

COPY Gemfile* ./

RUN gem install rails bundler

COPY . .

EXPOSE 3000
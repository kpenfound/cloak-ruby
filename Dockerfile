FROM ruby:3.1.2-buster

WORKDIR /app

ENV RAILS_ENV "production"

EXPOSE 3000/tcp

COPY Gemfile* /app/
COPY bin/ /app/bin
RUN bundle config set force_ruby_platform true
RUN bin/bundle install

COPY . /app/

ENTRYPOINT ["bin/rails", "s", "-b", "0.0.0.0"]
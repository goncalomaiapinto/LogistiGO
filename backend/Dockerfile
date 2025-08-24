# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.2.9
FROM ruby:$RUBY_VERSION-slim

# Pasta da app
WORKDIR /app

# Instalar dependências do sistema
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libyaml-dev pkg-config curl nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Variáveis de ambiente bundler
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    RAILS_ENV=development

# Copiar gems e instalar
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copiar código da app
COPY . .

# Garantir que o bin/rails existe
RUN chmod +x bin/rails

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]

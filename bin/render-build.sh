#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile
SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:clean
SECRET_KEY_BASE_DUMMY=1 bundle exec rails db:migrate
SECRET_KEY_BASE_DUMMY=1 bundle exec rails db:seed

#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails SECRET_KEY_BASE_DUMMY=1  assets:precompile
bundle exec rails SECRET_KEY_BASE_DUMMY=1 assets:clean
bundle exec rails SECRET_KEY_BASE_DUMMY=1 db:migrate

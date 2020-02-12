# Evented Twitter

branches:

- wo-cqrs: without CQRS but reducer
- w-cqrs: with CQRS without reducers
- schemas: schemas validations
- declarative


# Environment

I use docker & docker-compose as my dev environment. 
It make it easier for me to work on any computer and don't have to think about setups.



Run `docker-compose run app` to get a new terminal with the correct environment.
and then run you ruby comman as you would `bundle install` first, then `bundle exec rake test` or `bundle exec rake console`.

Example on my setup started of the two first commands (notice the first one run on my computer, the second inside the container).
```
diegodursel$ docker-compose run app

Creating network "youtube_channel_default" with the default driver
Building app
Step 1/6 : FROM ruby:2.6
 ---> 2ff4e698f315
Step 2/6 : WORKDIR /usr/src/app
 ---> Using cache
 ---> b19e6076a8b2
Step 3/6 : COPY Gemfile Gemfile.lock ./
 ---> Using cache
 ---> 2e361d6ea508
Step 4/6 : RUN bundle install
 ---> Using cache
 ---> 419ccfd43e13
Step 5/6 : COPY . .
 ---> 951219560b6a
Step 6/6 : CMD bundle exec /bin/bash
 ---> Running in e49331ac323c
Removing intermediate container e49331ac323c
 ---> b132be1f1057
Successfully built b132be1f1057
Successfully tagged youtube_channel_app:latest
WARNING: Image for service app was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.

root@56b23861e7b5:/usr/src/app# bundle

Using rake 13.0.1
Using concurrent-ruby 1.1.5
Using i18n 1.8.2
Using minitest 5.14.0
Using thread_safe 0.3.6
Using tzinfo 1.2.6
Using zeitwerk 2.2.2
Using activesupport 6.0.2.1
Using activemodel 6.0.2.1
Using activerecord 6.0.2.1
Using bundler 1.17.2
Using byebug 11.1.1
Using minitest-focus 1.1.2
Bundle complete! 5 Gemfile dependencies, 13 gems now installed.
Bundled gems are installed into `/usr/local/bundle`
```

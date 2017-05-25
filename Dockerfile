FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential 
RUN mkdir /docmanager
WORKDIR /docmanager
ADD * /docmanager/
RUN bundle install
ADD . /docmanager
This is a backend for Transparency Toolkit's other tools (LookingGlass,
Harvester, Catalyst). It indexes data, stores the documents, and processes
queries all in one place.

# Installation

## Dependencies

* elasticsearch 5.2.2
* ruby 2.4.1
* rails 5.0.2

## Setup Instructions

1. Install the dependencies

* Download elasticsearch (https://www.elastic.co/downloads/elasticsearch)
* Download rvm (https://rvm.io/rvm/install)
* rvm install 2.4.1 and rvm use 2.4.1
* gem install rails
* bundle install

2. Run

* Start elasticsearch (exact method depends on installation method)
* rails server

3. To Run Tests

* bundle exec rspec

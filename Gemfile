source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
gem 'puma', '~> 3.0'
gem 'mongoid'

group :development, :test do
  gem 'pry-byebug'
  gem 'rspec-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'curb'

# Elasticsearch dependencies
gem "elasticsearch", git: "https://github.com/elasticsearch/elasticsearch-ruby.git"
gem "elasticsearch-persistence", git: "https://github.com/elasticsearch/elasticsearch-rails.git", branch: "persistence-model", require:"elasticsearch/persistence/model"
gem "elasticsearch-rails", git: "https://github.com/elasticsearch/elasticsearch-rails.git"
gem "elasticsearch-model"


source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
gem 'puma'
gem 'pg', '~> 0.20'
gem 'bootsnap'
gem 'sprockets', '~>3.0'

group :development, :test do
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'awesome_print'
  gem 'method_source'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'curb'
gem 'rsync'

# Elasticsearch dependencies
gem 'elasticsearch', '~> 5'
gem 'elasticsearch-persistence', '~> 5'
gem 'elasticsearch-rails', '~> 5'
gem 'elasticsearch-model', '~> 5'


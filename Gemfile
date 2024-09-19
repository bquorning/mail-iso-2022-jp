source "https://rubygems.org"

gemspec path: "."

if mail_gem_version = ENV['MAIL_GEM_VERSION']
  if mail_gem_version == "HEAD"
    gem "mail", :git => "git@github.com:mikel/mail.git"
  else
    gem "mail", "~> #{mail_gem_version}"
  end
else
  gem "mail", "<= 2.7.0"
end

rails_version = ENV['MAIL_ISO_2022_JP_RAILS_VERSION']

group :development, :test do
  gem "rake"
  gem "bundler"
  gem "activesupport"
  gem "minitest"
  gem "test-unit"
  if rails_version == "edge"
    gem "actionmailer", :git => "git://github.com/rails/rails.git"
  elsif rails_version && rails_version.strip != ""
    gem "actionmailer", "~> #{rails_version}"
  end
  gem "rdoc", ">= 3.12"
end

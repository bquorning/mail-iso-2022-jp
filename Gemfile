source "https://rubygems.org"

gemspec

gem "rake"
gem "minitest"
gem "minitest-rg"
gem 'net-imap', '~> 0.2.2'
gem 'net-pop', '~> 0.1.1'
gem 'net-smtp', '~> 0.3.0'
gem "nkf"
gem "rdoc", ">= 3.12"

mail_gem_version = ENV['MAIL_GEM_VERSION']
if mail_gem_version == "edge"
  gem "mail", :git => "git@github.com:mikel/mail.git"
elsif mail_gem_version
  gem "mail", mail_gem_version
else
  gem "mail"
end

rails_version = ENV['ACTIONMAILER_GEM_VERSION']
if rails_version == "edge"
  gem "actionmailer", :git => "git://github.com/rails/rails.git"
elsif rails_version
  gem "actionmailer", rails_version
else
  gem "actionmailer", ">= 7.2"
end

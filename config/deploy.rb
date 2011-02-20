set :application, "Brutal Venom"

set :scm, :git
set :repository,  "digitalaugment-deploy:da-bv-rails"
set :branch, "master"
set :user, "deploy"
set :scm_passphrase, "Deploy4DApP%#!"
ssh_options[:keys] = %w(~/.ssh/deploy@DevelopmentServer)
set :ssh_options, {:forward_agent => true}

set :deploy_to, "/var/www/brutalvenom"

server "digitalaugment.com", :app, :web, :db, :primary => true

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end
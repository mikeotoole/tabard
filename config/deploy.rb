# Main Details
set :application, "brutalvenom.digitalaugment.com"
role :web, "brutalvenom.digitalaugment.com"
role :app, "brutalvenom.digitalaugment.com"
role :db,  "brutalvenom.digitalaugment.com", :primary => true

# Server Details
set :default_run_options, {:pty => true}
set :ssh_options, {:keys => %w(~/.ssh/deploy@DevelopmentServer)}
set :ssh_options, {:forward_agent => true}
set :deploy_to, "/var/www/deploy/brutalvenom"
set :deploy_via, :remote_cache
set :user, "deploy"
set :use_sudo, false

# Repo Details
set :scm, :git
set :scm_username, "deploy"
set :scm_passphrase, "Deploy4DApP%#!"
set :repository, "digitalaugment-deploy:da-bv-rails"
set :branch, "master"
set :git_enable_submodules, 1

# Tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink Shared Resources on Each Release"
  task :symlink_shared, :roles => :app do
    #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'
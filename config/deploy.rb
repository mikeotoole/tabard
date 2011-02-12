set :application, "Brutal Venom"

set :repository,  "git.digitalaugment.com:da-bv-rails.git"
set :scm, :git
set :scm, "git"
set :user, "$USER"
set :scm_passphrase, "$PASSPHRASE"
set :ssh_options, {:forward_agent => true}

set :deploy_to, "/var/www/brutalvenom"

server "digitalaugment.com", :app, :web, :db, :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :best_practices do
  desc "check the app against best practices"
  task :html do
    exec "rails_best_practices -f html --with-textmate"
  end
end
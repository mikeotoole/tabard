namespace :annotate do
  desc "annotate your models"
  task :models do
    exec "annotate --exclude tests, fixtures"
  end
  desc "annotate the routes"
  task :routes do
    exec "annotate -r"
  end
end

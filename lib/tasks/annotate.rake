namespace :annotate do
  desc "Annotates all model files"
  task :models do
    exec "annotate --exclude tests, fixtures"
  end
  desc "Annotates routes.rb file"
  task :routes do
    exec "annotate -r"
  end
end

namespace :db do
  task :migrate do 
    if Rails.env.development?
      require "annotate/annotate_models"
      AnnotateModels.do_annotations(:position_in_class => 'after', :position_in_fixture => 'before')
    end
  end
end

namespace :migrate do
  [:up, :down, :reset, :redo].each do |t|
    task t do 
      if Rails.env.development?
        require "annotate/annotate_models"
        AnnotateModels.do_annotations(:position_in_class => 'after', :position_in_fixture => 'before')
      end
    end
  end
end


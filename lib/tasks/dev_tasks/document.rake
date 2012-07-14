begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

# Monkey-patch to remove redoc'ing and clobber descriptions to cut down on rake -T noise
class RDocTaskWithoutDescriptions < RDoc::Task
  include ::Rake::DSL

  def define
    task rdoc_task_name

    task rerdoc_task_name => [clobber_task_name, rdoc_task_name]

    task clobber_task_name do
      rm_r rdoc_dir rescue nil
    end

    task clobber: [clobber_task_name]

    directory @rdoc_dir
    task rdoc_task_name => [rdoc_target]
    file rdoc_target => @rdoc_files + [Rake.application.rakefile] do
      rm_r @rdoc_dir rescue nil
      @before_running_rdoc.call if @before_running_rdoc
      args = option_list + @rdoc_files
      if @external
        argstring = args.join(' ')
        sh %{ruby -Ivendor vendor/rd #{argstring}}
      else
        require 'rdoc/rdoc'
        RDoc::RDoc.new.document(args)
      end
    end
    self
  end
end

namespace :doc do
  def gem_path(gem_name)
    path = $LOAD_PATH.grep(/#{gem_name}[\w.-]*\/lib$/).first
    yield File.dirname(path) if path
  end

  RDocTaskWithoutDescriptions.new("dev") { |rdoc|
    rdoc.rdoc_dir = 'doc/developer'
    rdoc.template = ENV['template'] if ENV['template']
    rdoc.title = ENV['title'] || "Rails Application Developer Documentation"
    rdoc.options << '--line-numbers'
    rdoc.options << '--all'
    rdoc.options << '--charset' << 'utf-8'
    rdoc.options << '--main' << 'doc/README_FOR_APP'
    rdoc.rdoc_files.include('doc/README_FOR_APP')
    rdoc.rdoc_files.include('app/**/*.rb')
    rdoc.rdoc_files.include('lib/**/*.rb')
  }
  Rake::Task['doc:dev'].comment = "Generate developer level docs for the app. (Uses the --all option)"
end

namespace :reports do
  desc "Run all of the reports"
  task :all => [:docs, :notes, :best_practices, :tests] do
    puts "Reports generated and output to doc/reports!"
    system "echo \"All reports generated at #{Time.now.to_s}\" | tee doc/reports/all_reports.log"
  end
  
  desc "Create a coverage report for documentation"
  task :docs => [:ensure_report_dir] do
    puts "Generateing documentation coverage report..."
    system "rdoc app lib --coverage-report | tee doc/reports/coverage_report.txt"
  end
  
  desc "Create a report on all notes"
  task :notes  => [:ensure_report_dir] do
    puts "Collecting all of the code notes..."
    system "rake notes | tee doc/reports/notes_report.txt"
  end
  
  desc "Create a report on best practices"
  task :best_practices  => [:ensure_report_dir] do
    puts "Verifying against best practices..."
    system "rails_best_practices -f html --with-textmate > /dev/null"
    system "mv rails_best_practices_output.html doc/reports/rails_best_practices_report.html"
  end
  
  desc "Create a report on tests"
  task :tests  => [:ensure_report_dir] do
    puts "Preparing tests..."
    Rake::Task['db:test:prepare'].execute
    puts "Running tests..."
    system "rake test | tee doc/reports/test_report.txt"
  end
  
  task :ensure_report_dir do
    mkdir "doc/reports" unless File.exists?("doc/reports")
  end
end
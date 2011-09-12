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
    #puts "Checking for incorrect style block comments..."
    #system "grep -lr --exclude=report.rake \"=begin\" . | tee doc/reports/old_style_begins.txt"
    #system "grep -lr --exclude=report.rake \"=end\" . | tee doc/reports/old_style_end.txt"
  end

  desc "Create a report on all notes"
  task :notes  => [:ensure_report_dir] do
    puts "Collecting all of the standard code notes..."
    system "rake notes | tee doc/reports/code_notes.txt"
    puts "Collecting all of the testing code notes..."
    system "rake notes:custom ANNOTATION=TESTING | tee doc/reports/testing_notes.txt"
  end

  desc "Create a report on best practices"
  task :best_practices  => [:ensure_report_dir] do
    puts "Verifying against best practices..."
    system "rails_best_practices -f html --with-textmate > /dev/null"
    system "mv rails_best_practices_output.html doc/reports/rails_best_practices_report.html"
  end

  desc "Create a report on tests"
  task :tests  => [:ensure_report_dir] do
    puts "Running tests..."
    system "rake spec | tee doc/reports/test_report.txt"
  end

  task :ensure_report_dir do
    mkdir "doc/reports" unless File.exists?("doc/reports")
  end
end

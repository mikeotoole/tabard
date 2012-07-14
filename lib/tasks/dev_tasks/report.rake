require 'simplecov'

namespace :reports do
  desc "Run all of the reports"
  task :all => [:docs, :notes, :best_practices, :tests, :brakeman_scan] do
    puts "\nReports generated and output to doc/reports!"
    system "echo \"All reports generated at #{Time.now.to_s}\" | tee doc/reports/all_reports.log"
  end

  desc "Create a coverage report for documentation"
  task :docs => [:ensure_report_dir] do
    puts "Generateing documentation coverage report..."
    system "rdoc app lib --coverage-report | tee doc/reports/doc_coverage_report.txt"
    #puts "Checking for incorrect style block comments..."
    #system "grep -lr --exclude=report.rake \"=begin\" . | tee doc/reports/old_style_begins.txt"
    #system "grep -lr --exclude=report.rake \"=end\" . | tee doc/reports/old_style_end.txt"
  end

  desc "Create a report on all notes"
  task :notes  => [:ensure_report_dir] do
    puts "Collecting all of the standard code notes..."
    system "rake notes | tee doc/reports/code_notes.txt"
    puts "Collecting all HACK code notes..."
    system "rake notes:custom ANNOTATION=HACK | tee -a doc/reports/code_notes.txt"
    puts "Collecting all view code notes..."
    system "grep -rnE 'OPTIMIZE:|OPTIMIZE|FIXME:|FIXME|TODO:|TODO|HACK:|HACK' app/views | tee -a doc/reports/code_notes.txt"
    puts "Collecting all of the testing code notes... (see file for output)"
    system "rake notes:custom ANNOTATION=TESTING > doc/reports/testing_notes.txt"
  end

  desc "Create a report on best practices"
  task :best_practices  => [:ensure_report_dir] do
    puts "Verifying against best practices..."
    system "rails_best_practices -f html --with-textmate > /dev/null"
    system "mv rails_best_practices_output.html doc/reports/rails_best_practices_report.html"
  end

  desc "Create class diagrams"
  task :diagrams  => [:ensure_report_dir] do
    puts "\nCreating diagrams with railroady..."
    system "rake diagram:models:brief"        # Generates an abbreviated SVG class diagram for all models.
    system "rake diagram:models:complete"     # Generates an SVG class diagram for all models.
    puts "Moving diagrams to reports/diagrams..."
    mkdir "doc/reports/diagrams" unless File.exists?("doc/reports/diagrams")
    system "mv doc/*.svg doc/reports/diagrams/"
  end

  desc "Run brakeman to look for security issues"
  task :brakeman_scan => [:ensure_report_dir] do
    puts "\nRunning brakeman..."
    system "brakeman -o \"doc/reports/brakeman_report.html\""
  end

  desc "Create a report on tests"
  task :tests  => [:ensure_report_dir] do
    puts "\nRunning tests..."
    system "rake spec SPEC_OPTS=\"--format progress --format html --out doc/reports/test_report.html\""
  end

  task :ensure_report_dir do
    mkdir "doc/reports" unless File.exists?("doc/reports")
  end
end

# Update to rake notes
class SourceAnnotationExtractor
  alias orig_find find
  def find(dirs=%w(app lib test))
    # we added spec dir to rake notes task
    dirs << "spec"
    orig_find(dirs)
  end
end

namespace :scrub do
  desc "Clean all whitespace from code files"
  task :whitespace do
	puts "Cleaning up white space in *.rb files."
    system "find . -not -path '.rvm' -name \"*.rb\" -type f -print0 | xargs -0 sed -E \"s/[[:space:]]*$//\""
  end
end
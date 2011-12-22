namespace :scrub do
  desc "Clean all whitespace from code files"
  task :whitespace do
  puts "Cleaning up white space in *.rb files."
    system "find . -not -path '.rvm' -name \"*.rb\" -type f -print0 | xargs -0 sed -E \"s/[[:space:]]*$//\""
  end
  
  desc "Remove all .orig files"
  task :orig do
  puts "Cleaning up *.orig files."
    system 'find . -iname "*.orig" -exec rm "{}" ";"'
  end
end

# (The MIT License)
#
# Copyright (c) 2009 FIX
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
class NameRestricter

  VERSION = "0.0.1" # :nodoc:

  FULL = YAML.load_file("#{Rails.root}/config/name_lists/restricted_list.yml") # :nodoc:
  DOMAIN = FULL.select {|w| w[:domain]} # :nodoc:
  COMPANY = FULL.select {|w| w[:company]} # :nodoc:
  ADMINISTRATION = FULL.select {|w| w[:administration]} # :nodoc:


  DEFAULT_SETTINGS = {:domain => :forbidden,
                      :company => :forbidden,
                      :administration => :forbidden,
                      :custom_subs => {}} # :nodoc:

  # Makes this a singleton
  def self.singleton_class
    class << self; self; end
  end unless defined?(singleton_class)

  def self.forward_to_default(*methods) # :nodoc:
    methods.each do |method|
      singleton_class.class_eval do
        define_method method do |*args|
          DEFAULT_INSTANCE.send(method, *args)
        end
      end
    end
  end

  # Initializes class with default settings
  def initialize(settings=DEFAULT_SETTINGS)
    @settings = DEFAULT_SETTINGS
  end

  # :nodoc:
  DEFAULT_INSTANCE = new

  DEFAULT_OPTS = {:domain => true, :company => false, :administration => false} # :nodoc:

  # Used to add word to the in memory list.
  def add_word(text, opts={})
    opts = DEFAULT_OPTS.merge(opts)
    word = {:word => text}.merge(opts)
    DOMAIN << word   if word[:domain]
    COMPANY << word if word[:company]
    ADMINISTRATION << word if word[:administration]
  end
  forward_to_default :add_word

  def forbidden_words_from_settings # :nodoc:
    banned_words = []

    DOMAIN.each do |word|
      banned_words << word[:word]
    end if @settings[:domain] == :forbidden

    COMPANY.each do |word|
      banned_words << word[:word]
    end if @settings[:company] == :forbidden

    ADMINISTRATION.each do |word|
      banned_words << word[:word]
    end if @settings[:administration] == :forbidden

    banned_words
  end

  def update_settings_from_hash(hash) # :nodoc:
    self.check_domain = hash[:domain] if hash.has_key? :domain
    self.check_company = hash[:company] if hash.has_key? :company
    self.check_administration = hash[:administration] if hash.has_key? :administration
    self.check_all = hash[:all] if hash.has_key? :all
  end

  # Decides whether the given string is restriced, given NameRestricter's current
  # settings. Examples:
  #    NameRestricter.restriced?("www") #==> true
  #
  # With custom settings
  #    Profanalyzer.check_all = false
  #    Profanalyzer.check_domain = false
  #    Profanalyzer.restriced?("www") #==> false
  #
  # You can pass options to the method itself:
  #    Profanalyzer.restriced?("www", :domain => false) #==> false
  #
  # Available options:
  #
  # [:+all+]     Set to +true+ or +false+ to specify checking all words in the blacklist
  # [:+domain+]  Set to +true+ or +false+ to specify domain checking
  # [:+company+]  Set to +true+ or +false+ to specify company checking
  # [:+administration+]  Set to +true+ or +false+ to specify administration checking
  #
  def restriced?(*args)
    str = args[0]
    if (args.size > 1 && args[1].is_a?(Hash))
      oldsettings = @settings
      self.update_settings_from_hash args[1]
    end
    banned_words = self.forbidden_words_from_settings
    banned_words.each do |word|
      if str == word
        @settings = oldsettings if oldsettings
        return true
      end
    end
    @settings = oldsettings if oldsettings
    false
  end
  forward_to_default :restriced?

  # Sets NameRestricter to scan (or not scan) for domain words.
  # This is set to +true+ by default.
  def check_domain=(check)
    @settings[:domain] = (check) ? :forbidden : :ignore
  end

  # Sets NameRestricter to scan (or not scan) for company words.
  # This is set to +true+ by default.
  def check_company=(check)
    @settings[:company] = (check) ? :forbidden : :ignore
  end

  # Sets NameRestricter to scan (or not scan) for administration words.
  # This is set to +true+ by default.
  def check_administration=(check)
    @settings[:administration] = (check) ? :forbidden : :ignore
  end

  # Sets NameRestricter to scan (or not scan) for all profane words, based on the set tolerance.
  # This is set to +true+ by default.
  def check_all=(check)
    @settings[:domain] = (check) ? :forbidden : :ignore
    @settings[:company] = (check) ? :forbidden : :ignore
    @settings[:administration] = (check) ? :forbidden : :ignore
  end

  forward_to_default :check_domain=, :check_company=, :check_administration=, :check_all=
end

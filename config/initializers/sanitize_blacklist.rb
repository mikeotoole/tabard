###
# This is a blacklist used for testing the sanitizer for pages.
###
Sanitize::Config::BLACK = {
      elements: %w[
        yay !--yay-- !DOCTYPE acronym applet area article aside audio base basefont big body button canvas center
        command datalist dir div embed fieldset font footer form frame frameset h1 h4 h5 h6 head header hgroup
        hr html iframe input keygen label legend link map menu meta meter nav noframes noscript object optgroup
        option output param progress ruby script section select small source span strike style summary textarea
        title tt u video xmp
      ]
}

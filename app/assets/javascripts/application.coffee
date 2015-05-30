# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require turbolinks
#= require_tree .

$(->
  # For home page
  if $('.home').length > 0
    home = $('.home')
    logo = $('.logo')
    code = $('.qrcode img')

    # Init state
    logo.css
      width: code.width() * 0.22
      height: code.width() * 0.22
    logo.css
      top: code.offset().top + code.height()/2 - logo.height()/2
      left: code.offset().left + code.width()/2 - logo.width()/2

    # Dest state
    logo.delay(500).animate
      width: 640
      height: 640
      top: $(window).height() - 320
      left: $(window).width() / 2 - 320
    , 500, ->
      rotate = 0
      setInterval(->
        rotate += 5
        logo.css('transform', "rotate(#{rotate}deg)")
      , 100)
);

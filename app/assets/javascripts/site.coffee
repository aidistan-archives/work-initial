# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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

    # ($(window).height() - logo.height() / 2)
    # .css(top, )
# )

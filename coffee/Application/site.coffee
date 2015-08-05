define [ 'jquery', 'hljs', 'Application/editor' ], ($) ->
  _document = $(document)
  _document.ready ->

    class Menu

      Menu::init = ()->
        constructor: () ->
          Menu::tree = null

        _document.find("#viewDoc").find("h1,h2").each ->
          ###if($(this)[0].tagName is "h1")

          else###

          console.log($(this)[0].tagName)




    Menu::init()


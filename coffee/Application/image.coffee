define [
  'jquery'
  'taggd'
  'Application/editor'
], ($, taggd) ->
  _docum = $(document)
  _docum.ready ->

    class ImageTolltip
      constructor: (document, nameElement) ->
        ImageTolltip::tag = null
        ImageTolltip::data = []
        ImageTolltip::option =
          align: y: 'bottom'
          offset: top: -35
          handlers:
            click: 'toggle'

      ImageTolltip::init = ->
        if _docum.find('.taggd').length
          ImageTolltip::tag = _docum.find('.taggd').taggd ImageTolltip::option, ImageTolltip::data
        @

      ImageTolltip::edit = ->
        ImageTolltip::destroy()
        options =
          edit: true
          align: y: 'bottom'
          offset: top: -35
          handlers:
            click: 'toggle'
        if ImageTolltip::tag?
          ImageTolltip::tag = ImageTolltip::tag.taggd options, ImageTolltip::data
          ImageTolltip::tag.on 'change', ->
            ImageTolltip::data = ImageTolltip::tag.data

      ImageTolltip::save = ->
        ImageTolltip::destroy()
        if ImageTolltip::tag?
          ImageTolltip::tag.taggd ImageTolltip::option, ImageTolltip::data

      ImageTolltip::destroy = ->
        if ImageTolltip::tag?
          if ImageTolltip::tag.wrapper?
            img = ImageTolltip::tag.wrapper.find("img")
          else
            img = ImageTolltip::tag
          img.parents(".sub-section").html(img)
          ImageTolltip::tag = img



    image = new ImageTolltip()
    app.Image = image.init()
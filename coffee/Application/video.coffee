define [
  'jquery'
  'taggd'
  'video'
  'Application/editor'
], ($, taggd) ->
  _docum = $(document)
  _docum.ready ->

    class Video
      constructor: (document, nameElement) ->


      Video::init = ->
        Video::activate _docum.find(".videoView")
        @

      Video::activate = (element)->
        element.lazyYT()
        return


    video = new Video
    app.Video = video.init()
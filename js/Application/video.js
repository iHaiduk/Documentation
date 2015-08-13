define(['jquery', 'taggd', 'video', 'Application/editor'], function($, taggd) {
  var _docum;
  _docum = $(document);
  return _docum.ready(function() {
    var Video, video;
    Video = (function() {
      function Video(document, nameElement) {}

      Video.prototype.init = function() {
        Video.prototype.activate(_docum.find(".videoView"));
        return this;
      };

      Video.prototype.activate = function(element) {
        element.lazyYT();
      };

      return Video;

    })();
    video = new Video;
    return app.Video = video.init();
  });
});

define(['jquery', 'taggd', 'Application/editor'], function($, taggd) {
  var _docum;
  _docum = $(document);
  return _docum.ready(function() {
    var ImageTolltip, image;
    ImageTolltip = (function() {
      function ImageTolltip(document, nameElement) {
        ImageTolltip.prototype.tag = null;
        ImageTolltip.prototype.data = [];
        ImageTolltip.prototype.option = {
          align: {
            y: 'bottom'
          },
          offset: {
            top: -35
          },
          handlers: {
            click: 'toggle'
          }
        };
      }

      ImageTolltip.prototype.init = function() {
        ImageTolltip.prototype.tag = _docum.find('.taggd');
        return this;
      };

      ImageTolltip.prototype.edit = function() {
        var options;
        ImageTolltip.prototype.destroy();
        options = {
          edit: true,
          align: {
            y: 'bottom'
          },
          offset: {
            top: -35
          },
          handlers: {
            click: 'toggle'
          }
        };
        ImageTolltip.prototype.tag = ImageTolltip.prototype.tag.taggd(options, ImageTolltip.prototype.data);
        return ImageTolltip.prototype.tag.on('change', function() {
          return ImageTolltip.prototype.data = ImageTolltip.prototype.tag.data;
        });
      };

      ImageTolltip.prototype.save = function() {
        ImageTolltip.prototype.destroy();
        return ImageTolltip.prototype.tag.taggd(ImageTolltip.prototype.option, ImageTolltip.prototype.data);
      };

      ImageTolltip.prototype.destroy = function() {
        var img;
        if (ImageTolltip.prototype.tag.wrapper != null) {
          img = ImageTolltip.prototype.tag.wrapper.find("img");
        } else {
          img = ImageTolltip.prototype.tag;
        }
        img.parents(".sub-section").html(img);
        return ImageTolltip.prototype.tag = img;
      };

      return ImageTolltip;

    })();
    image = new ImageTolltip();
    return app.Image = image.init();
  });
});

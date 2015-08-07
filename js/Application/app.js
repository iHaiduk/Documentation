define(['jquery', "font"], function($, Typekit) {
  var _document;
  _document = $(document);
  _document.ready(function() {
    Typekit.load({
      async: true
    });
    $('.btn-product, .close').off('click').on('click', function() {
      var bool;
      bool = $(this).hasClass('btn-product');
      $('body').toggleClass('noScroll', bool);
      $('.popup').toggleClass('visible', bool);
    });
  });
});

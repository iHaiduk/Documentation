define(['jquery'], function($) {
  var _document;
  _document = $(document);
  _document.ready(function() {
    _document.find('.section').off('mouseenter mouseleave').on('mouseenter mouseleave', function(e) {
      $(this).find('span.btn-edit').toggleClass('visible', e.type === 'mouseenter');
    });
    $('.btn-product, .close').off('click').on('click', function() {
      var bool;
      bool = $(this).hasClass('btn-product');
      $('body').toggleClass('noScroll', bool);
      $('.popup').toggleClass('visible', bool);
    });
    $('.btn-toggle').click(function() {
      $(this).toggleClass('open');
    });
  });
});

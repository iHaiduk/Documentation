define(['jquery'], function($) {
  var _document;
  _document = $(document);
  _document.ready(function() {
    $(window).off('scroll').on('scroll', function() {
      var top;
      top = $(this).scrollTop();
      _document.find('.header').toggleClass('shadow', top > 0);
      _document.find('.nav').css({
        'margin-top': top + 'px'
      });
    });
    _document.find('.section').off('mouseenter mouseleave').on('mouseenter mouseleave', function(e) {
      $(this).find('span.btn-edit').toggleClass('visible', e.type === 'mouseenter');
    });
    $('.btn-product, .close').off('click').on('click', function() {
      var bool;
      bool = $(this).hasClass('btn-product');
      $('body').toggleClass('noScroll', bool);
      $('.popup').toggleClass('visible', bool);
    });
    $('.nav').find(".nav-item").off('click').on('click', function() {
      if ($(this).hasClass("parent")) {
        $(this).next().slideToggle(200);
      }
      $(this).parents(".nav").find(".active").removeClass('active');
      $(this).parent().addClass('active').parents(".nav-list").addClass('active');
    });
  });
});

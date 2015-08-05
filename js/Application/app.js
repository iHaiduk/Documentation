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

    var ink, d, x, y;
    $(".nav-item").click(function(e){
      if($(this).find(".ink").length === 0){
        $(this).prepend("<span class='ink'></span>");
      }

      ink = $(this).find(".ink");
      ink.removeClass("animate");

      if(!ink.height() && !ink.width()){
        d = Math.max($(this).outerWidth(), $(this).outerHeight());
        ink.css({height: d, width: d});
      }

      x = e.pageX - $(this).offset().left - ink.width()/2;
      y = e.pageY - $(this).offset().top - ink.height()/2;

      ink.css({top: y+'px', left: x+'px'}).addClass("animate");
    });
  });
});

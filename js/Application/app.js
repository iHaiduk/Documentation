/**
 * Created by Igor on 03.08.2015.
 */
define(['jquery'],function($) {
    var _document = $(document);
    _document.ready(function() {
        $(window).off("scroll").on("scroll", function(){
            var top = $(this).scrollTop();
            _document.find('.header').toggleClass('shadow', top > 0);
            _document.find('.nav').css({ "margin-top" : top + "px" });
        });
        _document.find('.section').off("mouseenter mouseleave").on("mouseenter mouseleave", function(e){
            $(this).find('span.btn-edit').toggleClass('visible', e.type === "mouseenter");
        });
        $('.btn-product, .close').off("click").on("click",function() {
            var bool = $(this).hasClass("btn-product");
            $('body').toggleClass('noScroll',bool);
            $('.popup').toggleClass('visible',bool);
        });
        $('.nav > .nav-list > .nav-item').on("click",function() {
            $(this).next().slideToggle(200);
        });
        $('.nav > .nav-list, .sub-nav > .nav-list').off("click").on("click",function() {
            $(this).addClass("active");
            $(this).siblings().removeClass("active");
        });
    });
});
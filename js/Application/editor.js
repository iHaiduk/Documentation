/**
 * Created by Igor on 02.08.2015.
 */
define(['jquery', 'hljs', 'redactor'],function($, hljs) {
    var _this = $(document);
    $(document).ready(function() {
        var obj = null,
            lastElement = null,
            position = {start:{x:0, y:0}, end:{x:0, y:0}};
        _this.find('.sub-section').each(function(){
            loadRedactor($(this));
        }).on("mousedown mouseup", function(event){
            if(event.type ==  "mousedown"){
                position.start.y = event.pageY;
                position.start.x = event.pageX;
            }else{
                position.end.y = event.pageY;
                position.end.x = event.pageX;
            }
        }).on('click', function(){
            if(window.getSelection().type === "Range"){
                var toolbar = $(this).prev();
                var readTop = position.start.y < position.end.y ? "start" : "end";
                toolbar.show().css({
                    top: (position[readTop].y - $(this).offset().top - 60)+"px",
                    left: (Math.abs(position.start.x + position.end.x)/2 - $(this).offset().left - toolbar.width()/2)+"px"
                });
            }else{
                _this.find('.sub-section').parent().find(".redactor-toolbar").hide();
            }
        });
        $.Redactor.prototype.highlight = function()
        {
            return {
                save: function()
                {
                    var html = this.code.get();
                    console.log(html);
                },
                init: function()
                {
                    var button = this.button.add('bold', 'Insert Code');
                    this.button.addCallback(button, this.highlight.code);
                },
                code: function()
                {
                    this.inline.format('pre', 'class', 'code');
                }
            };
        };
        function loadRedactor(element)
        {
            var positionCaret = 0;

            element.redactor({
                iframe: true,
                cleanStyleOnEnter: false,
                plugins: ["highlight"],
                initCallback: function()
                {
                    element.off('click', loadRedactor);

                    if(lastElement != null) {
                        lastElement.redactor('core.destroy');
                    }

                    $('#btn-save').show();
                },
                blurCallback: function(e)
                {
                    _this.find('.sub-section').parent().find(".redactor-toolbar").hide();
                }
            });
        }

        function saveRedactor()
        {
            // save content if you need
            var html = $('#redactor').redactor('code.get');

            // destroy editor
            $('#redactor').redactor('core.destroy');
            $('#btn-save').hide();
        }
        function escapeHtml(unsafe) {
            return unsafe
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#039;");
        }
    });
});
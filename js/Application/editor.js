/**
 * Created by Igor on 02.08.2015.
 */
define(['jquery', 'hljs', 'redactor'],function($, hljs) {
    $(document).ready(function() {
    var obj = null,
        lastElement = null;
    $('.btn-edit').on('click', function(){
        loadRedactor($(this).prev());
        lastElement = $(this).prev();
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
                this.selection.restore();
                element.off('click', loadRedactor);

                if(lastElement != null) {
                    console.log(lastElement.redactor('core'))
                    lastElement.redactor('core.destroy');
                }

                $('#btn-save').show();
            },
            blurCallback: function()
            {
                element.redactor('core.destroy');
            },
            destroyCallback: function(e)
            {
                lastElement = null;
                setTimeout(function() {
                    element.find("pre.code").each(function () {
                        hljs.highlightBlock(this);
                    });
                },1);
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
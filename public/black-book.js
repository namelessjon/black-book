// Javascript
// Jonathan D. Stott <jonathan.stott@gmail.com>
(function ($) {
    
}(jQuery));

$(document).ready(function () {
    $('table.edit-table tbody').delegate('tr:last-child input', 'change', function () {
        var tr = $(this).parents('tr'),
            trClone;
        trClone = tr.clone(false);
        trClone.find('input').val('');
        tr.after(trClone);
    });
    $('ul.edit-list').delegate('li:last-child input, li:last-child textarea', 'change', function () {
        var li = $(this).parents('li'),
            liClone;
        liClone = li.clone(false);
        liClone.find('input,textarea').val('');
        li.after(liClone);
    });
});

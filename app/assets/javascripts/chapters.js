$(function () {
  $("ul#chapter").sortable();

  $("input#save_order").click(function (click) {
    var count = 1;
    $.each($('input.chapter'), function() {
      $(this).val(count++)
    });
  });
});

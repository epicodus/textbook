$(function () {
  $("ul#chapter").sortable();
  $("ul.section").sortable();

  $("input#save_order").click(function (click) {
    var count = 1;
    $.each($('input.chapter'), function() {
      $(this).val(count++)
    });

    var count = 1;
    $.each($('input.section'), function() {
      $(this).val(count++)
    });
  });
});

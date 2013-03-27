$(function () {
  $("ul#chapter").sortable();
  $("ul.section").sortable();
  $("ul.lesson").sortable();

  $("input#save_order").click(function (click) {
    var count = 1;
    $.each($('input.chapter'), function() {
      $(this).val(count++)
    });

    var count = 1;
    $.each($('input.section'), function() {
      $(this).val(count++)
    });

    var count = 1;
    $.each($('input.lesson'), function() {
      $(this).val(count++)
    });
  });
});

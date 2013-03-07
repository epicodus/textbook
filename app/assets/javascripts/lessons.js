$(function () {
  $("a.chapter,a.section").click(function (click) {
    $(this).nextAll('ul').toggle();
    click.preventDefault();
  });
});

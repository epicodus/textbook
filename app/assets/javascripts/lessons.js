$(function () {
  $("a.chapter,a.section").click(function () {
    $(this).nextAll('ul').toggle();
  });
});

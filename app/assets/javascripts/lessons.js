$(function () {
  prettyPrint();

  $("a.course,a.section").click(function (click) {
    $(this).nextAll('ul').toggle();
    $(this).nextAll('ol').toggle();
    click.preventDefault();
  });

  $(".video").fitVids();
});

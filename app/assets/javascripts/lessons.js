$(function () {
  prettyPrint();

  $("a.course,a.section").click(function (click) {
    $(this).nextAll('ul').toggle();
    click.preventDefault();
  });

  $(".video").fitVids();
});

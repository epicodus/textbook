$(function () {
  prettyPrint();

  $("a.course,a.section").click(function (click) {
    $(this).nextAll('ul').toggle();
    $(this).nextAll('ol').toggle();
    click.preventDefault();
  });

  $(".video").fitVids();

  if(document.getElementById("table-of-contents")) {
    $('a[target="_blank"]').removeAttr('target');
  }
});

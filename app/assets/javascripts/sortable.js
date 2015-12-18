$(function () {
  $(".sortable").sortable({
  });

  $("input#save_order").click(function () {
    updateNumbers('body', 'input.section_number');
    updateNumbers('body', 'input.course_number');
    updateNumbers('.section', 'input.lesson');
  });
});

function updateNumbers(parent, input) {
  $(parent).each(function() {
    var count = 1;
    $(parent).find(input).each(function() {
      $(this).val(count++);
    });
  });
}

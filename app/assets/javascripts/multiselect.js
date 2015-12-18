$(function () {
  $('.multiselect-dropdown').multiselect({
    buttonClass: 'btn btn-info',
    maxHeight: 500,
    onChange: function(option) {
      $('#section-' + option.val() + '-lesson-type').toggle();
    }
  });

  $('.lesson-type').each(function() {
    if ($(this).find('input[type=radio]:checked').length === 1) {
      $(this).show();
    } else {
      $(this).hide();
    }
  });
});

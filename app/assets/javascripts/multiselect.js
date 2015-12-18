$(function () {
  $('.multiselect-dropdown').multiselect({
    buttonClass: 'btn btn-info',
    maxHeight: 500,
    onChange: function(option) {
      $('#section-' + option.val() + '-lesson-type').toggle();
      $('#section-' + option.val() + '-lesson-type').find('input[type=radio]:checked').attr('checked', false);
    }
  });

  $('.lesson-type').each(function() {
    if ($(this).find('input[type=radio]:checked').length === 2) {
      $(this).show();
    } else {
      $(this).hide();
    }
  });
});

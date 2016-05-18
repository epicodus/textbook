$(function () {
  $('.multiselect-dropdown').multiselect({
    buttonClass: 'btn btn-info',
    maxHeight: 500,
    onChange: function(option) {
      var lessonAttributes = $('#section-' + option.val() + '-lesson-type');
      var lessonAttributesInput = lessonAttributes.find('input[type=radio]');
      lessonAttributes.toggle();
      lessonAttributesInput.attr('checked', false);
      if (lessonAttributes.is(':visible')) {
        lessonAttributesInput.attr('required', true);
      } else {
        lessonAttributesInput.attr('required', false);
      }
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

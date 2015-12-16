$(function () {
  $('.multiselect-dropdown').multiselect({
    buttonClass: 'btn btn-info',
    maxHeight: 500,
    onChange: function(option, checked) {
      $('#section-' + option.val() + '-lesson-type').toggle();
    }
  });
  $('.lesson-type').hide();
});

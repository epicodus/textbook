$(function () {
  $('#change-theme').click(function() {
    if (document.cookie.includes('theme=darkmode')) {
      document.cookie = "theme=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    } else {
      document.cookie = 'theme=darkmode; path=/;';
    }
    window.location.reload();
  });
});
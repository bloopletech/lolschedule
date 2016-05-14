document.addEventListener("DOMContentLoaded", function(event) {
  if(!window.ontouchstart && !navigator.MaxTouchPoints && !navigator.msMaxTouchPoints) {
    document.body.classList.add("no-touch");
  }
});
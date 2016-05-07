function applyLink(event) {
  event.preventDefault();

  var firstToday = document.querySelectorAll(".match.today")[0];
  firstToday.scrollIntoView();
  window.scrollBy(0, -10);
}

document.addEventListener("DOMContentLoaded", function(event) {
  var links = document.getElementById("links");

  links.addEventListener("click", applyLink);
});
function applyLink(event) {
  event.preventDefault();

  var todayMatches = document.querySelectorAll(".match.today-ish:not(.filter-no-match)");
  var lastToday = todayMatches[todayMatches.length - 1];

  if(lastToday) {
    lastToday.scrollIntoView();
    window.scrollBy(0, -50);
  }
  else {
    window.scrollTo(0, 0);
  }
}

document.addEventListener("DOMContentLoaded", function(event) {
  var todayLink = document.querySelector("a.today");

  todayLink.addEventListener("click", applyLink);
});
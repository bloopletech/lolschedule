function jumpToToday(event) {
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

function jumpToEnd(event) {
  event.preventDefault();
  document.body.scrollIntoView(false);
}

document.addEventListener("DOMContentLoaded", function(event) {
  document.querySelector("a.today").addEventListener("click", jumpToToday);
  document.querySelector("a.end").addEventListener("click", jumpToEnd);
});
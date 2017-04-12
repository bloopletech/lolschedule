function jumpToToday() {
  var lastToday = document.querySelectorAll(".match.today-ish:not(.filter-no-match)")[0];

  if(lastToday) {
    var filtersHeight = document.getElementById("navbar").offsetHeight;
    window.scrollTo(0, lastToday.offsetTop - filtersHeight - 34);
  }
  else {
    window.scrollTo(0, 0);
  }
}

document.addEventListener("DOMContentLoaded", function(event) {
  document.querySelector("a#today").addEventListener("click", function(event) {
    event.preventDefault();
    jumpToToday();
  });

  document.querySelector("a#top").addEventListener("click", function(event) {
    event.preventDefault();
    window.scrollTo(0, 0);
  });

  document.querySelector("a#end").addEventListener("click", function(event) {
    event.preventDefault();
    document.documentElement.scrollIntoView(false);
  });

  document.querySelector("a#show-future").addEventListener("click", function(event) {
    event.preventDefault();
    document.body.classList.add("show-future");
  });
});

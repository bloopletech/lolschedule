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

function vodLinks(type) {
  if(document.body.classList.contains(type)) return;

  document.body.classList.remove("youtube");
  document.body.classList.remove("surprise");
  document.body.classList.add(type);
  document.querySelector("a#surprise-links").textContent = type == "surprise" ? "Surprise" : "YouTube";

  var vods = document.querySelectorAll("a.vod");

  for(var i = 0; i < vods.length; i++) {
    var vod = vods[i];
    vod.href = vod.dataset[type];
  }

  marshalFilters(selectedFilters());
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

  document.querySelector("a#surprise-links").addEventListener("click", function(event) {
    event.preventDefault();
    vodLinks(document.body.classList.contains("surprise") ? "youtube" : "surprise");
  });
});

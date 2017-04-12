function revealGame(event) {
  event.preventDefault();

  var games = this.parentNode;
  var nextGames = games.querySelectorAll("a.vod:not(.revealed)");
  var nextGame = nextGames[0];

  if(nextGame) nextGame.classList.add("revealed");
}

document.addEventListener("DOMContentLoaded", function(event) {
  document.body.addEventListener("click", function(e) {
    if(!e.target) return;

    if(e.target.matches(".reveal")) revealGame.call(e.target, e);

    var vs = e.target.closest(".vs");
    if(vs) vs.classList.add("reveal");
  });
});
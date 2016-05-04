function revealGame(event) {
  event.preventDefault();

  var games = this.parentNode;
  var nextGames = games.querySelectorAll("a.vod:not(.revealed)");
  var nextGame = nextGames[0];

  if(nextGame) nextGame.classList.add("revealed");
}

function selectButton() {
  document.body.classList.remove("select-future");
  document.body.classList.remove("select-all");
  document.body.classList.remove("select-current-week");
  document.body.classList.add(this.id);

  setQueryParams();
}

/* from https://css-tricks.com/snippets/javascript/get-url-variables/ */
function getQueryParams()
{
  var params = {};
  var query = window.location.hash.substring(1);
  var vars = query.split("&");
  for(var i = 0; i < vars.length; i++) {
    var pair = vars[i].split("=");
    params[pair[0]] = pair[1];
  }
  return params;
}

function setQueryParams() {
  var classes = document.body.classList;
  var select = '';
  for(var i = 0; i < classes.length; i++) {
    if(classes[i].match(/^select-/g)) {
      select = classes[i];
      break;
    }
  }

  var params = {
    filter: document.getElementById('filter').value,
    select: select
  }

  window.location.hash = "#" + Object.keys(params).map(k => k + '=' + params[k]).join('&');
}

document.addEventListener("DOMContentLoaded", function(event) {
  document.body.addEventListener("click", function(e) {
    if(e.target && e.target.matches(".reveal")) revealGame.call(e.target, e);
  });

  /*var params = getQueryParams();

  document.getElementById('select-current-week').addEventListener("click", selectButton);
  document.getElementById('select-future').addEventListener("click", selectButton);
  document.getElementById('select-all').addEventListener("click", selectButton);
  document.getElementById('filter').addEventListener("keyup", filterMatches);

  if(params['filter']) {
    document.getElementById('filter').value = params['filter'];
    filterMatches();
  }

  if(params['select']) document.getElementById(params['select']).click();
  else document.getElementById('select-current-week').click();*/
});
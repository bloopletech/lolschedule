function layoutMatches() {
  var menuHeight = document.getElementById('menu').offsetHeight;
  var leaguesWrapper = document.getElementById('leagues-wrapper');
  leaguesWrapper.style.height = (window.innerHeight - 16 - menuHeight) + 'px';

  document.getElementById('leagues-inner').style.height = leaguesWrapper.clientHeight + 'px';
}

function selectButton() {
  document.body.classList.remove("select-future");
  document.body.classList.remove("select-all");
  document.body.classList.remove("select-current-week");
  document.body.classList.add(this.id);

  setQueryParams();
}

function filterMatches() {
  document.body.classList.remove("filter");

  var query = document.getElementById('filter').value;
  if(query != "") {
    document.body.classList.add("filter");

    var matches = document.querySelectorAll(".match");
    for(var i = 0; i < matches.length; i++) matches[i].classList.remove("filter-match");

    var terms = query.toUpperCase().split(/[ ,]/);
    for(var i = 0; i < terms.length; i++) {
      var matching = document.querySelectorAll(".match[class*='" + terms[i] + "']");
      for(var j = 0; j < matching.length; j++) matching[j].classList.add("filter-match");
    }
  }

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
  layoutMatches();
  window.addEventListener('resize', layoutMatches);

  var params = getQueryParams();

  document.getElementById('select-current-week').addEventListener("click", selectButton);
  document.getElementById('select-future').addEventListener("click", selectButton);
  document.getElementById('select-all').addEventListener("click", selectButton);
  document.getElementById('filter').addEventListener("keyup", filterMatches);

  if(params['filter']) {
    document.getElementById('filter').value = params['filter'];
    filterMatches();
  }

  if(params['select']) document.getElementById(params['select']).click();
  else document.getElementById('select-current-week').click();
});
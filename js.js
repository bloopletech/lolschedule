function parseTimes() {
  var now = moment();

  var times = document.querySelectorAll(".time");
  for(var i = 0; i < times.length; i++) {
    var time = moment(times[i].dataset.value);

    var parts = [];
    parts.push(time.isSame(now, 'day') ? '[Today] ' : 'ddd D MMM ');
    parts.push((time.minutes() == 0) ? 'hA' : 'h:mmA');
    times[i].innerHTML = time.format(parts.join(''));

    var earlyStart = time.subtract(3, 'hours');
    var scheduledEnd = time.add(3, 'hours');

    var matchElement = times[i].parentNode;
    if(scheduledEnd.isBefore(now)) matchElement.classList.add("past");
    if(now.isSameOrAfter(earlyStart) && now.isSameOrBefore(scheduledEnd)) matchElement.classList.add("current");
    if(time.isSame(now, 'day')) matchElement.classList.add("today");
    if(time.isSame(now, 'isoweek')) matchElement.classList.add("current-week");
    if(earlyStart.isSameOrAfter(now)) matchElement.classList.add("future");
  }
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

function showGames(videoElement) {
  var urls = JSON.parse(videoElement.dataset.urls);

  var modal = document.getElementById('modal');
  var modalBody = document.getElementById('modal-body');
  modalBody.innerHTML = '';

  for(var i = 0; i < urls.length; i++) {
    var element = document.createElement('a');
    element.href = urls[i];
    element.innerHTML = 'Game ' + (i + 1);
    element.target = '_blank';
    modalBody.appendChild(element);
  }

  modal.style.display = 'block';
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
  parseTimes();
  window.setInterval(parseTimes, 60000);

  var params = getQueryParams();

  document.getElementById('select-current-week').addEventListener("click", selectButton);
  document.getElementById('select-future').addEventListener("click", selectButton);
  document.getElementById('select-all').addEventListener("click", selectButton);
  document.getElementById('filter').addEventListener("keyup", filterMatches);

  document.body.addEventListener('click', function(event) {
    if(event.target.matches('.match.games, .match.games *')) {
      event.stopPropagation();
      var target = event.target;
      while(!target.matches('.match.games')) target = target.parentNode;
      showGames(target);
    }
  });

  document.getElementById('modal-close').addEventListener('click', function() {
    document.getElementById('modal').style.display = 'none';
  });

  if(params['filter']) {
    document.getElementById('filter').value = params['filter'];
    filterMatches();
  }

  if(params['select']) document.getElementById(params['select']).click();
  else document.getElementById('select-current-week').click();
});
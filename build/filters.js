function filterMatches(terms) {
  var selectors = [];
  for(var j = 0; j < terms.length; j++) selectors.push(":not([class*='" + terms[j] + "'])");

  if(selectors.length == 0) return;

  var matching = document.querySelectorAll(".match:not(.filter-no-match)" + selectors.join(""));
  for(var j = 0; j < matching.length; j++) matching[j].classList.add("filter-no-match");
}

function applyFilters() {
  var matches = document.querySelectorAll(".match");
  for(var i = 0; i < matches.length; i++) matches[i].classList.remove("filter-no-match");

  var filters = document.querySelectorAll(".filter-group");
  for(var i = 0; i < filters.length; i++) {
    var selected = filters[i].querySelectorAll("li.selected");

    var terms = [];

    for(var j = 0; j < selected.length; j++) {
      var term = selected[j].dataset.value;
      if(term != 'all') terms.push(term);
    }

    filterMatches(terms);
  }

  if(document.querySelectorAll(".match:not(#no-results):not(.filter-no-match)").length == 0) {
    document.getElementById("no-results").classList.remove("filter-no-match");
  }
  else {
    document.getElementById("no-results").classList.add("filter-no-match");
  }
}

function selectFilter() {
  this.classList.toggle("selected");

  updateFilterNames();
  applyFilters();
}

function triggerFilterList(event) {
  event.preventDefault();

  var selected = document.body.classList.add("open");

  closeAllFilters();

  if(!selected) {
    document.body.classList.add("filters-opened");
  }
}

function updateFilterNames() {
  var content = [];
  var filterGroups = document.querySelectorAll(".filter-group");
  for(var i = 0; i < filterGroups.length; i++) {
    var selected = filterGroups[i].querySelectorAll("li.selected");
    for(var j = 0; j < selected.length; j++) content.push(selected[j].textContent);
  }

  var filter = document.querySelector("#filter a.trigger");
  if(content.length > 0) filter.textContent = content.join(", ");
  else filter.textContent = "All";
}

function closeFilter(event) {
  event.preventDefault();

  closeAllFilters();
}

function closeAllFilters() {
  document.body.classList.remove("filters-opened");
}

document.addEventListener("DOMContentLoaded", function(event) {
  document.body.addEventListener("click", function(e) {
    if(e.target && e.target.matches("#filters > li a.trigger")) triggerFilterList.call(e.target, e);
    if(e.target && e.target.matches("#filters-content ul.filter-list li")) selectFilter.call(e.target, e);
    if(e.target && e.target.matches("#filters-content a.close")) closeFilter.call(e.target, e);
  });

  updateFilterNames();
  applyFilters();
});
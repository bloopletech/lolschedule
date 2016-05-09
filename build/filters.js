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

  var filters = document.querySelectorAll("#filters > li");
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
  var parent = this.parentNode;
  while(parent.nodeName != 'LI') parent = parent.parentNode;

  if(parent.classList.contains("multi")) {
    this.classList.toggle("selected");
  }
  else {
    parent.classList.remove("open");

    var filters = parent.querySelectorAll("li");
    for(var i = 0; i < filters.length; i++) {
      filters[i].classList.remove("selected");
    }

    this.classList.add("selected");
  }

  updateFilterNames();
  applyFilters();
}

function triggerFilterList(event) {
  event.preventDefault();

  var selected = this.parentNode.classList.contains("open");

  closeAllFilters();

  if(!selected) {
    this.parentNode.classList.add("open");

    var backdrop = document.getElementById("backdrop");
    backdrop.classList.add("visible");
  }
}

function updateFilterNames() {
  var filterListTriggers = document.querySelectorAll("a.trigger");
  for(var i = 0; i < filterListTriggers.length; i++) {
    var selected = filterListTriggers[i].parentNode.querySelectorAll("li.selected");

    if(selected.length > 0) {
      var names = [];
      for(var j = 0; j < selected.length; j++) names.push(selected[j].textContent);

      filterListTriggers[i].textContent = names.join(", ");
    }
    else {
      filterListTriggers[i].textContent = "All";
    }
  }
}

function closeFilter(event) {
  event.preventDefault();

  this.parentNode.parentNode.classList.remove("open");
}

function closeAllFilters() {
  var openFilterLists = document.querySelectorAll("#filters > li.open");
  for(var i = 0; i < openFilterLists.length; i++) openFilterLists[i].classList.remove("open");

  var backdrop = document.getElementById("backdrop");
  backdrop.classList.remove("visible");
}

document.addEventListener("DOMContentLoaded", function(event) {
  document.body.addEventListener("click", function(e) {
    if(e.target && e.target.matches("#filters > li a.trigger")) triggerFilterList.call(e.target, e);
    if(e.target && e.target.matches("#filters > li ul.filter-list li")) selectFilter.call(e.target, e);
    if(e.target && e.target.matches("#filters > li a.close")) closeFilter.call(e.target, e);
    //if(e.target && !e.target.matches("div.filter, div.filter *")) closeAllFilters.call(e.target, e);
  });

  var backdrop = document.getElementById("backdrop");
  backdrop.addEventListener("click", function(event) {
    event.stopPropagation();
    closeAllFilters();
  });

  updateFilterNames();
  applyFilters();
});
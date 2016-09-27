function renderMatch(match) {
  console.log(match);
  var html = [];
  var classes = ["match", "clearfix", match.league_slug, match.team_1_acronym, match.team_2_acronym];

  html.push("<div class='" + classes.join(" ") + "'>");
  html.push("<div class='data'>" + match.team_1_acronym + " vs " + match.team_2_acronym + ", at " + match.time + "</div>");
  html.push("</div>");
  
  return html.join("");
}

document.addEventListener("DOMContentLoaded", function(event) {
  var listContainer = document.querySelector('#matches-root');
  
  

  function render(count) {
    var cellsFrag = document.createDocumentFragment();

    for(var i = 0; i < count; i++) {
      var cell = document.createElement('div'),
      match = this.data[i];

      cell.className = 'ScrollListView-cell';
      cell.innerHTML = renderMatch(match);
      cellsFrag.appendChild(cell);
    }

    listContainer.appendChild(cellsFrag);
  }

  function renderCell(cell, index) {
    cell.innerHTML = renderMatch(this.data[index]);
  }

  var iscroll = new IScroll('#matches-root', {
    mouseWheel: true,
    infiniteElements: '#scroller .match',
    //infiniteLimit: 2000,
    dataset: requestData,
    dataFiller: updateContent,
    cacheSize: 1000
  });
});
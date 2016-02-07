// Returns the ISO week of the date.
Date.prototype.getWeek = function() {
  var date = new Date(this.getTime());
  date.setHours(0, 0, 0, 0);
  // Thursday in current week decides the year.
  date.setDate(date.getDate() + 3 - (date.getDay() + 6) % 7);
  // January 4 is always in week 1.
  var week1 = new Date(date.getFullYear(), 0, 4);
  // Adjust to Thursday in week 1 and count number of weeks from date to week1.
  return 1 + Math.round(((date.getTime() - week1.getTime()) / 86400000 - 3 + (week1.getDay() + 6) % 7) / 7);
}

Date.prototype.isSameDate = function(b) {
  return this.getDate() == b.getDate() && this.getMonth() == b.getMonth() && this.getFullYear() == b.getFullYear();
}

Date.prototype.formatDate = function(today) {
  var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  var ampm = (this.getHours() > 12) ? 'PM' : 'AM';
  var hours = this.getHours() % 12;
  if(hours == 0) hours = 12;

  var minutes = this.getMinutes();
  if(minutes == 0) minutes = '';
  else if(minutes < 10) minutes = ':0' + minutes;
  else minutes = ':' + minutes;

  if(this.isSameDate(today))
    var parts = ['Today', hours + minutes + ampm];
  else
    var parts = [days[this.getDay()], this.getDate(), months[this.getMonth()], hours + minutes + ampm];
  return parts.join(" ");
}

function parseTimes() {
  var now = new Date();

  var times = document.querySelectorAll(".time");
  for(var i = 0; i < times.length; i++) {
    var time = new Date(times[i].dataset.value);

    times[i].innerHTML = time.formatDate(now);

    var earlyStart = new Date(time.getTime());
    earlyStart.setHours(time.getHours() - 3);
    var scheduledEnd = new Date(time.getTime());
    scheduledEnd.setHours(time.getHours() + 3);

    var matchElement = times[i].parentNode;
    if(scheduledEnd.getTime() < now.getTime()) matchElement.classList.add("past");
    if((now.getTime() >= earlyStart) && (now.getTime() <= scheduledEnd)) matchElement.classList.add("current");
    if(time.isSameDate(now)) matchElement.classList.add("today");
    if(time.getWeek() == now.getWeek()) matchElement.classList.add("current-week");
    if(earlyStart.getTime() >= now.getTime()) matchElement.classList.add("future");
  }
}

document.addEventListener("DOMContentLoaded", function(event) {
  parseTimes();
  window.setInterval(parseTimes, 60000);
});
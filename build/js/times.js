Date.prototype.isSameDate = function(b) {
  return this.getDate() == b.getDate() && this.getMonth() == b.getMonth() && this.getFullYear() == b.getFullYear();
}

Date.prototype.isSameWeekFuzzy = function(b) {
  var startOfWeek = new Date(b.getTime());
  startOfWeek.setHours(startOfWeek.getHours(), 0, 0, 0);
  var day = startOfWeek.getDay() || 7;
  if(day !== 1) startOfWeek.setHours(-24 * (day - 1));
  startOfWeek.setHours(-24);

  var endOfWeek = new Date(startOfWeek.getTime());
  endOfWeek.setHours(24 * 9);

  return this.getTime() >= startOfWeek.getTime() && this.getTime() < endOfWeek.getTime();
}

Date.prototype.formatDate = function(today) {
  var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  var ampm = (this.getHours() >= 12) ? 'PM' : 'AM';
  var hours = this.getHours() % 12;
  if(hours == 0) hours = 12;

  var minutes = this.getMinutes();
  if(minutes == 0) minutes = '';
  else if(minutes < 10) minutes = ':0' + minutes;
  else minutes = ':' + minutes;

  if(this.isSameDate(today))
    var parts = ['Today', hours + minutes + ampm];
  else if(this.isSameWeekFuzzy(today) && this.getTime() > today.getTime())
    var parts = [days[this.getDay()], hours + minutes + ampm];
  else
    var parts = [days[this.getDay()], this.getDate(), months[this.getMonth()], hours + minutes + ampm];
  return parts.join(" ");
}

function parseTimes() {
  var now = new Date();

  var midnight = new Date(now.getTime());
  midnight.setHours(0, 0, 0, 0);

  var times = document.querySelectorAll(".time");
  for(var i = 0; i < times.length; i++) {
    var time = new Date(times[i].dataset.value);

    times[i].textContent = time.formatDate(now);

    var earlyStart = new Date(time.getTime());
    earlyStart.setHours(time.getHours() - 3);
    var scheduledEnd = new Date(time.getTime());
    scheduledEnd.setHours(time.getHours() + 3);

    var matchElement = times[i].parentNode;
    if(scheduledEnd.getTime() < now.getTime()) matchElement.classList.add("past");
    if((now.getTime() >= earlyStart) && (now.getTime() <= scheduledEnd)) matchElement.classList.add("current");
    if(time.isSameDate(now)) matchElement.classList.add("today");
    if(time.isSameWeekFuzzy(now)) matchElement.classList.add("current-week");
    if(earlyStart.getTime() >= now.getTime()) matchElement.classList.add("future");
    if(time.getTime() >= midnight.getTime()) matchElement.classList.add("today-ish");
  }
}

function parseFooterTimes() {
  var now = new Date();

  var times = document.querySelectorAll(".footer-time");
  for(var i = 0; i < times.length; i++) {
    var time = new Date(times[i].dataset.value);
    var minutes = Math.floor(((now - time) / 1000) / 60);

    times[i].textContent = (minutes == 0 ? "<1" : minutes) + (minutes == 0 ? " minute" : " minutes") + " ago";
  }
}

document.addEventListener("DOMContentLoaded", function(event) {
  parseTimes();
  window.setInterval(parseTimes, 60000);
  parseFooterTimes();
});
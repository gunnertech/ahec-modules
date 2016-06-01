$(function() {
  if (typeof course_base_url !== undefined) {
    minuteCount = $('#time-spent .minutes');
    secondCount = $('#time-spent .seconds');

    setInterval(function() {
      var seconds = parseInt(secondCount.text()) || 0;

      if (seconds > 58) {
        seconds = 0;
      } else {
        seconds += 1;
      }

      seconds = (seconds < 10 ? "0" : "") + seconds.toString();
      secondCount.text(seconds);
    }, 1000);

    setInterval(function() {
      var minutes = parseInt(minuteCount.text()) || 0;
      minutes += 1;

      minutes = (minutes < 10 ? "0" : "") + minutes.toString();
      minuteCount.text(minutes);

      $.post(course_base_url + "/time_spent", function() {
      }).fail(function(response) {
        console.log(response)
        alert("There was an Error logging your time spent on this course - please refresh the page.");
      });
    }, 60 * 1000);
  }
});

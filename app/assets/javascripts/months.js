var ready;

ready = function () {
  // Highlight current day on budget, or highlight the first day of the next
  // month if current day is greater than the last dated item of the month
  var now = new Date();
  var month = ('0' + (now.getMonth()+1)).slice(-2);
  var day = ('0' + now.getDate()).slice(-2);
  var year = now.getFullYear();
  var output = (month + '' + day + '' + year);
  var first = $('tbody:first tr:first').attr('class')
  var first_month = first.slice(0,2);
  var first_year = first.slice(-4);
  var first_of_month = (first_month + '01' + first_year);

  console.log('Sanity');
  console.log(output);
  console.log($('tr.' + output));

  if ($('tr.' + output).length) {
    console.log('A');
    // If today's date exists, highlight it 
    $('tr.' + output).css('background-color', '#C7DEC7');
  } else if (output < first_of_month) {
    console.log('B');
    // If today's date is less than the first date of the budget month,
    // highlight nothing
    return false;
  } else if (output > $('tbody:first tr:last').attr('class')) {
    console.log('C');
    // Check if today's date is greater than last row in current month,
    // and highlight first date in following month
    var first_next_month = $('tbody:last tr:first').attr('class');
    $('tr.' + first_next_month).css('background-color', '#C7DEC7');
  } else{
    console.log('D');
    // Else highlight the next existing date greater than today's date
    tr_array = $('tbody:first tr');

    $.each(tr_array, function(index, val){
      console.log('In Loop');
      if ($(val).attr('class') > output) {
        console.log('Greater than output!');
        $('tr.' + $(val).attr('class')).css('background-color', '#C7DEC7'); 
        return false;
      };
    });
  };
};

$(document).ready(ready);
$(document).on('page:load', ready);


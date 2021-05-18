window.initializeCodeFolding = function(show) {

  // handlers for show-all and hide all
  $("#rmd-show-all-code").click(function() {
    // close the dropdown menu when an option is clicked
    $("#allCodeButton").dropdown("toggle");
      // R show code
      $('div.r-code-collapse').each(function() {
        $(this).collapse('show');
      });
      // Python show code
      $('div.py-code-collapse').each(function() {
        $(this).collapse('show');
      }); 
      // Bash show code
      $('div.sh-code-collapse').each(function() {
        $(this).collapse('show');
      }); 
      
  });
  $("#rmd-hide-all-code").click(function() {
      // close the dropdown menu when an option is clicked
      $("#allCodeButton").dropdown("toggle");
      // Hide R code
      $('div.r-code-collapse').each(function() {
        $(this).collapse('hide');
      });
      // Hide Python code
      $('div.py-code-collapse').each(function() {
        $(this).collapse('hide');
      });
      // Hide Bash code
      $('div.sh-code-collapse').each(function() {
        $(this).collapse('hide');
      });
  });


  // index for unique code element ids
  var r_currentIndex  = 1;   // for R code
  var py_currentIndex = 1;   // for Python code
  var sh_currentIndex  = 1;   // for shell code

  // select Python chunks
  var pyCodeBlocks = $('pre.python');
  pyCodeBlocks.each(function() {
    // create a collapsable div to wrap the code in
    var div = $('<div class="collapse py-code-collapse"></div>');
    if (show)
      div.addClass('in');
    var id = 'pycode-643E0F36' + py_currentIndex++;
    div.attr('id', id);
    // "this" refers the code chunk
    $(this).before(div);
    $(this).detach().appendTo(div);
    $(this).css('background-color','#ebfaeb');  // change color of chunk background
    
    // add a show code button right above
    var showCodeText = $('<span>' + (show ? 'Hide Python code' : 'Python code') + '</span>');
    var showCodeButton = $('<button type="button" class="btn btn-default btn-xs code-folding-btn pull-right"></button>');
    showCodeButton.append(showCodeText);
    showCodeButton
        .attr('data-toggle', 'collapse')
        .attr('data-target', '#' + id)
        .attr('aria-expanded', show)
        .attr('aria-controls', id);    
        
    // change the background color of the button
    showCodeButton.css('background-color','#009900');
        
    var buttonRow = $('<div class="row"></div>');
    var buttonCol = $('<div class="col-md-12"></div>');
    buttonCol.append(showCodeButton);
    buttonRow.append(buttonCol);
    div.before(buttonRow);    
    
    // update state of button on show/hide
    div.on('hidden.bs.collapse', function () {
      showCodeText.text('Python code');
    });
    div.on('show.bs.collapse', function () {
      showCodeText.text('Hide Python code');
    });  
   });
  
  

  // select Bash shell chunks
  var shCodeBlocks = $('pre.bash');
  shCodeBlocks.each(function() {
    // create a collapsable div to wrap the code in
    var div = $('<div class="collapse sh-code-collapse"></div>');
    if (show)
      div.addClass('in');
    var id = 'shcode-643E0F36' + sh_currentIndex++;
    div.attr('id', id);
    // "this" refers the code chunk
    $(this).before(div);
    $(this).detach().appendTo(div);
    $(this).css('background-color','#A0A0A0');  // change color of chunk background
    
    // add a show code button right above
    var showCodeText = $('<span>' + (show ? 'Hide Bash code' : 'Bash code') + '</span>');
    var showCodeButton = $('<button type="button" class="btn btn-default btn-xs code-folding-btn pull-right"></button>');
    showCodeButton.append(showCodeText);
    showCodeButton
        .attr('data-toggle', 'collapse')
        .attr('data-target', '#' + id)
        .attr('aria-expanded', show)
        .attr('aria-controls', id);    
        
    // change the background color of the button
    showCodeButton.css('background-color','#cc7a00');
        
    var buttonRow = $('<div class="row"></div>');
    var buttonCol = $('<div class="col-md-12"></div>');
    buttonCol.append(showCodeButton);
    buttonRow.append(buttonCol);
    div.before(buttonRow);    
    
    // update state of button on show/hide
    div.on('hidden.bs.collapse', function () {
      showCodeText.text('Bash code');
    });
    div.on('show.bs.collapse', function () {
      showCodeText.text('Hide Bash code');
    });  
   });  


  // select all R code blocks
  // var rCodeBlocks = $('pre.sourceCode, pre.r, pre.bash, pre.sql, pre.cpp, pre.stan');
  // adding pre.sourceCode confuses the Python button
  var rCodeBlocks = $('pre.r, pre.sql, pre.cpp, pre.stan');
  rCodeBlocks.each(function() {
    // create a collapsable div to wrap the code in
    var div = $('<div class="collapse r-code-collapse"></div>');
    if (show)
      div.addClass('in');
    var id = 'rcode-643E0F36' + r_currentIndex++;
    div.attr('id', id);
    $(this).before(div);
    $(this).detach().appendTo(div);
    $(this).css('background-color','#e6faff'); // change color of chunk background

    // add a show code button right above
    var showCodeText = $('<span>' + (show ? 'Hide R code' : 'R code') + '</span>');
    var showCodeButton = $('<button type="button" class="btn btn-default btn-xs code-folding-btn pull-right"></button>');
    showCodeButton.append(showCodeText);
    showCodeButton
        .attr('data-toggle', 'collapse')
        .attr('data-target', '#' + id)
        .attr('aria-expanded', show)
        .attr('aria-controls', id);
    
    // change the background color of the button        
    showCodeButton.css('background-color','#0000ff');
    
    var buttonRow = $('<div class="row"></div>');
    var buttonCol = $('<div class="col-md-12"></div>');
    buttonCol.append(showCodeButton);
    buttonRow.append(buttonCol);
    div.before(buttonRow);

    // update state of button on show/hide
    div.on('hidden.bs.collapse', function () {
      showCodeText.text('R code');
    });
    div.on('show.bs.collapse', function () {
      showCodeText.text('Hide R code');
    });
  });

}

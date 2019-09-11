// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery
//= require_tree .

$(document).ready(function() {
  $(".openSelectedLinks").on("click", function(){
    var links = $( this ).siblings();
    var checked_links = links.children().filter("input:checked").parent();
    var adresses = checked_links.children("a");
    adresses.each(function() {
      window.open("/lazy_loading.html#" + this.href,'_blank');
    });
    return false;
  });
});


var listItem = document.getElementById( "li" );

function boldLink(index) {
  $("li").eq( index ).css( "font-weight", "bold");
};

function unBoldLink(index) {
  $("li").eq( index ).css( "font-weight", "lighter");
};

$(document).ready(function() {
  boldLink(listItem)
});

document.addEventListener('keydown', function(event) {
  if (event.code == 'ArrowDown') {
    unBoldLink(listItem)
    listItem += 1;
    boldLink(listItem)
  }
});

document.addEventListener('keyup', function(event) {
  if (event.code == 'ArrowUp') {
    unBoldLink(listItem)
    listItem -= 1;
    boldLink(listItem)
  }
});

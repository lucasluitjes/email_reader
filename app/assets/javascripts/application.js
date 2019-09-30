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
    var email_id = $(this).parent().parent().children().children().eq(2).attr("href");
    console.log(email_id);
    $.ajax({
      type: "PATCH",
      url: email_id,
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]'). attr('content'))},
      dataType: "json",
      data:  {email: { read: true}},
      success: function(data, textStatus, xhr) {
      }
    });
    var read_status = $(this).parent().parent().children().children().eq(1);
    read_status.text("- Read -")
    return false;
  });
});

var listItem = document.getElementById( "li" );

$(document).ready(function() {
  boldLink(listItem)
});

function boldLink(index) {
  $("li").eq( index ).css( "font-weight", "bold");
};

function unBoldLink(index) {
  $("li").eq( index ).css( "font-weight", "lighter");
};

function toggleCheckBox(index) {
  $("li").eq( index ).children(0).prop('checked', function (i, value) {
    return !value;
  });
};

$(document).keydown(function(e){
  var code = e.keyCode;
  if (code == 37 || code == 38 || code == 40) {
    e.preventDefault();
    return false;
  }
  else {
    return true;
  } 
});

document.addEventListener('keydown', function(event) {
  if (event.code == 'ArrowDown') {
    unBoldLink(listItem)
    listItem += 1;
    boldLink(listItem)
  }
});

document.addEventListener('keydown', function(event) {
  if (event.code == 'ArrowUp') {
    unBoldLink(listItem)
    listItem -= 1;
    boldLink(listItem)
  }
});

document.addEventListener('keydown', function(event) {
  if (event.code == 'ArrowLeft') {
    toggleCheckBox(listItem);
  }
});

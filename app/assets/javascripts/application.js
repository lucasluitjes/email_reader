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
    var checked_links = links.children().filter(":checked").parent();
    var addresses = checked_links.children("a");
    addresses.each(function(i, el) {
      window.open("/lazy_loading.html#" + el.href,'_blank');
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

var listItem = 0;

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

function openLinksButton(index) {
   $("a.openSelectedLinks").eq( index ).css( "color", "red"); // show what you've read already
   $("a.openSelectedLinks").eq( index ).click();
 };

$(document).keydown(function(e){
  var code = e.keyCode;
  if (code == 13 || code == 37 || code == 38  || code == 39 || code == 40) {
    e.preventDefault();
    return false;
  }
  else {
    return true;
  } 
});

document.addEventListener('keydown', function(event) {
  if (event.key == 'Enter') {
    li = $(document).find( 'li' ).eq(listItem)
    // console.log(li)
    button = $(li).closest( 'ul' ).find( '.openSelectedLinks' )
    // console.log(button)
    buttonIndex = $( "a.openSelectedLinks" ).index( button )
    // console.log(buttonIndex)
    openLinksButton(buttonIndex)
  }
});

document.addEventListener('keydown', function(event) {
  if (event.code == 'Space') {
    unBoldLink(listItem)
    listItem += 1;
    boldLink(listItem)
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
  if (event.code == 'ArrowLeft' || event.code == 'ArrowRight') {
    toggleCheckBox(listItem);
  }
});

document.addEventListener('keyup', function(event) {
  if (event.key == 'PageDown' || event.key == 'PageUp') {
    unBoldLink(listItem)
    setTimeout(function(){
      if (window.navigator.userAgent =~ /Firefox/) {
        // console.log(window.navigator.userAgent)
        var doc = document;
        start = doc.caretPositionFromPoint(0, 0);
        end = doc.caretPositionFromPoint(100, 100);
        range = doc.createRange();
        range.setStart(start.offsetNode, start.offset);
        range.setEnd(end.offsetNode, end.offset);
      } else {
        range = document.caretRangeFromPoint(0,0);
      }
      // console.log(range)
      element = range.startContainer;
      // console.log(element)
      // if (element.className !== 'link') {
      //   console.log('got the wrong element')
      //   console.log($(element).children('.link'))
      //   console.log($(element).find('.link'))
      // }
      link = $(element).closest('.link')
      // console.log(link)
      listItem = $( ".link" ).index( link ) + 1
      boldLink(listItem)
    }, 400);
  }
});

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

$(document).ready(() => {
  $(".openSelectedLinks").on("click", function(){
    var links = $( this ).siblings();
    var checked_links = links.children().filter(":checked").parent();
    var addresses = checked_links.children("a");
    addresses.each((i, el) => {
      window.open("/lazy_loading.html#" + el.href,'_blank');
    });
    var email_id = $(this).parent().parent().children().children().eq(2).attr("href");
    console.log(email_id);
    $.ajax({
      type: "PATCH",
      url: email_id,
      beforeSend: (xhr) => {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]'). attr('content'))},
      dataType: "json",
      data:  {email: { read: true}},
      success: (data, textStatus, xhr) => {}
    });
    var read_status = $(this).parent().parent().children().children().eq(1);
    read_status.text("- Read -")
    return false;
  });
});

let listItem = 0;

$(document).ready( () => boldLink(listItem) );

const boldLink = (index) => $("li").eq( index ).css( "font-weight", "bold")

const unBoldLink = (index) => $("li").eq( index ).css( "font-weight", "lighter")

const toggleCheckBox = (index) => {
  $("li").eq( index ).children(0).prop('checked', (i, value) => {
    return !value;
  });
};

const openLinksButton = (index) => {
  $("a.openSelectedLinks").eq( index ).css( "color", "red"); // show which newsletter you've clicked already
  $("a.openSelectedLinks").eq( index ).click();
};

$(document).keydown((e) => {
  const keys = ['Enter', 'ArrowLeft', 'ArrowUp', 'ArrowRight', 'ArrowDown']
  if (keys.includes(e.key)) {
    e.preventDefault();
    return false;
  }
  else {
    return true;
  }
});

document.addEventListener('keydown', (event) => {
  if (event.key == 'Enter') {
    li = $(document).find( 'li' ).eq(listItem)
    // console.log(li)
    button = $(li).closest( 'ul' ).find( '.openSelectedLinks' )
    // console.log(button)
    buttonIndex = $( "a.openSelectedLinks" ).index( button )
    // console.log(buttonIndex)
    openLinksButton(buttonIndex)
  }
  if (event.code == 'ArrowDown') {
    unBoldLink(listItem)
    listItem += 1;
    boldLink(listItem)
  }
  if (event.code == 'ArrowUp') {
    unBoldLink(listItem)
    listItem -= 1;
    boldLink(listItem)
  }
  if (event.code == 'ArrowLeft' || event.code == 'ArrowRight') {
    toggleCheckBox(listItem);
  }
});

const timeOut = 400
document.addEventListener('keyup', (event) => {
  const spacebar = ' '
  const keys = ["PageDown", "PageUp", spacebar]
  if (keys.includes(event.key)) {
    unBoldLink(listItem)
    setTimeout(() => {
      browser = window.navigator.userAgent
      // console.log(browser)
      if (browser.indexOf("Firefox") > -1) {
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
    }, timeOut);
  }
});

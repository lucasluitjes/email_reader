document.title = '[' + window.location.hash.substr(1).replace('http://', '').replace('https://', '') + ']';

// load site on focus
document.addEventListener('visibilitychange', function(){
    window.location = window.location.hash.substr(1);
})
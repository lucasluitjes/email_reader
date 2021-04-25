document.title = '[' + window.location.hash.substr(1).replace('http://', '').replace('https://', '') + ']';

// load site after random delay to avoid rate limiting errors
setTimeout(function(){ 
    window.location = window.location.hash.substr(1);
}, Math.floor(Math.random() * 30000));

// load site on focus
// document.addEventListener('visibilitychange', function(){
//     window.location = window.location.hash.substr(1);
// })

(function(){
    var import = function(lib, callback, check){
        if(check && window.hasOwnProperty(check)){
            callback();
        } else {
            var url = '//fouber.github.com/noop/lib/' + lib + '.min.js';
            var script = document.createElement('script');
            script.onload = callback;
            script.src = url;
            document.head.appendChild();
        }
    };
    var path = location.pathname;
    var id = path.match(/^\/(v|star)\/(\w+)/)[2];
    if(id){
        
    } else {
        alert('请在直播间使用');
    }
})();

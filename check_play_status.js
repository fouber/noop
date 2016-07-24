(function(){
    var require = function(lib, callback, check){
        if(check && window.hasOwnProperty(check)){
            callback(window[check]);
        } else {
            var url = '//fouber.github.com/noop/lib/' + lib + '.min.js';
            var script = document.createElement('script');
            script.onload = check ? function(){
                callback(window[check]);
            } : callback;
            script.src = url;
            document.head.appendChild(script);
        }
    };
    var path = location.pathname;
    var id = path.match(/^\/(v|star)\/(\w+)/)[2];
    if(id){
        require('zepto', function($){
            var fetch = function(callback){
                var url = '/json/rooms/' + id + '/info4.json?t=' + Date.now();
                $.get(url, function(data){
                    console.log(data);
                });
            };
            fetch();
        }, 'Zepto');
    } else {
        alert('请在直播间使用');
    }
})();

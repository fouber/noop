(function(){
    var HOST_NAME = 'console.bce.baidu.com'
    if(location.hostname != HOST_NAME){
        var url = prompt('请在以下页面使用此工具：', 'https://' + HOST_NAME);
        if(url && url.indexOf(HOST_NAME) > -1){
            location.href = url;
        }
        return;
    }
    if(window.jQuery) {
        start();
    } else {
        var script = document.createElement('script');
        script.src = 'https://fouber.github.io/noop/lib/jquery.min.js';
        document.head.appendChild(script);
        script.onload = start;
    }
    function start(){
        do {
            var roomId = prompt('请输入房间id：', 156);
            if(roomId == null) return;
        } while(isNaN(roomId));
        $.ajax({
            url: '/api/lss/v2/session/list?locale=zh-cn&_=' + Date.now(),
            method: 'POST',
            processData: false,
            data: {
                "keywordType": "description",
                "keyword": "rtmp://live.quanmin.tv/live/" + roomId,
                "order": "desc",
                "pageNo": 1,
                "pageSize": 20,
                "status":"ALL",
                "orderBy":"id"
            },
            dataType: 'JSON',
            success: function(data) {
                console.log(data);
            }
        });
    }
})();

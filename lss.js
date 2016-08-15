(function(){
    var HOST_NAME = 'console.bce.baidu.com'
    if(location.hostname != HOST_NAME){
        var url = prompt('请在以下页面使用此工具：', 'https://' + HOST_NAME);
        if(url && url.indexOf(HOST_NAME) > -1){
            location.href = url;
        }
        return;
    }
})();

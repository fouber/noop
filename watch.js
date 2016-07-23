(function(){

    var TODAY = 0;
    var YESTERDAY = 1;
    var TODAY_STR = '今天';
    var YESTERDAY_STR = '昨天';

    function fetch(url, id, type, callback, yesterday){
        $.post(url, {
            mc_gtk:1986648287,
            is_iniframe:0,
            instanceId: id,
            regionId:4,
            dateCmd: Number(yesterday === YESTERDAY),
            metricNames: type
        }, callback);
    }
    function createDom(){
        var div = document.createElement('div');
        div.style.width = '500px';
        div.style.height = '300px';
        div.style.border = '1px solid #eee';
        div.style.margin = '5px';
        div.style.display = 'inline-block';
        return div;
    }

    function pad(val){
        return ('0' + val).slice(-2);
    }

    function genOpt(name, yesterday){
        return {
            title: {
                text: name
            },
            legend: {
                data:[ TODAY_STR, YESTERDAY_STR ]
            },
            tooltip: {
                trigger: 'axis',
                formatter: function (params) {
                    today = params[0];
                    yesterday = params[1];
                    return [
                        'Time：' + today.name,
                        today.seriesName  + ' : '+ today.value,
                        yesterday.seriesName  + ' : '+ yesterday.value
                    ].join('</br>');
                },
                axisPointer: {
                    animation: false
                }
            },
            xAxis: {
                type : 'category',
                boundaryGap : false,
                data: (function(){
                    var d = [];
                    for(var i = 0; i < 24 * 60; i += 5){
                        var m = i % 60;
                        var h = (i - m) / 60;
                        d.push(pad(h) + ':' + pad(m));
                    }
                    return d;
                })()
            },
            yAxis: {
                type: 'value'
            },
            series: []
        };
    }

    function processData(name, value, index, yesterday){
        var d = new Date();
        if(yesterday){
            d.setTime(d.getTime() - 1000 * 3600 * 24);
        }
        d.setHours(0);
        d.setMinutes(0);
        d.setSeconds(0);
        d.setTime(d.getTime() + index * 5 * 60 * 1000);
        return {
            name: pad(d.getHours()) + ':' + pad(d.getMinutes()),
            value: value
        }
    }

    function createChart(name, id, type){
        var div = createDom();
        type = type || 'in_flow';
        document.body.appendChild(div);
        var myChart = echarts.init(div);
        var opt = genOpt(name, TODAY);
        myChart.setOption(opt);
        fetch('https://redis.qcloud.com/monitor/index/', id, type, function(data){
            data = data.data.points[type];
            var today = [];
            data.forEach(function(value, index){
                today.push(processData(name, value, index));
            });
            fetch('https://redis.qcloud.com/monitor/index/', id, type, function(data){
                data = data.data.points[type];
                var yesterday = [];
                data.forEach(function(value, index){
                    yesterday.push(processData(name, value, index));
                });
                myChart.setOption({
                    series: [
                        { name: TODAY_STR, type: 'line', data: today },
                        { name: YESTERDAY_STR, type: 'line', data: yesterday }
                    ]
                });
            }, YESTERDAY);
        }, TODAY);
        setTimeout(function () {
            createChart(name, id, type)
        }, 5 * 60 * 1000);
    }
    function start(){
        document.body.innerHTML = '';
        var ids = {
            'cache2(x)': '05515d38-1684-4c73-96d4-878ecd6c6915',
            cache3: 'f6cf0e4a-91fb-4291-b94a-c5f162b7dbc1',
            cache4: 'a0d2dc5a-469b-4609-80bd-07320cf4f0bf',
            cache5: 'dc5189fa-96f5-4bbe-bd21-1fe6adb8b49c',
            cache6: 'edeb1a05-3388-4508-a385-dd2496f262fb',
            cacheRoute: 'crs-qad2l3w0'
        };
        var types = {
            'in_flow': '入网流量',
            'out_flow': '出网流量',
            'stat_get': 'Get数',
            'stat_set': 'Set数',
            'keys': 'Key总数',
            // 'storage': '已使用容量',
            // 'storage_us': '容量使用率',
            // 'cpu_us': 'CPU负载',
            // 'qps': 'QPS',
            // 'cache_hit_ratio': '缓存命中率',

        };
        for(var name in ids){
            for(var type in types){
                createChart(name + ' ' + types[type], ids[name], type);
            }
        }
    }
    if(window.echarts) {
        start();
    } else {
        var script = document.createElement('script');
        script.src = 'https://fouber.github.io/noop/echarts.min.js';
        document.head.appendChild(script);
        script.onload = start;
    }
})();

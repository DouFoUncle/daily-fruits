<%--
  Created by IntelliJ IDEA.
  User: byqs
  Date: 2020/7/16
  Time: 14:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>报表</title>
    <link rel="stylesheet" href="../css/font.css">
    <link rel="stylesheet" href="../css/xadmin.css">
    <script src="../lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/xadmin.js"></script>
    <script type="text/javascript" src="../js/MyLayuiUtils.js"></script>
    <style>
        .layui-form-item {
            margin-bottom: 0;
        }

        .layui-form-pane .layui-form-label {
            max-width: 100px;
        }

        .layui-form-item .layui-input-inline {
            width: 180px;
        }

        .layui-form-pane .layui-form-label {
            padding: 9px 15px;
        }

        .layui-form-select dl {
            max-height: 225px;
        }
        .layui-table-cell .layui-form-checkbox[lay-skin="primary"] {
            top: 5px;
        }
    </style>
</head>

<body>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-body " style="padding-bottom: 0;">
                    <form class="layui-form layui-col-space5 layui-form-pane" id="form">

                        <div class="layui-inline layui-show-xs-block layui-form-item">
                            <label class="layui-form-label">开始时间</label>
                            <div class="layui-input-inline">
                                <input type="text" id="start" class="layui-input" name="start" placeholder="请选择开始查询的时间">
                            </div>
                        </div>

                        <div class="layui-inline layui-show-xs-block layui-form-item">
                            <label class="layui-form-label">结束时间</label>
                            <div class="layui-input-inline">
                                <input type="text" id="end" class="layui-input" name="end" placeholder="请选择结束查询的时间">
                            </div>
                        </div>

                        <div class="layui-inline layui-show-xs-block">
                            <button class="layui-btn layui-btn-normal" id="searchBtn" type="button" lay-filter="sreach">
                                <i class="layui-icon">&#xe615;</i>
                            </button>
                            <button class="layui-btn layui-btn-normal" type="reset">
                                <i class="layui-icon">&#xe669;</i>
                            </button>
                            <button class="layui-btn layui-btn-normal" type="button" id="day7">
                                查询最近7天
                            </button>
                            <button class="layui-btn layui-btn-normal" type="button" id="day30">
                                查询最近30天
                            </button>
                        </div>
                    </form>
                </div>
                <div class="layui-card-body" style="padding-top: 30px;box-sizing: border-box">
                    <div id="totalData"
                         style="width: 32%; height: 400px; margin-top: 20px; display: inline-block; overflow: hidden; vertical-align: top"></div>

                    <div id="eventDayData" style="width: 67%; height: 85%; display: inline-block; overflow-x: hidden"></div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>

<script type="text/javascript" src="../js/echarts.min.js"></script>
<script>
    layui.use(['table', 'form', 'laydate'],
        function () {
            var table = layui.table,
                layer = layui.layer,
                form = layui.form,
                laydate = layui.laydate,
                $$ = layui.jquery,
                arrValue = [],
                findDay = "",
                findStart = "",
                findEnd = "",
                expend = "",
                income = "",
                netIncome = "",
                startTime = $$("input[name='startTime']").val(),
                endTime = $$("input[name='endTime']").val();

            //开启公历节日
            laydate.render({
                elem: '#start'
                ,calendar: true
            });

            //开启公历节日
            laydate.render({
                elem: '#end'
                ,calendar: true
            });

            getData("getInfoByDay?day=7", true);

            /**
             * 获取数据创建图表
             * @param url   请求路径
             * @param isDay 是否是根据天数查询
             */
            function getData(url, isDay) {
                let load = layer.load(1, {shade: 0.3})
                $.getJSON(
                    url,
                    function(res) {
                        if(res.code == 0) {
                            showData = res.data;
                            arrValue = [];
                            findDay = "";
                            findStart = "";
                            findEnd = "";
                            let titleArr = ["日期", "总收入", "总支出", "净收入"]
                            arrValue.push(titleArr);
                            for (let item in res.data.everyDayMap) {
                                let arrTemp = [];
                                arrTemp.push(res.data.everyDayMap[item].date);
                                arrTemp.push(res.data.everyDayMap[item].income / 100);
                                arrTemp.push(res.data.everyDayMap[item].expend / 100);
                                arrTemp.push(res.data.everyDayMap[item].netIncome / 100);
                                arrValue.push(arrTemp);
                            }
                            income = res.data.totalIncome / 100;
                            expend = res.data.totalExpend / 100;
                            netIncome = res.data.netIncome / 100;
                            if(isDay) {
                                findDay = res.data.day;
                            } else {
                                findStart = res.data.findStart;
                                findEnd = res.data.findEnd;
                            }
                            console.log(arrValue.length)
                            createEventForm();
                            createTotalDayForm();
                            layer.close(load);
                        } else {
                            errorAlert(res.msg, .3, false)
                            layer.close(load);
                        }
                    }
                )
            }

            /**
             * 绑定查询按钮
             */
            $$("#searchBtn").click(function () {
                // 获取表单数据
                var sendData = $$("#form").serialize();
                // 重新调用表格加载方法
                getData("getInfoByDate?" + sendData, false)
            })

            /**
             * 绑定查询按钮
             */
            $$("#day7").click(function () {
                let load = layer.load(1, {shade: .3});
                setTimeout(function() {
                    getData("getInfoByDay?day=7", true);
                }, 500)
            })

            /**
             * 绑定查询按钮
             */
            $$("#day30").click(function () {
                let load = layer.load(1, {shade: .3});
                setTimeout(function() {
                    getData("getInfoByDay?day=30", true);
                }, 500)
            })


            // 初始化柱状图
            function createEventForm() {
                var myChart = echarts.init(document.getElementById('eventDayData'));

                var option = {
                    legend: {},
                    tooltip: {},
                    dataset: {
                        source: arrValue
                    },
                    xAxis: {type: 'category'},
                    yAxis: {},
                    series: [
                        {
                            type: 'bar'
                            , name: '总收入'
                            , itemStyle: {
                                normal: {
                                    label: {
                                        show: true //开启显示
                                        , position: 'top'
                                    }
                                }
                            }
                        },
                        {
                            type: 'bar'
                            , name: '总支出'
                            , itemStyle: {
                                normal: {
                                    label: {
                                        show: true //开启显示
                                        , position: 'top'
                                    }
                                }
                            }
                        },
                        {
                            type: 'bar'
                            , name: '净收入'
                            , itemStyle: {
                                normal: {
                                    label: {
                                        show: true //开启显示
                                        , position: 'top'
                                    }
                                }
                            }
                        }
                    ]
                };
                // 设置图表最大显示7天数据, 超过7天则显示滚动条
                if(arrValue.length > 8) {
                    option.dataZoom = [
                        {
                            show: true,
                            realtime: true,
                            startValue: 0,
                            endValue: 6
                        },
                        {
                            type: 'inside',
                            realtime: true,
                            startValue: 0,
                            endValue: 6
                        }
                    ]
                }

                // 使用刚指定的配置项和数据显示图表。
                myChart.setOption(option);
            }

            // 初始化饼图
            function createTotalDayForm() {
                var myChart = echarts.init(document.getElementById('totalData'));
                var option = {
                    title: {
                        text: !findDay ? '已选日期的数据统计' : '最近' + findDay + '天数据统计',
                        subtext: '\n净收入: ' + netIncome + '元',
                        left: 'center',
                        textStyle: {
                            fontSize: 20
                        },
                        subtextStyle: {
                            fontSize: 14,
                            paddingTop: 10
                        }
                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: '{a} <br/>{b} : {c} ({d}%)'
                    },
                    series: [
                        {
                            name: '销售类型',
                            type: 'pie',
                            radius: '55%',
                            center: ['50%', '60%'],
                            data: [
                                {
                                    value: income,
                                    name: '总收入: ' + income + '元'
                                },
                                {
                                    value: expend,
                                    name: '总支出: ' + expend + '元'
                                }
                            ],
                            emphasis: {
                                itemStyle: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            }
                        }
                    ]
                };
                // 使用刚指定的配置项和数据显示图表。
                myChart.setOption(option);
            }
        });
</script>
</html>

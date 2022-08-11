<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>新增</title>
    <link rel="stylesheet" href="../css/font.css">
    <link rel="stylesheet" href="../css/xadmin.css">
    <script src="../lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/xadmin.js"></script>
    <script type="text/javascript" src="../js/MyLayuiUtils.js"></script>
    <style>
        html {
            height: 100%;
        }

        .layui-form-pane .layui-form-text .layui-textarea {
            min-height: 80px;
            max-height: 80px;
        }

        .div_show {
            transform: translate(-2000px);
            transition: all 0.8s;
        }

        .div_hide {
            transform: translate(2000px);
            transition: all 1.5s;
        }

        .photo-viewer {
            margin: 50px 0;
            text-align: center;
        }

        .img-reveal {
            display: inline-block;
            margin: 0px 8px;
        }

        .layui-btn {
            height: 34px;
            line-height: 34px;
        }
        .layui-form-select dl {
            max-height: 195px;
        }
    </style>
</head>
<body style="height: 100%;box-sizing: border-box">
<!-- 保存本次上传的类型 -->
<div class="layui-upload" style="padding: 15px;">
    <button type="button" class="layui-btn layui-btn-normal" id="selectImgBtn">选择要上传的图片</button>
    <div class="layui-upload-list">
        <table class="layui-table">
            <thead>
            <tr><th>文件名</th>
                <th>大小</th>
                <th>状态</th>
                <th>操作</th>
            </tr></thead>
            <tbody id="showFileTable"></tbody>
        </table>
    </div>
    <button type="button" class="layui-btn" id="startUpload">开始上传</button>
</div>
<script>
    layui.use(['form', 'upload', 'table'], function () {

        var upload = layui.upload;

        //多文件列表示例
        var showFileTable = $('#showFileTable');

        // 文件集合
        var files;

        var uploadListIns = upload.render({
            elem: '#selectImgBtn'
            , acceptMime: 'image/*'       //上传所有类型的图片
            , accept: 'image/*'
            , multiple: true
            , size: 10240
            , auto: false
            //, bindAction: '#startUpload' //绑定开始上传按钮
            ,choose: function(obj){
                //将每次选择的文件追加到文件集合中
                files = this.files = obj.pushFile();
                //读取本地文件
                obj.preview(function(index, file, result){
                    var tr = $(['<tr id="upload-'+ index +'">'
                        ,'<td>'+ file.name +'</td>'
                        ,'<td>'+ (file.size/1024).toFixed(1) +'kb</td>'
                        ,'<td>等待上传</td>'
                        ,'<td>'
                        ,'<button class="layui-btn layui-btn-xs demo-reload layui-hide">重传</button>'
                        ,'<button class="layui-btn layui-btn-xs layui-btn-danger demo-delete">删除</button>'
                        ,'</td>'
                        ,'</tr>'].join(''));

                    //单个重传
                    tr.find('.demo-reload').on('click', function(){
                        obj.upload(index, file);
                    });

                    //删除
                    tr.find('.demo-delete').on('click', function(){
                        delete files[index]; //删除对应的文件
                        tr.remove();
                        uploadListIns.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
                    });

                    showFileTable.append(tr);
                });
            }
        });

        /**
         * 点击响应上传按钮
         */
        $("#startUpload").on("click", function () {
            var form = new FormData();
            for (let i in files) {
                form.append("files", files[i]);
            }
            var index = layer.load(0, {shade: false}); //0代表加载的风格，支持0-2
            $.ajax({
                url: "uploadImages",
                type: "post",
                dataType: "json",
                async: false,
                contentType: false,
                processData: false,
                data: form,
                success: function (result) {
                    if (result.code == 0) {
                        layer.msg("上传成功！", {icon: 6});
                        var tr = $("#showFileTable tr[id^='upload-']");
                        $.each(tr, function(index, item) {
                            var tds = $(item).children();
                            tds.eq(2).html('<span style="color: #5FB878;">上传成功</span>');
                            tds.eq(3).html(''); //清空操作
                        })
                    } else {
                        layer.msg(result.msg, {icon: 5});
                    }
                    layer.closeAll("loading");
                }
            })
        });

    });
</script>
</body>
</html>
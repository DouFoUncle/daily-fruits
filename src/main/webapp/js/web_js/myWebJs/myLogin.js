layui.use(['layer'], function () {

    let layer = layui.layer;

    $(function () {
        let type = $("input[name='type']").val();
        let container = document.getElementById('dowebok')
        let sendTimer = 60;
        let timer;
        let isClick = false;

        init();

        function init() {
            if (type == 'register') {
                container.classList.add('right-panel-active')
                $("#addForm").show();
                $("#editForm").hide();
            } else if (type == 'editPassword') {
                container.classList.add('right-panel-active')
                $("#editForm").show();
                $("#addForm").hide();
            }
        }

        // 监听登陆按钮点击事件
        $("#loginBtn").click(function() {
            // 非空验证
            let loginUserEmail = $("input[name='loginUserEmail']").val();
            let loginUserPassword = $("input[name='loginPassword']").val();
            if(!loginUserEmail || !loginUserPassword) {
                layer.msg("请填写完整登录信息！", {timer: 1000});
                return;
            }
            // 调用登陆验证接口
            // 整理数据
            let jsonObj = {
                password: loginUserPassword,
                userEmail: loginUserEmail
            }
            // 发送请求
            $.ajax({
                url: '../../webUser/userLogin',
                type: "POST",
                async: false,
                contentType: 'application/json;charset=utf-8', //设置请求头信息
                data: JSON.stringify(jsonObj),
                success: function (res) {
                    if (res.code == "0") {
                        layer.msg(res.msg, {
                            timer: 1000,
                            end: function () {
                                window.location.href = getPath();
                            }
                        })
                    } else {
                        layer.msg(res.msg, {
                            timer: 1000
                        })
                    }
                },
                error: function (res) {
                    layer.confirm('啊哦！访问出问题了！快找开发狗算账！', {
                        btn: ['确定']  //按钮
                        , icon: 5
                        , anim: 6
                    }, function (index) {
                        lock = true;
                        layer.close(index);
                    });
                }
            })
        })

        // 监听发送验证码点击事件
        $("#editSendCode").click(function () {
            if (!isClick) {
                isClick = true;
                let userEmail = $("input[name='editUserEmail']").val();
                // 验证邮箱的正则
                var reg = /^([a-zA-Z]|[0-9])(\w|\-)+@[a-zA-Z0-9]+\.([a-zA-Z]{2,4})$/;
                if (!userEmail) {
                    layer.msg("邮箱还未填写哦！", {timer: 1000});
                    isClick = false;
                    return;
                } else if (!reg.test(userEmail)) {
                    layer.msg("邮箱格式不正确哦！", {timer: 1000});
                    isClick = false;
                    return;
                }
                // 设置倒计时
                let elementBtn = $(this);
                elementBtn.attr("disabled");
                elementBtn.text("重新发送(" + sendTimer + ")");
                timer = setInterval(function () {
                    if (sendTimer <= 0) {
                        clearInterval(timer);
                        elementBtn.removeAttr("disabled");
                        elementBtn.text("发送验证码");
                        sendTimer = 60;
                        isClick = false;
                        return;
                    }
                    sendTimer -= 1;
                    elementBtn.text("重新发送(" + sendTimer + ")");
                }, 1000)
                layer.msg('邮件正在发送大约需要20秒！请注意查收！', {
                    timer: 1000,
                    end: function() {
                        // 发送邮件
                        $.getJSON(
                            '../../email/sendVerifyCode?type=editPassword&userEmail=' + userEmail
                            , function (res) {
                                console.log(res)
                                if(res.code != 0) {
                                    layer.msg(res.msg, {
                                        timer: 1000
                                    })
                                }
                            }
                        )
                    }
                });
            }
        })

        // 注册时发送验证码
        $("#registerSendCode").click(function () {
            if (!isClick) {
                isClick = true;
                let userEmail = $("input[name='addUserEmail']").val();
                // 验证邮箱的正则
                var reg = /^([a-zA-Z]|[0-9])(\w|\-)+@[a-zA-Z0-9]+\.([a-zA-Z]{2,4})$/;
                if (!userEmail) {
                    layer.msg("邮箱还未填写哦！", {timer: 1000});
                    isClick = false;
                    return;
                } else if (!reg.test(userEmail)) {
                    layer.msg("邮箱格式不正确哦！", {timer: 1000});
                    isClick = false;
                    return;
                }
                // 设置倒计时
                let elementBtn = $(this);
                elementBtn.attr("disabled");
                elementBtn.text("重新发送(" + sendTimer + ")");
                timer = setInterval(function () {
                    if (sendTimer <= 0) {
                        clearInterval(timer);
                        elementBtn.removeAttr("disabled");
                        elementBtn.text("发送验证码");
                        sendTimer = 60;
                        isClick = false;
                        return;
                    }
                    sendTimer -= 1;
                    elementBtn.text("重新发送(" + sendTimer + ")");
                }, 1000)
                layer.msg('邮件正在发送大约需要20秒！请注意查收！', {
                    timer: 1000,
                    end: function() {
                        // 发送邮件
                        $.getJSON(
                            '../../email/sendVerifyCode?type=register&userEmail=' + userEmail
                            , function (res) {
                                console.log(res)
                                if(res.code != 0) {
                                    layer.msg(res.msg, {
                                        timer: 1000
                                    })
                                }
                            }
                        )
                    }
                });
            }
        })

        // 监听提交修改按钮点击事件
        $("#editPassBtn").click(function () {
            // 提交时进行非空验证
            var editPassword = $("input[name='editPassword']").val();
            var editUserEmail = $("input[name='editUserEmail']").val();
            var verifyCode = $("input[name='editVerifyCode']").val();
            if (!editPassword || !editUserEmail || !verifyCode) {
                layer.msg('请填写完整信息！', {timer: 1000});
                return;
            }// 整理数据
            let jsonObj = {
                password: editPassword,
                userEmail: editUserEmail,
                verifyCode: verifyCode
            }
            // 发送请求
            $.ajax({
                url: '../../webUser/updatePassword',
                type: "PUT",
                async: false,
                contentType: 'application/json;charset=utf-8', //设置请求头信息
                data: JSON.stringify(jsonObj),
                success: function (res) {
                    console.log(res);
                    if (res.code == "0") {
                        layer.msg(res.msg, {
                            timer: 1000,
                            end: function () {
                                resetForm();
                                $("input[name='type']").val("login");
                                container.classList.remove('right-panel-active')
                            }
                        })
                    } else {
                        layer.msg(res.msg, {
                            timer: 1000
                        })
                    }
                },
                error: function (res) {
                    layer.confirm('啊哦！访问出问题了！快找开发狗算账！', {
                        btn: ['确定']  //按钮
                        , icon: 5
                        , anim: 6
                    }, function (index) {
                        lock = true;
                        layer.close(index);
                    });
                }
            })
        })

        // 监听注册按钮点击事件
        $("#registerBtn").click(function () {
            // 提交时进行非空验证
            var addNickName = $("input[name='addNickName']").val();
            var addPassword = $("input[name='addPassword']").val();
            var addUserEmail = $("input[name='addUserEmail']").val();
            var verifyCode = $("input[name='addVerifyCode']").val();
            if (!addPassword || !verifyCode || !addNickName || !addUserEmail) {
                layer.msg('请填写完整信息！', {timer: 1000});
                return;
            }
            // 整理数据
            let jsonObj = {
                nickName: addNickName,
                password: addPassword,
                userEmail: addUserEmail,
                verifyCode: verifyCode
            }
            // 发送请求
            $.ajax({
                url: '../../webUser/insertInfo',
                type: "POST",
                async: false,
                contentType: 'application/json;charset=utf-8', //设置请求头信息
                data: JSON.stringify(jsonObj),
                success: function (res) {
                    if (res.code == "0") {
                        layer.msg(res.msg, {
                            timer: 1000,
                            end: function () {
                                resetForm();
                                $("input[name='type']").val("login");
                                container.classList.remove('right-panel-active')
                            }
                        })
                    } else {
                        layer.msg(res.msg, {
                            timer: 1000
                        })
                    }
                },
                error: function (res) {
                    layer.confirm('啊哦！访问出问题了！快找开发狗算账！', {
                        btn: ['确定']  //按钮
                        , icon: 5
                        , anim: 6
                    }, function (index) {
                        lock = true;
                        layer.close(index);
                    });
                }
            })
        })
    })
})
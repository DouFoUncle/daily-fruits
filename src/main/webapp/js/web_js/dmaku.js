/****************************************************************
 *																*		
 * 						      							*
 *                        							*
 *       		  努力创建完善、持续更新插件以及模板			*
 * 																*
****************************************************************/
var signUpButton = document.getElementById('signUp')
var signInButton = document.getElementById('signIn')
var editPassword = document.getElementById('editPassword')
var container = document.getElementById('dowebok')

editPassword.addEventListener('click', function () {
    container.classList.add('right-panel-active')
    $("#addForm").hide();
    $("#editForm").show();
    resetForm();
    $("input[name='type']").val("editPassword");
})

signUpButton.addEventListener('click', function () {
    container.classList.add('right-panel-active')
    $("#addForm").show();
    $("#editForm").hide();
    resetForm();
    $("input[name='type']").val("register");
})

signInButton.addEventListener('click', function () {
    container.classList.remove('right-panel-active')
    resetForm();
    $("input[name='type']").val("login");
});

function resetForm() {
    // 清空表单数据
    $(':input','#loginForm')
        .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
    $(':input','#addForm')
        .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
    $(':input','#editForm')
        .not(':button, :submit, :reset, :hidden')
        .val('')
        .removeAttr('checked')
        .removeAttr('selected');
}

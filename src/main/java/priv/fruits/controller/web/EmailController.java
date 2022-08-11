package priv.fruits.controller.web;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.extra.mail.MailAccount;
import cn.hutool.extra.mail.MailUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.pojo.User;
import priv.fruits.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * @Author 冶生华
 * @Description 果蔬超市
 */
@Controller
@RequestMapping("email")
public class EmailController {

    // 创建配置好的邮箱对象
    @Autowired
    private MailAccount mailAccount;

    @Autowired
    private UserService userService;

    /**
     * 发送邮箱验证码
     * @param userEmail 邮件接收人
     * @return
     */
    @GetMapping("sendVerifyCode")
    @ResponseBody
    public ResultMessage sendVerifyCode(String userEmail, String type, HttpServletRequest request) {
        try {
            // 查询该邮箱是否已注册
            User user = userService.getUserInfoByEmail(userEmail);
            if("register".equals(type) && user != null && user.getId() != null) {
                return new ResultMessage(207, "该邮箱已被注册！");
            }
            // 生成验证码(随机10000 - 99999的数字)
            String code = RandomUtil.randomInt(10000, 99999)+"";
            // 将生成的验证码保存到session中, 用于后期验证
            HttpSession session = request.getSession();
            // 保存前将之前保存过的记录删除一遍, 防止之前有记录
            session.removeAttribute("webEditPassVerifyCode");
            session.removeAttribute("webRegisterVerifyCode");
            // 判断是注册还是修改密码, 保存不同的名字
            if("register".equals(type)) {
                session.setAttribute("webRegisterVerifyCode", code);
            } else if("editPassword".equals(type)) {
                session.setAttribute("webEditPassVerifyCode", code);
            }
            // 利用Hutool封装的邮箱工具类发送邮件
            String send = MailUtil.send(mailAccount, CollectionUtil.newArrayList(userEmail),
                    "您正在注册果蔬超市账户……", "打死都不要告诉别人！！验证码是：" +
                            "<span style='color:#1E9FFF;font-size:16px;font-weight:800;'>" +
                            code + "</span>", true);
            System.out.println("邮件发送结果：" + send);
            return new ResultMessage(0, "邮件已发送！请查收");
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

}

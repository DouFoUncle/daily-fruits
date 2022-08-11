package priv.fruits.controller.web;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.lang.UUID;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import priv.fruits.pojo.Cart;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.pojo.User;
import priv.fruits.service.CartService;
import priv.fruits.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 * @Author 冶生华
 * @Date
 * @Description 果蔬超市
 */
@RestController
@RequestMapping("/webUser")
public class WebUserController {

    @Autowired
    private UserService userService;

    @Autowired
    private CartService cartService;

    /**
     * 前台用户退出
     * @return
     */
    @GetMapping("/loginOut")
    public ResultMessage loginOut(HttpServletRequest request) {
        // 将session中保存的登录用户的信息移除即可完成退出
        request.getSession().removeAttribute("webUserInfo");
        return new ResultMessage(0, "账号已安全退出！");
    }

    /**
     * 前台用户登录
     * @return
     */
    @PostMapping("/userLogin")
    public ResultMessage userLogin(@RequestBody User user, HttpServletRequest request) {
        try {
            if(StrUtil.isBlankOrUndefined(user.getUserEmail())
            || StrUtil.isBlankOrUndefined(user.getPassword())) {
                return new ResultMessage(400, "缺少必要登录参数！");
            }
            // 首先根据邮箱查询到这条信息
            User userInfoByEmail = userService.getUserInfoByEmail(user.getUserEmail());
            if(userInfoByEmail == null) {
                return new ResultMessage(207, "该邮箱未注册！");
            }
            // 邮箱无误, 取出盐值, 与用户输入的密码进行结合加密后比对
            String salt = userInfoByEmail.getSalt();
            String password = user.getPassword();
            // 加密结合
            String newPassword = SecureUtil.md5(SecureUtil.sha256(password) + SecureUtil.sha1(salt));
            // 查询密码与有邮箱是否匹配
            User loginUser = userService.getUserByLoginInfo(user.getUserEmail(), newPassword);
            if(loginUser == null) {
                return new ResultMessage(404, "邮箱或密码有误！");
            } else {
                // 判断用户账号是否可用, 1代表已被冻结
                if("1".equals(loginUser.getUserStatus())) {
                    return new ResultMessage(207, "抱歉您的账户已被冻结无法使用！请联系相关人员！");
                }
                // 登陆成功将信息保存在session中
                request.getSession().setAttribute("webUserInfo", loginUser);
                // 保存购物车当前数量
                Integer cartListCount = cartService.getCartCountByUserId(loginUser.getId());
                request.getSession().setAttribute("cartListCount", cartListCount);
                return new ResultMessage(0, "登陆成功！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

    /**
     * 用户注册
     * @return
     */
    @PostMapping("/insertInfo")
    public ResultMessage insertInfo(@RequestBody Map<String, Object> paramMap, HttpServletRequest request) {
        try {
            // 首先查看验证码输入是否正确
            String verifyCode = paramMap.get("verifyCode")+"";
            HttpSession session = request.getSession();
            // 取出session中保存的验证码
            String sessionVerifyCode = session.getAttribute("webRegisterVerifyCode")+"";
            // 比较验证码输入是否正确
            if(StrUtil.isBlankOrUndefined(sessionVerifyCode)) {
                return new ResultMessage(207, "验证码已失效！请重新获取！");
            }
            if(!StrUtil.isBlankOrUndefined(verifyCode)) {
                // 不相等返回错误
                if(!verifyCode.equals(sessionVerifyCode)) {
                    return new ResultMessage(207, "验证码输入有误！");
                }
            }
            String salt = UUID.randomUUID().toString();
            // 原密码 sha256 加密 + 盐值 sha1 加密, 组合后在进行 md5 加密
            String password = SecureUtil.md5(SecureUtil.sha256(paramMap.get("password")+"") + SecureUtil.sha1(salt));
            // 设置参数
            User user = new User();
            user.setNickName(paramMap.get("nickName")+"");
            user.setPassword(password);
            user.setSalt(salt);
            user.setUserEmail(paramMap.get("userEmail")+"");
            user.setCreateDate(DateUtil.now());
            user.setUserStatus("0");
            // 调用新增方法
            Boolean result = userService.insertInfo(user);
            if(result) {
                // 将session中保存的验证码删除
                session.removeAttribute("webRegisterVerifyCode");
                return new ResultMessage(0, "注册成功！");
            } else {
                return new ResultMessage(500, "注册成功！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

    /**
     * 更新一条user的密码信息
     * @param paramMap
     * @return
     */
    @PutMapping("/updatePassword")
    public ResultMessage updatePassword(@RequestBody Map<String, Object> paramMap, HttpServletRequest request) {
        // 执行修改
        try {
            // 首先查看验证码输入是否正确
            String verifyCode = paramMap.get("verifyCode")+"";
            HttpSession session = request.getSession();
            // 取出session中保存的验证码
            String sessionVerifyCode = session.getAttribute("webEditPassVerifyCode")+"";
            // 比较验证码输入是否正确
            if(StrUtil.isBlankOrUndefined(sessionVerifyCode)) {
                return new ResultMessage(207, "验证码已失效！请重新获取！");
            }
            if(!StrUtil.isBlankOrUndefined(verifyCode)) {
                // 不相等返回错误
                if(!verifyCode.equals(sessionVerifyCode)) {
                    return new ResultMessage(207, "验证码输入有误！");
                }
            }
            User userEmailInfo = userService.getUserInfoByEmail(paramMap.get("userEmail") + "");
            String salt = UUID.randomUUID().toString();
            // 原密码 sha256 加密 + 盐值 sha1 加密, 组合后在进行 md5 加密
            String password = SecureUtil.md5(SecureUtil.sha256(paramMap.get("password")+"") + SecureUtil.sha1(salt));
            User user = new User();
            user.setUserEmail(paramMap.get("userEmail")+"");
            user.setId(userEmailInfo.getId());
            user.setSalt(salt);
            user.setPassword(password);
            // 调用Service方法
            Boolean result = userService.updateInfo(user);
            if(result) {
                // 将session中保存的验证码删除
                session.removeAttribute("webEditPassVerifyCode");
                return new ResultMessage(0, "操作成功！");
            } else {
                return new ResultMessage(500, "操作成功！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

}

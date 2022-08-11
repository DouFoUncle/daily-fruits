package priv.fruits.controller;

import cn.hutool.crypto.SecureUtil;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import priv.fruits.pojo.User;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.service.UserService;

import java.util.List;

/**
 * t_user表的控制器层
 */
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 根据条件分页查询全部数据
     * @param user
     * @param page
     * @param limit
     * @return
     */
    @GetMapping("/getAllInfoByPage")
    public ResultMessage getAllInfoByPage(User user, Integer page, Integer limit) {
        // 查询数据
        try {
            // 调用Service查询方法收到返回的Page对象
            IPage<User> pageResult = userService.getInfoByPage(user, page, limit);
            // 封装数据
            return new ResultMessage(0, "查询成功！", pageResult.getRecords(), pageResult.getTotal());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 更新用户信息
     * @param user
     * @return
     */
    @PutMapping("/updateInfo")
    public ResultMessage updateInfo(@RequestBody User user) {
        try {
            Boolean result = userService.updateInfo(user);
            if(result) {
                return new ResultMessage(0, "操作成功！");
            } else {
                return new ResultMessage(207, "操作失败！数据无变化！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

}

package priv.fruits.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import priv.fruits.pojo.Admin;
import priv.fruits.pojo.EditAdmin;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.pojo.Sale;
import priv.fruits.service.AdminService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * t_admin表的控制器层
 */
@RestController
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    /**
     * 根据条件分页查询全部数据
     * @param admin
     * @param page
     * @param limit
     * @return
     */
    @GetMapping("/getAllInfoByPage")
    public ResultMessage getAllInfoByPage(Admin admin, Integer page, Integer limit) {
        // 查询数据
        try {
            // 调用Service查询方法收到返回的Page对象
            IPage<Admin> pageResult = adminService.getInfoByPage(admin, page, limit);
            // 封装数据
            return new ResultMessage(0, "查询成功！", pageResult.getRecords(), pageResult.getTotal());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 更新一条admin信息
     * @param editAdmin
     * @return
     */
    @PutMapping("/updateInfo")
    public ResultMessage updateInfo(@RequestBody EditAdmin editAdmin, HttpSession session) {
        try {
            // 取出保存的用户信息, 比对旧密码输入是否正确
            Admin loginAdmin = (Admin) session.getAttribute("adminUser");
            loginAdmin.setPassword(editAdmin.getPassword());
            // 进行查询
            Admin selectResult = adminService.getInfoByLogin(loginAdmin);
            // 查询结果为null代表输入的密码不对
            if(selectResult == null) {
                return new ResultMessage(500, "输入的原密码不正确!");
            }
            // 正确则进行更改
            selectResult.setPassword(editAdmin.getNewPassword());
            int result = adminService.updateInfo(selectResult);
            if(result > 0) {
                session.invalidate();
                return new ResultMessage(0, "操作成功! 请重新登录! ");
            } else {
                return new ResultMessage(500, "操作失败! 请稍后再试! ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

    /**
     * 删除一条或多条admin信息
     * @param ids
     * @return
     */
    @GetMapping("/deleteInfo")
    public ResultMessage deleteInfo(String ids) {
        try {
            // 添加信息
            Boolean result = adminService.deleteInfoByIds(ids);
            if(result) {
                return new ResultMessage(0, "操作成功！");
            } else {
                return new ResultMessage(207, "操作失败！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

    /**
     * 插入一条信息
     * @param admin
     * @return
     */
    @PostMapping("/insertInfo")
    public ResultMessage insertInfo(@RequestBody Admin admin) {
        try {
            // 添加信息
            Boolean result = adminService.insertInfo(admin);
            if(result) {
                return new ResultMessage(0, "操作成功！");
            } else {
                return new ResultMessage(207, "操作失败！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

}

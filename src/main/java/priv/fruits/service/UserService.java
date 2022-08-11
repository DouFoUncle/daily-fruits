package priv.fruits.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.mapper.UserMapper;
import priv.fruits.pojo.Admin;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.pojo.User;

import java.util.List;

/**
 * t_user表的业务层
 */
@Service
public class UserService extends ServiceImpl<UserMapper, User> {

    @Autowired
    private UserMapper userMapper;

    /**
     * 分页查询数据
     * @param user
     * @param page
     * @param limit
     * @return
     */
    public IPage<User> getInfoByPage(User user, Integer page, Integer limit) {
        // 创建MyBatisPlus的Page类，该类用于封装分页信息
        // 这里使用了构造器来创建Page，传入两个参数  第一个表示当前页，第二个表示每页展示的数量
        IPage<User> pageBean = new Page<>(page, limit);
        // 封装查询条件
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        // 判断查询字段是否为空， 不为空则拼接查询条件
        // like方法等于使用 MySQL 的Like查询 也就是模糊查询
        queryWrapper.like(!StrUtil.isBlank(user.getUserEmail()),"user_email", user.getUserEmail());
        // eq方法等于使用 MySQL 的 = 查询 也就是等值查询
        queryWrapper.eq(!StrUtil.isBlank(user.getUserStatus()),"user_status", user.getUserStatus());
        // 调用Service层中MyBatisPlus已经实现好的查询方法（page方法就是分页查询的方法）
        // 会返回一个Page对象
        IPage<User> resultPage = userMapper.selectPage(pageBean, queryWrapper);
        return resultPage;
    }

    /**
     * 根据用户ID更新用户信息
     * @param user
     * @return
     */
    public Boolean updateInfo(User user) {
        return this.updateById(user);
    }

    /**
     * 新增一条数据
     * @param user
     * @return
     */
    public Boolean insertInfo(User user) {
        return this.save(user);
    }

    /**
     * 根据邮箱查询一条用户信息
     * @param userEmail
     * @return
     */
    public User getUserInfoByEmail(String userEmail) {
        return this.getOne(new QueryWrapper<User>().eq("user_email", userEmail));
    }

    /**
     * 根据输入的登录信息查询登陆是否成功
     * @param userEmail
     * @param newPassword
     * @return
     */
    public User getUserByLoginInfo(String userEmail, String newPassword) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_email", userEmail);
        queryWrapper.eq("password", newPassword);
        return this.getOne(queryWrapper);
    }

    public User getUserInfoById(Integer userId) {
        return this.getOne(new QueryWrapper<User>().eq("id", userId));
    }
}

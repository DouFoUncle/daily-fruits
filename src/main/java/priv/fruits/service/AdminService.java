package priv.fruits.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.text.StrSpliter;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.pojo.Admin;
import priv.fruits.mapper.AdminMapper;
import priv.fruits.pojo.Sale;

import java.util.Date;
import java.util.List;

/**
 * t_admin的业务层
 */
@Service
public class AdminService extends ServiceImpl<AdminMapper, Admin> {

    @Autowired
    private AdminMapper adminMapper;

    /**
     * 后台用户登录
     * @param admin
     * @return
     */
    public Admin getInfoByLogin(Admin admin) {
        // 创建MyBatisPlus的查询对象
        QueryWrapper<Admin> queryWrapper = new QueryWrapper<Admin>();
        queryWrapper.eq("user_name", admin.getUserName());
        queryWrapper.eq("password", admin.getPassword());
        // 调用MyBatisPlus查询方法
        return adminMapper.selectOne(queryWrapper);
    }

    /**
     * 更新admin信息
     * @param admin
     * @return
     */
    public int updateInfo(Admin admin) {
        // 调用更新方法
        return adminMapper.updateById(admin);
    }

    /**
     * 分页查询全部信息
     * @param admin
     * @param page
     * @param limit
     * @return
     */
    public IPage<Admin> getInfoByPage(Admin admin, Integer page, Integer limit) {
        // 创建分页对象
        IPage<Admin> pageBean = new Page<>(page, limit);
        // 创建查询对象
        QueryWrapper<Admin> queryWrapper = new QueryWrapper<>();
        return adminMapper.selectPage(pageBean, queryWrapper);
    }

    /**
     * 插入一条信息
     * @param admin
     * @return
     */
    public Boolean insertInfo(Admin admin) {
        return this.save(admin);
    }

    /**
     * 删除多条信息
     * @param ids
     * @return
     */
    public Boolean deleteInfoByIds(String ids) {
        // 使用Hutool的StrSpliter工具类将收到的多个ID进行分割, 分割后返回一个List
        List<String> split = StrSpliter.split(ids, ',', -1, true, true);
        return this.remove(new QueryWrapper<Admin>().in("id", split));
    }
}

package priv.fruits.service;

import cn.hutool.core.date.DateUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.pojo.MenuAdminRelation;
import priv.fruits.mapper.MenuAdminRelationMapper;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

@Service
public class MenuAdminRelationService extends ServiceImpl<MenuAdminRelationMapper, MenuAdminRelation> {

    // 创建数据库层对象
    @Autowired
    private MenuAdminRelationMapper menuAdminRelationMapper;

    /**
     * 根据管理员ID获取该管理员已拥有的菜单权限
     * @param userId
     * @return
     */
    public List<MenuAdminRelation> getMenuInfoByUserId(String userId) {
        return menuAdminRelationMapper.getMenuInfoByUserId(userId);
    }

    /**
     * 根据管理员ID插入菜单信息
     * @param adminId
     * @param menuIds
     * @return
     */
    public Boolean insertInfoByAdminId(Object adminId, List<Object> menuIds) {
        // 首先将该管理员的现有数据全部删除, 之后在重新插入即可
        this.remove(new QueryWrapper<MenuAdminRelation>().eq("user_id", adminId));

        // 处理要插入的数据
        List<MenuAdminRelation> insertInfos = new ArrayList<>(16);
        menuIds.forEach(item -> {
            MenuAdminRelation insertInfo = new MenuAdminRelation();
            insertInfo.setMenuId(Integer.parseInt(item+""));
            insertInfo.setUserId(Integer.parseInt(adminId+""));
            insertInfos.add(insertInfo);
        });
        // 调用批量插入方法
        return this.saveBatch(insertInfos);
    }
}

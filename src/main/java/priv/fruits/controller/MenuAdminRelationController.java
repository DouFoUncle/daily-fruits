package priv.fruits.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import priv.fruits.pojo.*;
import priv.fruits.service.AdminService;
import priv.fruits.service.MenuAdminRelationService;
import priv.fruits.service.MenuService;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * t_admin表的控制器层
 */
@RestController
@RequestMapping("/menuAdminRelation")
public class MenuAdminRelationController {

    @Autowired
    private MenuAdminRelationService menuAdminRelationService;

    @Autowired
    private MenuService menuService;

    /**
     * 查询所有菜单信息用于生成树状组件信息
     * 同时根据AdminID查询该管理员下的所拥有的菜单信息
     * 将已拥有的菜单信息默认选中
     * @param adminId
     * @return
     */
    @GetMapping("/getAllInfoByTreeBean")
    public ResultMessage getAllInfoByTreeBean(String adminId, String type) {
        // 查询数据
        try {
            // 查询全部菜单信息
            List<Menu> allMenuInfo = menuService.getAllInfo();
            List<MenuAdminRelation> menuInfoByUserId = menuAdminRelationService.getMenuInfoByUserId(adminId);
            // 最终返回的树状组件信息
            // 循环处理将所有菜单加入集合
            List<LayuiTreeBean> resultList = handleAllMenuInfo(allMenuInfo, "update".equals(type));
            // 遍历集合将该用户已有的菜单信息修改为已拥有的状态
            for (LayuiTreeBean layuiTreeBean : resultList) {
                for (MenuAdminRelation menuAdminRelation : menuInfoByUserId) {
                    if((menuAdminRelation.getMenuId()+"").equals(layuiTreeBean.getId()+"")) {
                        layuiTreeBean.setChecked(true);
                    } else if(layuiTreeBean.getChildren() != null && layuiTreeBean.getChildren().size() > 0) {
                        // 如果是一级菜单, 则需要再将其包含的二级菜单循环一遍
                        for (LayuiTreeBean child : layuiTreeBean.getChildren()) {
                            if((menuAdminRelation.getMenuId()+"").equals(child.getId()+"")) {
                                child.setChecked(true);
                            }
                        }
                    }
                }
            }
            // 封装数据
            return new ResultMessage(0, "查询成功！", resultList);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 根据管理员ID分配菜单权限
     * @return
     */
    @PostMapping("/insertInfoByAdminId")
    public ResultMessage insertInfoByAdminId(@RequestBody Map<String, Object> paramMap) {
        try {
            Object adminId = paramMap.get("adminId");
            List<Object> menuIds = (List<Object>) paramMap.get("menuIds");
            Boolean result = menuAdminRelationService.insertInfoByAdminId(adminId, menuIds);
            if(result) {
                return new ResultMessage(0, "操作成功!");
            } else {
                return new ResultMessage(207, "操作失败! 请稍后再试!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

    /**
     * 处理全部菜单信息的集合
     * @param allMenuInfo
     * @return
     */
    private List<LayuiTreeBean> handleAllMenuInfo(List<Menu> allMenuInfo, boolean isSkipAdmin) {
        List<LayuiTreeBean> resultList = new ArrayList<>(16);
        // 先将所有菜单加入到集合中
        for (Menu menu : allMenuInfo) {
            if(menu.getId() == 8 && isSkipAdmin) {
                continue;
            }
            // 如果是一集菜单则再寻找他的二级菜单有哪些
            if(StrUtil.isBlankOrUndefined(menu.getUrl())) {
                LayuiTreeBean layuiTreeBean = new LayuiTreeBean();
                layuiTreeBean.setChecked(false);
                layuiTreeBean.setId(menu.getId());
                layuiTreeBean.setTitle(menu.getMenuName());
                layuiTreeBean.setField("menu_name");
                layuiTreeBean.setSpread(true);
                List<LayuiTreeBean> subMenu = new ArrayList<>(16);
                for (Menu menu1 : allMenuInfo) {
                    // 只寻找二级菜单, 如果是一级直接跳过
                    if(StrUtil.isBlankOrUndefined(menu1.getParentId()+"")) {
                        continue;
                    }
                    // 是否相匹配
                    if(menu1.getParentId() == menu.getId()) {
                        LayuiTreeBean subLayuiTreeBean = new LayuiTreeBean();
                        subLayuiTreeBean.setId(menu1.getId());
                        subLayuiTreeBean.setTitle(menu1.getMenuName());
                        subLayuiTreeBean.setField("menu_name");
                        subLayuiTreeBean.setChecked(false);
                        subMenu.add(subLayuiTreeBean);
                    }
                }
                layuiTreeBean.setChildren(subMenu);
                resultList.add(layuiTreeBean);
            } else if(StrUtil.isBlankOrUndefined(menu.getParentId()+"")) {
                LayuiTreeBean layuiTreeBean = new LayuiTreeBean();
                layuiTreeBean.setId(menu.getId());
                layuiTreeBean.setTitle(menu.getMenuName());
                layuiTreeBean.setField("menu_name");
                layuiTreeBean.setChecked(false);
                resultList.add(layuiTreeBean);
            }
        }
        return resultList;
    }

}

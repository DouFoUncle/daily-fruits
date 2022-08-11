package priv.fruits.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;
import priv.fruits.pojo.*;
import priv.fruits.service.*;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @Author Mr.Zheng
 * @Date 2020/12/10
 * @Description 控制页面的跳转和一些简单逻辑跳转
 */
@Controller
public class SystemController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private MenuAdminRelationService menuAdminRelationService;

    @Autowired
    private GoodsService goodsService;

    @Autowired
    private SaleService saleService;

    @Autowired
    private MenuService menuService;

    @Autowired
    private GoodsTypeService goodsTypeService;

    @Autowired
    private TDiscountService discountService;

    /**
     * 跳转到后台首页
     * @return
     */
    @GetMapping("system/toAdminMainPage")
    public String toAdminMainPage() {
        return "admin/index";
    }

    /**
     * 后台用户登陆
     * @return
     */
    @PostMapping("system/adminLogin")
    public String verifyLogin(Admin admin, HttpSession session, HttpServletResponse response) {
        // 验证登陆
        Admin selectResult = adminService.getInfoByLogin(admin);
        // 查询结果为空
        if(selectResult == null) {
            // 密码或用户名有误
            session.setAttribute("msg", "登录失败! 用户名或密码输入有误! ");
            return "redirect:/system/toAdminLoginPage";
        } else {
            // 移除消息提示
            session.removeAttribute("msg");
            // 查询该用户拥有的菜单项
            List<MenuAdminRelation> menuInfoByUserId = menuAdminRelationService.getMenuInfoByUserId(selectResult.getId() + "");
            // 父菜单
            List<MenuAdminRelation> parentMenu = new ArrayList<>(16);
            // 子菜单
            List<MenuAdminRelation> subMenu = new ArrayList<>(16);
            // 将数组进行处理
            for (MenuAdminRelation menuAdminRelation : menuInfoByUserId) {
                // 如果地址为空就是父菜单， 否则是子菜单
                if(StrUtil.isBlankOrUndefined(menuAdminRelation.getMenu().getParentId()+"")) {
                    parentMenu.add(menuAdminRelation);
                } else {
                    subMenu.add(menuAdminRelation);
                }
            }
            // 查询一下所有菜单信息进行保存
            List<Menu> allInfo = menuService.getAllInfo();
            // 清空一下缓存
            response.setHeader("Pragma","No-cache");
            response.setHeader("Cache-Control","no-cache");
            response.setDateHeader("Expires", 0);
            // 将菜单信息保存到session中
            System.out.println("该管理员拥有的一级菜单" + parentMenu.toString());
            System.out.println("该管理员拥有的二级菜单" + subMenu.toString());
            session.setAttribute("parentMenu", parentMenu);
            session.setAttribute("subMenu", subMenu);
            session.setAttribute("allMenuInfo", allInfo);
            // 将菜单分为父菜单和子菜单两种
            session.setAttribute("", menuInfoByUserId);
            // 将用户信息保存到session中
            // 设置前将用户密码剔除
            selectResult.setPassword("");
            session.setAttribute("adminUser", selectResult);
            return "redirect:/system/toAdminMainPage";
        }
    }

    /**
     * 退出登录
     * @param session
     * @param response
     * @return
     */
    @GetMapping("/system/adminLoginOut")
    public String loginOut(HttpSession session, HttpServletResponse response) {
        response.setHeader("Pragma","No-cache");
        response.setHeader("Cache-Control","no-cache");
        response.setDateHeader("Expires", 0);
        session.removeAttribute("adminUser");
        return "redirect:/system/toAdminLoginPage";
    }

    /**
     * 跳转到欢迎页
     * @return
     */
    @GetMapping("system/toWelcomePage")
    public String toWelcomePage() {
        return "admin/welcome";
    }

    /**
     * 跳转到后台登陆页面
     * @return
     */
    @GetMapping("system/toAdminLoginPage")
    public String toAdminLoginPage() {
        return "admin/login";
    }

    /**
     * 跳转到登录超时页面
     * @return
     */
    @GetMapping("system/toTimeOutPage")
    public String toTimeOutPage() {
        return "admin/error/timeOut";
    }


    // + ---------------------------------------------------------------------------
    // +                           后台管理系统所有页面跳转 Start
    // + ---------------------------------------------------------------------------
    /**
     * 跳转到 admin 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/admin/toDataPage")
    public ModelAndView toAdminDataPage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/admin/admin");
        return modelAndView;
    }

    /**
     * 跳转到 添加管理员页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/admin/toAddWindow")
    public ModelAndView toAddWindow(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/admin/add");
        return modelAndView;
    }

    /**
     * 跳转到分配菜单权限页面
     * @param modelAndView
     * @param id
     * @return
     */
    @GetMapping("/admin/toMenuPowerPage")
    public ModelAndView toMenuPowerPage(ModelAndView modelAndView, String id, String type) {
        modelAndView.addObject("adminId", id);
        modelAndView.addObject("type", type);
        modelAndView.setViewName("admin/admin/power");
        return modelAndView;
    }

    /**
     *
     * @param modelAndView
     * @return
     */
    @GetMapping("/admin/toUpdatePwdWindows")
    public ModelAndView toUpdatePwdWindows(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/admin/editPwd");
        return modelAndView;
    }

    /**
     * 跳转到 折扣 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/discount/toDataPage")
    public ModelAndView toDiscountDataPage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/discount/discount");
        return modelAndView;
    }

    /**
     * 跳转到 折扣 修改页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/discount/toEditPage")
    public ModelAndView toDiscountEditPage(ModelAndView modelAndView, Integer id) {
        modelAndView.addObject("obj", discountService.getOne(new QueryWrapper<TDiscount>().eq("id", id)));
        modelAndView.setViewName("admin/discount/edit");
        return modelAndView;
    }

    /**
     * 跳转到 user 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/user/toDataPage")
    public ModelAndView toUserDataPage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/user/user");
        return modelAndView;
    }

    /**
     * 跳转到 address 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/address/toDataPage")
    public ModelAndView toAddressDataPage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/address/address");
        return modelAndView;
    }

    /**
     * 跳转到 order 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/order/toDataPage")
    public ModelAndView toOrderDataPage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/order/order");
        return modelAndView;
    }

    /**
     * 跳转到 order 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/orderDetail/toDataPage")
    public ModelAndView toOrderDetailDataPage(ModelAndView modelAndView, String orderId) {
        modelAndView.addObject("orderId", orderId);
        modelAndView.setViewName("admin/order_detail/orderDetail");
        return modelAndView;
    }

    /**
     * 跳转到 purchase 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/purchase/toDataPage")
    public ModelAndView toPurchaseDataPage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/purchase/purchase");
        return modelAndView;
    }

    /**
     * 跳转到 purchase 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/purchaseDetail/toDataPage")
    public ModelAndView toPurchaseDataPage(ModelAndView modelAndView, String purchaseId, String purchaseStatus) {
        modelAndView.addObject("purchaseId", purchaseId);
        modelAndView.addObject("purchaseStatus", purchaseStatus);
        modelAndView.setViewName("admin/purchase_detail/purchaseDetail");
        return modelAndView;
    }

    /**
     * 跳转到 purchase 导入Excel页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/purchase/toImportPage")
    public ModelAndView toImportPage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/purchase/importPage");
        return modelAndView;
    }

    /**
     * 跳转到 sale 表格展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/sale/toDataTablePage")
    public ModelAndView toDataTablePage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/sale/saleTable");
        return modelAndView;
    }

    /**
     * 跳转到 sale 图表展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/sale/toDataChartPage")
    public ModelAndView toDataChartPage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/sale/saleChart");
        return modelAndView;
    }

    /**
     * 跳转到 GoodsType 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/goodsType/toDataPage")
    public ModelAndView toGoodsTypeDataPage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/goodsType/goodsType");
        return modelAndView;
    }

    /**
     * 跳转到 GoodsType 新增页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/goodsType/toAddPage")
    public ModelAndView toGoodsTypeAddPage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/goodsType/add");
        return modelAndView;
    }

    /**
     * 跳转到 Goods 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/goods/toDataPage")
    public ModelAndView toGoodsDataPage(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/goods/goods");
        return modelAndView;
    }

    /**
     * 跳转到 Goods 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/goods/toAddWindow")
    public ModelAndView toGoodsAddWindow(ModelAndView modelAndView) {
        // 查询所有类型信息
        modelAndView.addObject("typeList", goodsTypeService.getAllTypeInfo());
        modelAndView.setViewName("admin/goods/add");
        // 查询所有类型信息
        return modelAndView;
    }

    /**
     * 跳转到 Goods 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/goods/toExportAddWindow")
    public ModelAndView toExportAddWindow(ModelAndView modelAndView) {
        modelAndView.setViewName("admin/goods/addExport");
        // 查询所有类型信息
        return modelAndView;
    }

    /**
     * 跳转到 Goods 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/goods/toAddStock")
    public ModelAndView toAddStock(ModelAndView modelAndView, String purchaseId) {
        modelAndView.addObject("purchaseId", purchaseId);
        modelAndView.setViewName("admin/goods/addStock");
        return modelAndView;
    }

    /**
     * 跳转到 Goods 展示数据页面
     * @param modelAndView
     * @return
     */
    @GetMapping("/goods/toEditWindow")
    public ModelAndView toGoodsEditWindow(ModelAndView modelAndView, String id) {
        Goods goods = goodsService.getInfoById(id);
        modelAndView.addObject("editInfo", goods);
        // 查询所有类型信息
        modelAndView.addObject("typeList", goodsTypeService.getAllTypeInfo());
        modelAndView.setViewName("admin/goods/edit");
        return modelAndView;
    }

    // + ---------------------------------------------------------------------------
    // +                           后台管理系统所有页面跳转 End
    // + ---------------------------------------------------------------------------

}

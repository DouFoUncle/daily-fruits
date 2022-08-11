package priv.fruits.interceptor;

import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson.JSON;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import priv.fruits.pojo.Admin;
import priv.fruits.pojo.Menu;
import priv.fruits.pojo.MenuAdminRelation;
import priv.fruits.service.MenuService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author: 冶生华
 * @date: 2022/01/10
 * @time: 11:42
 * @comment: 拦截
 */
public class AdminInterceptor implements HandlerInterceptor {

    @Autowired
    private MenuService menuService;

    /**
     * 跳转前拦截
     * @param request
     * @param response
     * @param handler
     * @return
     * @throws Exception
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //每次跳转前判断当前是否已经是登录状态，如果不是则跳到登录页面，防止直接输入网址越过登录访问
        Admin admin = (Admin) request.getSession().getAttribute("adminUser");
        if(admin == null) {
            //判断是否是Ajax请求  获取到请求头中的Ajax参数
            String XRequested =request.getHeader("X-Requested-With");
            //Ajax请求中带有的参数
            String ajaxReq = "XMLHttpRequest";
            if(ajaxReq.equals(XRequested)){
                Map<String, Object> map = new HashMap<>(1);
                map.put("result","IsAdminAjax");
                String data = JSON.toJSONString(map);
                response.getWriter().write(data);
                return false;
            }else{
                System.out.println("拦截路径" + request.getRequestURI());
                response.sendRedirect(request.getContextPath()+"/system/toTimeOutPage");
                return false;
            }
        } else {
            // 判断是否有权限跳转
            String requestURI = request.getRequestURI();
            // 静态资源直接跳过
            if(requestURI.contains("css") || requestURI.contains("js") || requestURI.contains("data") ||
                    requestURI.contains("upload") || requestURI.contains("fonts") ||
                    requestURI.contains("lib") || requestURI.contains("images")) {
                return true;
            }
            // 非静态资源先循环判断该路径是否是菜单路径
            List<Menu> allInfo = (List<Menu>) request.getSession().getAttribute("allMenuInfo");
            Integer resultId = -1;
            for (Menu menu : allInfo) {
                if(StrUtil.isBlankOrUndefined(menu.getUrl())) {
                    continue;
                } else {
                    String url = menu.getUrl().substring(2);
                    // 判断菜单路径是否包含该路径, 包含则代表是菜单跳转
                    if(requestURI.contains(url)) {
                        // 得到该菜单的ID
                        resultId = menu.getId();
                        break;
                    }
                }
            }
            // 查看该用户是否有该菜单的权限, 没有则不能跳转
            boolean power = isPower(request.getSession(), resultId);
            if(!power) {
                // 跳转到没有权限页面
                response.sendRedirect(request.getContextPath()+"/error/toNoPowerPage");
            }
            return power;
        }
    }

    /**
     * 判断用户是否有菜单权限
     * @return
     */
    private boolean isPower(HttpSession session, Integer menuId) {
        // menuId = -1表示该访问路径有可能是请求数据等, 并不在菜单项中, 可以直接通过
        if(menuId == -1) {
            return true;
        }
        List<MenuAdminRelation> parentMenu = (List<MenuAdminRelation>) session.getAttribute("parentMenu");
        List<MenuAdminRelation> subMenu = (List<MenuAdminRelation>) session.getAttribute("subMenu");
        for (MenuAdminRelation menu : parentMenu) {
            if(menu.getMenuId().equals(menuId)) {
                return true;
            }
        }
        for (MenuAdminRelation menu : subMenu) {
            if(menu.getMenuId().equals(menuId)) {
                return true;
            }
        }
        return false;
    }
}

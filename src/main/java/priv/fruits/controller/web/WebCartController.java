package priv.fruits.controller.web;

import com.alibaba.fastjson.JSON;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import priv.fruits.pojo.Cart;
import priv.fruits.pojo.Goods;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.pojo.User;
import priv.fruits.service.CartService;
import priv.fruits.service.GoodsService;
import priv.fruits.service.UserService;
import priv.fruits.util.ServletUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author 冶生华
 * @Description 果蔬超市
 */
@Controller
@RequestMapping("/webCart")
public class WebCartController {

    @Autowired
    private CartService cartService;

    @Autowired
    private GoodsService goodsService;

    /**
     * 跳转到购物车页面
     * @return
     */
    @GetMapping("/toCartPage")
    public ModelAndView toCartPage(ModelAndView modelAndView, HttpServletRequest request) {
        modelAndView.setViewName("web/cart");
        List<Cart> cartInfoByUserId = cartService.getCartInfoByUserId(ServletUtils.getWebUserIdInfo(request));
        modelAndView.addObject("cartGoodsInfo", cartInfoByUserId);
        // 计算总价
        Integer totalPrice = 0;
        for (Cart cart : cartInfoByUserId) {
            if(cart.getDisTotal() != null) {
                totalPrice += cart.getDisTotal();
            } else {
                totalPrice += cart.getGoodsTotal();
            }
        }
        modelAndView.addObject("totalPrice", totalPrice);
        modelAndView.addObject("isCartPage", "cartPage");
        modelAndView.addObject("projectPath", ServletUtils.getProjectHttpUrl(request));
        return modelAndView;
    }

    /**
     * 根据用户ID获取购物车信息
     * 用户ID可以直接从session中取出
     * @return
     */
    @GetMapping("/getInfoByUserId")
    @ResponseBody
    public ResultMessage getInfoByUserId(HttpServletRequest request) {
        try {
            // 根据用户ID查询信息
            List<Cart> cartInfoByUserId = cartService.getCartInfoByUserId(ServletUtils.getWebUserIdInfo(request));
            // 统计小计 同时 将数据中的图片地址拼接完整
            Integer totalPrice = 0;
            Integer oldTotalCount = 0;
            for (Cart cart : cartInfoByUserId) {
                if(cart.getDisPrice() != null) {
                    totalPrice += cart.getDisTotal();
                    oldTotalCount += cart.getGoodsTotal() - cart.getDisTotal();
                } else {
                    totalPrice += cart.getGoodsTotal();
                }
                cart.setGoodsHeadImg(ServletUtils.getProjectHttpUrl(request) +
                        "/upload/" + cart.getGoodsHeadImg());
            }
            Map<String, Object> data = new HashMap<>();
            data.put("totalPrice", totalPrice);
            data.put("cartList", cartInfoByUserId);
            data.put("disTotal", oldTotalCount);
            // 封装结果集
            return new ResultMessage(0, "查询成功！", data);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }

    }

    /**
     * 新增一条购物车信息
     * @param paramMap
     * @return
     */
    @PostMapping("/insertInfo")
    @ResponseBody
    public ResultMessage insertInfo(@RequestBody Map<String, Object> paramMap, HttpServletRequest request) {
        try {
            User webUserInfo = (User) request.getSession().getAttribute("webUserInfo");
            // 将Map转换为Goods对象
            Goods goods = goodsService.getInfoById(paramMap.get("goodsId")+"");
            if(goods.getGoodsStock() <= 0) {
                return new ResultMessage(207, "手慢了！该商品已无库存！加紧补货中……");
            }
            // 取出数量
            Integer goodsCount = Integer.parseInt(paramMap.get("goodsCount") + "");
            // 首先查询该商品是否已经存在在购物车中(根据商品ID查询)
            Cart selectCartInfo = cartService.getCartInfoByGoodsIdAndUserId(goods.getId(), webUserInfo.getId());
            Integer result = cartService.insertInfo(goods, goodsCount,
                    webUserInfo.getId(), selectCartInfo == null,
                    selectCartInfo != null ? selectCartInfo : null);
            if(result > 0) {
                HttpSession session = request.getSession();
                Integer cartListCount = Integer.parseInt(session.getAttribute("cartListCount")+"");
                // 重新赋值购物车数量
                if(selectCartInfo == null) {
                    cartListCount += 1;
                    session.removeAttribute("cartListCount");
                    session.setAttribute("cartListCount", cartListCount);
                }
                return new ResultMessage(0, "已加入购物车！快去看看吧！", cartListCount);
            } else if(result == -500) {
                return new ResultMessage(207, "选择的数量与购物车原有的数量相加超出库存！请重新选择！");
            } else {
                return new ResultMessage(203, "操作失败！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

    /**
     * 更新一条购物车信息
     * @param cart
     * @param request
     * @return
     */
    @ResponseBody
    @PutMapping("/updateInfo")
    public ResultMessage updateInfo(@RequestBody Cart cart, HttpServletRequest request) {
        try {
            // 调用更新方法
            Boolean result = cartService.updateCartCount(cart);
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
     * 删除一条购物车信息
     * @return
     */
    @ResponseBody
    @GetMapping("/deleteInfo")
    public ResultMessage deleteInfo(Integer id, HttpServletRequest request) {
        try {
            // 调用删除方法
            Boolean result = cartService.deleteCartInfo(id);
            if(result) {
                // 重新赋值购物车数量
                HttpSession session = request.getSession();
                User webUserInfo = (User) session.getAttribute("webUserInfo");
                Integer cartListCount = Integer.parseInt(session.getAttribute("cartListCount")+"");
                // 查询购物车总价
                Integer totalPrice = cartService.getCartTotalPriceByUserId(webUserInfo.getId());
                session.removeAttribute("cartListCount");
                session.setAttribute("cartListCount", cartListCount - 1);
                Map<String, Object> data = new HashMap<>();
                data.put("cartListCount", cartListCount - 1);
                data.put("totalPrice", totalPrice);
                return new ResultMessage(0, "操作成功！", data);
            } else {
                return new ResultMessage(207, "操作失败！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

}

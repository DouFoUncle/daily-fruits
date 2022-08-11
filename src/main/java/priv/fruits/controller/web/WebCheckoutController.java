package priv.fruits.controller.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import priv.fruits.pojo.Address;
import priv.fruits.pojo.Cart;
import priv.fruits.service.AddressService;
import priv.fruits.service.CartService;
import priv.fruits.util.ServletUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @Author 冶生华
 * @Date 2022/2/24
 * @Description 果蔬超市
 */
@Controller
@RequestMapping("/webCheckout")
public class WebCheckoutController {

    @Autowired
    private CartService cartService;

    @Autowired
    private AddressService addressService;

    /**
     * 跳转到收银台页面
     * @return
     */
    @GetMapping("/toCheckoutPage")
    public ModelAndView toCheckoutPage(ModelAndView modelAndView, HttpServletRequest request) {
        // 查询该用户的购物车信息
        List<Cart> cartInfoByUserId = cartService.getCartInfoByUserId(ServletUtils.getWebUserIdInfo(request));
        // 计算总价
        Integer totalCount = 0;
        Integer oldTotalCount = 0;
        for (Cart cart : cartInfoByUserId) {
            if(cart.getDisPrice() != null) {
                totalCount += cart.getDisTotal();
                oldTotalCount += cart.getGoodsTotal() - cart.getDisTotal();
            } else {
                totalCount += cart.getGoodsTotal();
            }
        }
        modelAndView.addObject("cartList", cartInfoByUserId);
        modelAndView.addObject("totalPrice", totalCount);
        modelAndView.addObject("disTotal", oldTotalCount);
        Address defaultAddress = addressService.getDefaultInfoByUserId(ServletUtils.getWebUserIdInfo(request));
        // 查询用户的默认地址
        modelAndView.addObject("defaultAddress", defaultAddress);
        modelAndView.setViewName("web/checkout");
        return modelAndView;
    }

}

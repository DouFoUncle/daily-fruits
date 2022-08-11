package priv.fruits.controller.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import priv.fruits.pojo.Address;
import priv.fruits.pojo.Order;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.service.OrderService;
import priv.fruits.util.ServletUtils;

import javax.servlet.http.HttpServletRequest;

/**
 * @Author 冶生华
 * @Date 2022/2/26
 * @Description 果蔬超市
 */
@RestController
@RequestMapping("/webOrder")
public class WebOrderController {

    @Autowired
    private OrderService orderService;

    /**
     * 将购物车信息提交到订单, 并且清空购物车信息
     * @return
     */
    @PostMapping("/submitCartInfo")
    public ResultMessage submitCartInfo(@RequestBody Address address, HttpServletRequest request) {
        try {
            Boolean result = orderService.insertOrderAndClearCart(address,
                    ServletUtils.getWebUserInfo(request));
            if(result) {
                request.getSession().removeAttribute("cartListCount");
                return new ResultMessage(0, "操作成功！");
            } else {
                return new ResultMessage(207, "操作成功！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

}

package priv.fruits.controller.web;

import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import priv.fruits.pojo.Address;
import priv.fruits.pojo.Order;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.service.AddressService;
import priv.fruits.service.OrderService;
import priv.fruits.util.ServletUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @Author 冶生华
 * @Date 2022/2/26
 * @Description 果蔬超市
 */
@Controller
@RequestMapping("/webMe")
public class WebMeController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private AddressService addressService;

    /**
     * 跳转到个人中心
     * @return
     */
    @GetMapping("/toMePage")
    public ModelAndView toMePage(ModelAndView modelAndView, String type, HttpServletRequest request) {
        if(StrUtil.isBlankOrUndefined(type)) {
            type = "order";
        }
        modelAndView.addObject("type", type);
        modelAndView.addObject("userId", ServletUtils.getWebUserIdInfo(request));
        modelAndView.setViewName("web/me");
        return modelAndView;
    }

    /**
     * 跳转到个人中心 - 我的订单
     * @return
     */
    @GetMapping("/toMeOrderPage")
    public ModelAndView toMeOrderPage(ModelAndView modelAndView, HttpServletRequest request) {
        modelAndView.addObject("userId", ServletUtils.getWebUserIdInfo(request));
        modelAndView.addObject("type", "order");
        modelAndView.setViewName("web/meOrder");
        return modelAndView;
    }

    /**
     * 跳转到个人中心 - 我的收货地址
     * @return
     */
    @GetMapping("/toMeAddressPage")
    public ModelAndView toMeAddressPage(ModelAndView modelAndView, HttpServletRequest request) {
        modelAndView.addObject("type", "address");
        modelAndView.addObject("userId", ServletUtils.getWebUserIdInfo(request));
        modelAndView.setViewName("web/addressWindow");
        return modelAndView;
    }

    /**
     * 获取用户所有订单
     * @return
     */
    @GetMapping("/getOrderInfoByPage")
    @ResponseBody
    public ResultMessage getOrderInfoByPage(Order order, String start, String end, Integer page, Integer limit) {
        try {
            if(!StrUtil.isBlankOrUndefined(start) && StrUtil.isBlankOrUndefined(end)) {
                end = start;
            }
            // 调用查找方法
            IPage<Order> pageResult = orderService.getInfoByPage(order, start, end, page, limit);
            List<Order> records = pageResult.getRecords();
            records.forEach(item -> {
                item.setAddressBean(JSON.parseObject(item.getAddressJsonStr(), Address.class));
            });
            // 封装数据
            return new ResultMessage(0, "查询成功！", records, pageResult.getTotal());
        } catch(Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "后台出现异常：" + e.getMessage());
        }
    }

    /**
     * 获取用户所有订单
     * @return
     */
    @GetMapping("/getAddressByUserId")
    @ResponseBody
    public ResultMessage getAddressByUserId(Address address, Integer page, Integer limit, HttpServletRequest request) {
        // 查询数据
        try {
            // 调用Service查询方法收到返回的Page对象
            address.setUserId(ServletUtils.getWebUserIdInfo(request));
            List<Address> addressList = addressService.selectAllInfo(address, page, limit);
            return new ResultMessage(0, "查询成功！", addressList, Long.parseLong(addressService.getAllCount(address) + ""));
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

}

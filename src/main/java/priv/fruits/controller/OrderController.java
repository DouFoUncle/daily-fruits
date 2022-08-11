package priv.fruits.controller;

import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import priv.fruits.pojo.Address;
import priv.fruits.pojo.Order;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.service.OrderService;

import java.util.List;

/**
 * t_order表的控制器层
 */
@RestController
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    /**
     * 根据条件分页查询全部数据
     * @param order
     * @param page
     * @param limit
     * @return
     */
    @GetMapping("/getAllInfoByPage")
    public ResultMessage getAllInfoByPage(Order order, String start, String end, Integer page, Integer limit) {
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
     * 插入一条order信息
     * @param order
     * @return
     */
    @PostMapping("/insertInfo")
    public ResultMessage insertInfo(@RequestBody Order order) {
        return null;
    }

    /**
     * 更新一条order信息
     * @param order
     * @return
     */
    @PutMapping("/updateInfo")
    public ResultMessage updateInfo(@RequestBody Order order) {
        return null;
    }

    /**
     * 删除一条或多条order信息
     * @param ids
     * @return
     */
    @GetMapping("/deleteInfo")
    public ResultMessage deleteInfo(String ids) {
        return null;
    }

}

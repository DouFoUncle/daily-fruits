package priv.fruits.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import priv.fruits.pojo.OrderDetail;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.service.OrderDetailService;

/**
 * t_order_detail表的控制器层
 */
@RestController
@RequestMapping("/orderDetail")
public class OrderDetailController {

    @Autowired
    private OrderDetailService orderDetailService;

    /**
     * 根据条件分页查询全部数据
     * @param orderDetail
     * @param page
     * @param limit
     * @return
     */
    @GetMapping("/getAllInfoByPage")
    public ResultMessage getAllInfoByPage(OrderDetail orderDetail, Integer page, Integer limit) {
        try {
            // 查询数据信息
            IPage<OrderDetail> pageResult = orderDetailService.getInfoByPage(orderDetail, page, limit);
            return new ResultMessage(0, "查询成功!", pageResult.getRecords(), pageResult.getTotal());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 插入一条orderDetail信息
     * @param orderDetail
     * @return
     */
    @PostMapping("/insertInfo")
    public ResultMessage insertInfo(@RequestBody OrderDetail orderDetail) {
        return null;
    }

    /**
     * 更新一条orderDetail信息
     * @param orderDetail
     * @return
     */
    @PutMapping("/updateInfo")
    public ResultMessage updateInfo(@RequestBody OrderDetail orderDetail) {
        return null;
    }

    /**
     * 删除一条或多条orderDetail信息
     * @param ids
     * @return
     */
    @GetMapping("/deleteInfo")
    public ResultMessage deleteInfo(String ids) {
        return null;
    }
}

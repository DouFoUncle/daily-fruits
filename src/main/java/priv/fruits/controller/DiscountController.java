package priv.fruits.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.pojo.TDiscount;
import priv.fruits.service.TDiscountService;

/**
 * t_discount表的控制器层
 */
@RequestMapping("discount")
@RestController
public class DiscountController {

    @Autowired
    private TDiscountService discountService;

    /**
     * 分页查询全部数据
     * @param discount
     * @param page
     * @param limit
     * @return
     */
    @GetMapping("/getAllInfoByPage")
    public ResultMessage getAllInfoByPage(TDiscount discount, Integer page, Integer limit) {
        // 查询数据
        try {
            // 调用Service查询方法收到返回的Page对象
            IPage<TDiscount> pageResult = discountService.getInfoByPage(discount, page, limit);
            // 封装数据
            return new ResultMessage(0, "查询成功！", pageResult.getRecords(), pageResult.getTotal());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 修改数据
     */
    @PutMapping("/updateInfo")
    public ResultMessage updateInfo(@RequestBody TDiscount discount) {
        // 查询数据
        try {
            // 调用Service查询方法收到返回的Page对象
            Boolean result = discountService.updateById(discount);
            if(result) {
                // 封装数据
                return new ResultMessage(0, "操作成功！");
            } else {
                // 封装数据
                return new ResultMessage(207, "数据无变化！后台无异常！请稍后再试！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }
}

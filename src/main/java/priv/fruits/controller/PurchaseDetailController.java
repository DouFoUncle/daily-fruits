package priv.fruits.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import priv.fruits.pojo.Purchase;
import priv.fruits.pojo.PurchaseDetail;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.service.PurchaseDetailService;

import java.util.List;
import java.util.Map;

/**
 * t_purchase_detail表的控制器层
 */
@RestController
@RequestMapping("/purchaseDetail")
public class PurchaseDetailController {

    @Autowired
    private PurchaseDetailService purchaseDetailService;

    /**
     * 根据条件分页查询全部数据
     * @param purchaseDetail
     * @param page
     * @param limit
     * @return
     */
    @GetMapping("/getAllInfoByPage")
    public ResultMessage getAllInfoByPage(PurchaseDetail purchaseDetail, Integer page, Integer limit) {
        // 查询数据
        try {
            // 调用Service查询方法收到返回的Page对象
            IPage<PurchaseDetail> pageResult = purchaseDetailService.getInfoByPage(purchaseDetail, page, limit);
            // 封装数据
            return new ResultMessage(0, "查询成功！", pageResult.getRecords(), pageResult.getTotal());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 插入一条purchaseDetail信息
     * @param paramMap
     * @return
     */
    @PostMapping("/insertInfoByGoodsIds")
    public ResultMessage insertInfoByGoodsIds(@RequestBody Map<String, Object> paramMap) {
        try {
            // 调用Service方法
            List<Object> goodsIds = (List<Object>) paramMap.get("goodsIds");
            String purchaseId = paramMap.get("purchaseId") + "";
            Boolean result = purchaseDetailService.insertInfoByGoodsIds(goodsIds, purchaseId);
            if(result) {
                // 封装数据
                return new ResultMessage(0, "操作成功！");
            } else {
                // 封装数据
                return new ResultMessage(207, "数据无变化！后台无异常！请稍后再试！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "操作出现异常：" + e.getMessage());
        }
    }

    /**
     * 更新一条purchaseDetail信息
     * @param purchaseDetail
     * @return
     */
    @PutMapping("/updateInfo")
    public ResultMessage updateInfo(@RequestBody PurchaseDetail purchaseDetail) {
        return null;
    }

    /**
     * 更新一条详情的进货数量
     * @param purchaseDetail    要更新的对象
     * @return
     */
    @PutMapping("/updateCountInfo")
    public ResultMessage updateCountInfo(@RequestBody PurchaseDetail purchaseDetail) {
        try {
            // 调用Service方法
            Boolean result = purchaseDetailService.updateCountInfo(purchaseDetail);
            if(result) {
                // 封装数据
                return new ResultMessage(0, "操作成功！");
            } else {
                // 封装数据
                return new ResultMessage(207, "数据无变化！后台无异常！请稍后再试！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "操作出现异常：" + e.getMessage());
        }
    }

    /**
     * 删除一条或多条purchaseDetail信息
     * @param ids
     * @return
     */
    @GetMapping("/deleteInfo")
    public ResultMessage deleteInfo(String ids) {
        return null;
    }
}

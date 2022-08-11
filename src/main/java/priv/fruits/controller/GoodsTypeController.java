package priv.fruits.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import priv.fruits.pojo.GoodsType;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.service.GoodsTypeService;

import javax.servlet.http.HttpServletRequest;

/**
 * t_goods_type表的控制器层
 */
@RestController
@RequestMapping("/goodsType")
public class GoodsTypeController {

    @Autowired
    private GoodsTypeService goodsTypeService;

    /**
     * 根据条件分页查询全部数据
     * @param goodsType
     * @param page
     * @param limit
     * @return
     */
    @GetMapping("/getAllInfoByPage")
    public ResultMessage getAllInfoByPage(GoodsType goodsType, Integer page, Integer limit) {
        // 查询数据
        try {
            // 调用Service查询方法收到返回的Page对象
            IPage<GoodsType> pageResult = goodsTypeService.getInfoByPage(goodsType, page, limit);
            // 封装数据
            return new ResultMessage(0, "查询成功！", pageResult.getRecords(), pageResult.getTotal());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 插入一条goods信息
     * @param goodsType
     * @return
     */
    @PostMapping("/insertInfo")
    public ResultMessage insertInfo(@RequestBody GoodsType goodsType, HttpServletRequest request) {
        try {
            // 调用Service方法
            Boolean result = goodsTypeService.insertInfo(goodsType);
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
     * 更新一条信息
     * @param goodsType
     * @return
     */
    @PutMapping("/updateInfo")
    public ResultMessage updateInfo(@RequestBody GoodsType goodsType, HttpServletRequest request) {
        try {
            // 调用Service方法
            Boolean result = goodsTypeService.updateInfo(goodsType);
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
     * 删除一条或多条信息
     * @param ids
     * @return
     */
    @GetMapping("/deleteInfo")
    public ResultMessage deleteInfo(String ids) {
        try {
            // 调用Service方法
            Boolean result = goodsTypeService.deleteInfo(ids);
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

}

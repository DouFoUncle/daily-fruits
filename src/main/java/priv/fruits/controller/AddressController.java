package priv.fruits.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import priv.fruits.pojo.Address;
import priv.fruits.pojo.Goods;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.service.AddressService;

import java.util.List;

/**
 * t_address表的控制器层
 */
@RestController
@RequestMapping("/address")
public class AddressController {

    @Autowired
    private AddressService addressService;

    /**
     * 根据条件分页查询全部数据
     * @param address
     * @param page
     * @param limit
     * @return
     */
    @GetMapping("/getAllInfoByPage")
    public ResultMessage getAllInfoByPage(Address address, Integer page, Integer limit) {
        // 查询数据
        try {
            // 调用Service查询方法收到返回的Page对象
            List<Address> addressList = addressService.selectAllInfo(address, page, limit);
            return new ResultMessage(0, "查询成功！", addressList, Long.parseLong(addressService.getAllCount(address) + ""));
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }
}

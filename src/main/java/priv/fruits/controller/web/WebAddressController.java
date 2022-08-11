package priv.fruits.controller.web;

import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import priv.fruits.pojo.Address;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.service.AddressService;
import priv.fruits.util.ServletUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * @Author 冶生华
 * @Description 果蔬超市
 */
@Controller
@RequestMapping("/webAddress")
public class WebAddressController {

    @Autowired
    private AddressService addressService;

    /**
     * 跳转到窗口打开的地址页面
     * @return
     */
    @GetMapping("/toAddressWindowPage")
    public ModelAndView toAddressWindowPage(ModelAndView modelAndView, HttpServletRequest request) {
        modelAndView.addObject("type", "switch");
        modelAndView.setViewName("web/addressWindow");
        return modelAndView;
    }

    /**
     * 跳转到新增地址页面
     * @param modelAndView
     * @param request
     * @return
     */
    @GetMapping("/toAddAddressWindow")
    public ModelAndView toAddAddressWindow(ModelAndView modelAndView, HttpServletRequest request) {
        modelAndView.setViewName("web/windowAddAddress");
        return modelAndView;
    }

    /**
     * 跳转到新增地址页面
     * @param modelAndView
     * @param request
     * @return
     */
    @GetMapping("/toEditAddressWindow")
    public ModelAndView toEditAddressWindow(ModelAndView modelAndView, HttpServletRequest request, Integer id) {
        modelAndView.addObject("addressInfo", addressService.getInfoById(id));
        modelAndView.setViewName("web/windowEditAddress");
        return modelAndView;
    }

    /**
     * 根据登陆的用户获取用户的收货地址
     * @return
     */
    @GetMapping("/getAddressByUserId")
    @ResponseBody
    public ResultMessage getAddressByUserId(HttpServletRequest request, Integer page, Integer limit) {
        try {
            // 查询数据
            IPage<Address> addressList = addressService.getInfoByUserId(page,
                    limit, ServletUtils.getWebUserIdInfo(request));
            return new ResultMessage(0, "查询成功！", addressList.getRecords(), addressList.getTotal());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

    /**
     * 插入一条地址信息
     * @param address
     * @param request
     * @return
     */
    @ResponseBody
    @PostMapping("/insertInfo")
    public ResultMessage insertInfo(@RequestBody Address address, HttpServletRequest request) {
        try {
            // 将用户ID与地址信息绑定
            address.setUserId(ServletUtils.getWebUserIdInfo(request));
            // 拼接完整地址
            String[] provinceNums = address.getProvinceNum().split("\\|");
            String[] cityNums = address.getCityNum().split("\\|");
            String[] countyNums = address.getCountyNum().split("\\|");
            // 重新设置
            address.setProvinceNum(provinceNums[0]);
            address.setCityNum(cityNums[0]);
            address.setCountyNum(countyNums[0]);
            // 拼接地址
            address.setAddressShort(provinceNums[1].trim()+cityNums[1].trim()
                    +countyNums[1].trim()+address.getLocationAddress());
            // 调用业务层方法
            Boolean result = addressService.insertInfo(address);
            if(result) {
                return new ResultMessage(0, "添加成功！");
            } else {
                return new ResultMessage(207, "添加失败！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
    }

    /**
     * 修改地址的默认状态
     * @param address
     * @return
     */
    @PutMapping("/updateDefault")
    @ResponseBody
    public ResultMessage updateDefault(@RequestBody Address address, HttpServletRequest request) {
        try {
            Boolean result = addressService.updateDefault(address, ServletUtils.getWebUserIdInfo(request));
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
     * 修改地址
     * @param address
     * @return
     */
    @PutMapping("/updateInfo")
    @ResponseBody
    public ResultMessage updateInfo(@RequestBody Address address, HttpServletRequest request) {
        try {
            // 将用户ID与地址信息绑定
            address.setUserId(ServletUtils.getWebUserIdInfo(request));
            // 拼接完整地址
            String[] provinceNums = address.getProvinceNum().split("\\|");
            String[] cityNums = address.getCityNum().split("\\|");
            String[] countyNums = address.getCountyNum().split("\\|");
            // 重新设置
            address.setProvinceNum(provinceNums[0]);
            address.setCityNum(cityNums[0]);
            address.setCountyNum(countyNums[0]);
            // 拼接地址
            address.setAddressShort(provinceNums[1].trim()+cityNums[1].trim()
                    +countyNums[1].trim()+address.getLocationAddress());
            // 调用更新方法
            Boolean result = addressService.updateInfo(address);
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
     * 修改地址的默认状态
     * @param id
     * @return
     */
    @GetMapping("/deleteInfo")
    @ResponseBody
    public ResultMessage deleteInfo(Integer id) {
        try {
            // 调用更新方法
            Boolean result = addressService.deleteInfo(id);
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
     * 确定选择收货地址
     * @param address
     * @param session
     * @param request
     */
    @PostMapping("/switchAddress")
    @ResponseBody
    public ResultMessage switchAddress(@RequestBody Address address, HttpSession session, HttpServletRequest request) {
        // 将选择的地址设置在session中
        session.removeAttribute("switchAddress");
        session.setAttribute("switchAddress", address);
        return new ResultMessage(0, "成功！");
    }

    /**
     * 获取用户选择的地址
     * @param session
     * @return
     */
    @GetMapping("/getSwitchAddress")
    @ResponseBody
    public ResultMessage getSwitchAddress(HttpSession session) {
        Address switchAddress = (Address) session.getAttribute("switchAddress");
        session.removeAttribute("switchAddress");
        return new ResultMessage(0, "成功！", switchAddress);
    }

}

package priv.fruits.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.math3.analysis.function.Add;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.mapper.AddressMapper;
import priv.fruits.pojo.Address;
import priv.fruits.pojo.Address;
import priv.fruits.pojo.Admin;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * t_address表的业务层
 */
@Service
public class AddressService extends ServiceImpl<AddressMapper, Address> {

    @Autowired
    private AddressMapper addressMapper;

    /**
     * 分页查询数据
     * @param address
     * @param page
     * @param limit
     * @return
     */
    public List<Address> selectAllInfo(Address address, Integer page, Integer limit) {
        // 开启分页插件
        PageHelper.startPage(page, limit);
        // 查询数据进行分页
        PageInfo<Address> addressPage = new PageInfo<>(addressMapper.selectAllInfo(address));
        return addressPage.getList();
    }

    /**
     * 查询数据总量
     * @param address
     * @return
     */
    public Integer getAllCount(Address address) {
        return addressMapper.selectAllCount(address);
    }

    /**
     * 根据用户ID查询该用户的收货地址列表
     * @param page
     * @param limit
     * @param userId
     * @return
     */
    public IPage<Address> getInfoByUserId(Integer page, Integer limit, Integer userId) {
        QueryWrapper<Address> queryWrapper = new QueryWrapper<Address>().eq("user_id", userId);
        IPage<Address> pageBean = new Page<>(page, limit);
        return addressMapper.selectPage(pageBean, queryWrapper);
    }

    /**
     * 根据用户ID查询该用户的地址总数
     * @return
     */
    public Integer getAddressCountByUserId(Integer userId) {
        return addressMapper.selectCount(new QueryWrapper<Address>().eq("user_id", userId));
    }

    /**
     * 插入一条信息
     * @param address
     * @return
     */
    public Boolean insertInfo(Address address) {
        // 查询该用户是否有地址, 如果没直接设置为默认地址
        Integer addressCount = getAddressCountByUserId(address.getUserId());
        if(addressCount == 0) {
            address.setIsDefault("1");
        } else {
            address.setIsDefault("0");
        }
        return this.save(address);
    }

    /**
     * 更新信息
     * @param address
     * @return
     */
    public Boolean updateInfo(Address address) {
        return this.updateById(address);
    }

    /**
     * 更改地址的默认状态
     * @param address
     * @return
     */
    public Boolean updateDefault(Address address, Integer userId) {
        // 修改前先把该用户的所有的地址更新一遍, 全部更新为不是默认地址
        addressMapper.updateAddressNotDefault(userId);
        // 之后再把指定的地址改为默认地址
        return this.updateById(address);
    }

    /**
     * 根据用户ID查询用户默认地址
     * @param userId
     * @return
     */
    public Address getDefaultInfoByUserId(Integer userId) {
        QueryWrapper<Address> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId);
        queryWrapper.eq("is_default", "1");
        return addressMapper.selectOne(queryWrapper);
    }

    /**
     * 根据ID删除
     * @param id
     * @return
     */
    public Boolean deleteInfo(Integer id) {
        return this.remove(new QueryWrapper<Address>().eq("id", id));
    }

    /**
     * 根据ID查询一条信息
     * @param id
     * @return
     */
    public Address getInfoById(Integer id) {
        return this.getOne(new QueryWrapper<Address>().eq("id", id));
    }
}

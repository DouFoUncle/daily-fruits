package priv.fruits.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import priv.fruits.pojo.Address;

import java.util.List;

/**
 * t_address表的业务层
 */
public interface AddressMapper extends BaseMapper<Address> {

    /**
     * 查询全部信息
     * @param address
     * @return
     */
    List<Address> selectAllInfo(Address address);

    /**
     * 查询数据总数
     * @param address
     * @return
     */
    Integer selectAllCount(Address address);

    /**
     * 根据用户ID将该用户所有的地址更新为不是默认地址
     * @param userId
     * @return
     */
    Integer updateAddressNotDefault(Integer userId);
}
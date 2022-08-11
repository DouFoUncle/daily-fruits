package priv.fruits.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.mapper.TDiscountMapper;
import priv.fruits.pojo.TDiscount;

@Service
public class TDiscountService extends ServiceImpl<TDiscountMapper, TDiscount> {

    @Autowired
    private TDiscountMapper discountMapper;

    // 分页查询信息
    public IPage<TDiscount> getInfoByPage(TDiscount discount, Integer page, Integer limit) {
        IPage<TDiscount> pageBean = new Page<>(page, limit);
        // 调用查询方法
        return discountMapper.selectPage(pageBean, null);
    }
}

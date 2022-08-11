package priv.fruits.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.mapper.SaleMapper;
import priv.fruits.pojo.Goods;
import priv.fruits.pojo.Sale;

import java.util.List;
import java.util.Map;

/**
 * t_sale表的业务层
 */
@Service
public class SaleService extends ServiceImpl<SaleMapper, Sale> {

    @Autowired
    private SaleMapper saleMapper;

    /**
     * 分页查询数据
     * @param sale
     * @param page
     * @param limit
     * @return
     */
    public IPage<Sale> getInfoByPage(Sale sale, String start, String end, Integer page, Integer limit) {
        // 创建MyBatisPlus的Page类，该类用于封装分页信息
        // 这里使用了构造器来创建Page，传入两个参数  第一个表示当前页，第二个表示每页展示的数量
        IPage<Sale> pageBean = new Page<>(page, limit);
        // 封装查询条件
        QueryWrapper<Sale> queryWrapper = new QueryWrapper<>();
        // 判断查询字段是否为空， 不为空则拼接查询条件
        queryWrapper.eq(!StrUtil.isBlankOrUndefined(sale.getSaleTypeFlag()), "sale_type_flag", sale.getSaleTypeFlag());
        queryWrapper.le(!StrUtil.isBlankOrUndefined(end), "DATE(sale_date)", end);
        queryWrapper.ge(!StrUtil.isBlankOrUndefined(start), "DATE(sale_date)", start);
        // 调用Service层中MyBatisPlus已经实现好的查询方法（page方法就是分页查询的方法）
        // 会返回一个Page对象
        return saleMapper.selectPage(pageBean, queryWrapper);
    }

    /**
     * 根据时间区间和销售类型查询数据
     * @param startTime     开始时间
     * @param endTime       结束时间
     * @param flag          销售类型
     * @return              返回查询结果的集合
     */
    public List<Map<String, Object>> getAllInfoByDateAndTypeFlag(String startTime, String endTime, String flag) {
        return saleMapper.getAllInfoByDateAndFlag(startTime, endTime, flag);
    }
}

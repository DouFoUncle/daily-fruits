package priv.fruits.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.mapper.OrderDetailMapper;
import priv.fruits.pojo.Order;
import priv.fruits.pojo.OrderDetail;
import priv.fruits.pojo.OrderDetail;

import java.util.List;

/**
 * t_order_detail表的业务层
 */
@Service
public class OrderDetailService extends ServiceImpl<OrderDetailMapper, OrderDetail> {

    @Autowired
    private OrderDetailMapper orderDetailMapper;
    
    /**
     * 分页查询数据
     * @param orderDetail
     * @param page
     * @param limit
     * @return
     */
    public IPage<OrderDetail> getInfoByPage(OrderDetail orderDetail, Integer page, Integer limit) {
        // 创建MyBatisPlus的Page类，该类用于封装分页信息
        // 这里使用了构造器来创建Page，传入两个参数  第一个表示当前页，第二个表示每页展示的数量
        IPage<OrderDetail> pageBean = new Page<>(page, limit);
        // 封装查询条件
        QueryWrapper<OrderDetail> queryWrapper = new QueryWrapper<>();
        // 判断查询字段是否为空， 不为空则拼接查询条件
        queryWrapper.eq(!StrUtil.isBlank(orderDetail.getOrderId()+""),"order_id", orderDetail.getOrderId());
        // 调用Service层中MyBatisPlus已经实现好的查询方法（page方法就是分页查询的方法）
        // 会返回一个Page对象
        IPage<OrderDetail> resultPage = orderDetailMapper.selectPage(pageBean, queryWrapper);
        return resultPage;
    }

    /**
     * 插入信息
     * @param orderDetailList
     * @return
     */
    public Boolean insertDataList(List<OrderDetail> orderDetailList) {
        return this.saveBatch(orderDetailList);
    }

    /**
     * 根据商品ID更新商品名
     * @param goodsId
     * @param goodsName
     */
    public Boolean updateGoodsNameByGoodsId(Integer goodsId, String goodsName) {
        return orderDetailMapper.updateGoodsNameByGoodsId(goodsId, goodsName) >= 0;
    }
}

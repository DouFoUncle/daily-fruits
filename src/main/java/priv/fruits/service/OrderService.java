package priv.fruits.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.pojo.*;
import priv.fruits.mapper.OrderMapper;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * t_order表的业务层
 */
@Service
public class OrderService extends ServiceImpl<OrderMapper, Order> {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private CartService cartService;

    @Autowired
    private OrderDetailService orderDetailService;

    @Autowired
    private SaleService saleService;

    @Autowired
    private GoodsService goodsService;

    /**
     * 分页查询数据
     * @param order
     * @param page
     * @param limit
     * @return
     */
    public IPage<Order> getInfoByPage(Order order, String start, String end, Integer page, Integer limit) {
        // 创建MyBatisPlus的Page类，该类用于封装分页信息
        // 这里使用了构造器来创建Page，传入两个参数  第一个表示当前页，第二个表示每页展示的数量
        IPage<Order> pageBean = new Page<>(page, limit);
        // 封装查询条件
        QueryWrapper<Order> queryWrapper = new QueryWrapper<>();
        // 判断查询字段是否为空， 不为空则拼接查询条件
        // like方法等于使用 MySQL 的Like查询 也就是模糊查询
        queryWrapper.eq(!StrUtil.isBlankOrUndefined(order.getOrderNum()),"order_num", order.getOrderNum());
        queryWrapper.eq(!StrUtil.isBlankOrUndefined(order.getUserId()+""),"user_id", order.getUserId());
        // eq方法等于使用 MySQL 的 = 查询 也就是等值查询
        queryWrapper.ge(!StrUtil.isBlankOrUndefined(start),"DATE(create_date)", start);
        queryWrapper.le(!StrUtil.isBlankOrUndefined(end),"DATE(create_date)", end);
        queryWrapper.orderByDesc("create_date");
        // 调用Service层中MyBatisPlus已经实现好的查询方法（page方法就是分页查询的方法）
        // 会返回一个Page对象
        IPage<Order> resultPage = orderMapper.selectPage(pageBean, queryWrapper);
        return resultPage;
    }

    /**
     * 插入一条订单, 根据用户购物车信息全部插入
     * 同时清空购物车
     * @param address
     * @param user
     * @return
     */
    public Boolean insertOrderAndClearCart(Address address, User user) {
        // 查询购物车信息
        List<Cart> cartInfoByUserId = cartService.getCartInfoByUserId(user.getId());
        // 购物车详情的数据
        List<OrderDetail> orderDetails = new ArrayList<>(16);
        // 商品ID
        List<Object> goodsIds = new ArrayList<>(16);
        // 总价
        Integer totalPrice = 0;
        for (Cart cart : cartInfoByUserId) {
            if(cart.getDisPrice() != null) {
                totalPrice += cart.getDisTotal();
            } else {
                totalPrice += cart.getGoodsTotal();
            }

        }
        // 首先插入一条订单信息
        Order order = new Order();
        order.setAddressId(address.getId());
        order.setAddressJsonStr(JSON.toJSONString(address));
        order.setAddressName(address.getAddressName());
        order.setCreateDate(DateUtil.now());
        order.setOrderNum(DateUtil.format(new Date(), "yyyyMMddHHmmss") + totalPrice);
        order.setOrderPrice(totalPrice);
        order.setUserId(user.getId());
        order.setUserNickName(user.getNickName());
        // 插入一条信息
        int insertOrder = orderMapper.insert(order);
        // 循环创建订单详情
        for (Cart cart : cartInfoByUserId) {
            OrderDetail orderDetail = new OrderDetail();
            orderDetail.setGoodsId(cart.getGoodsId());
            orderDetail.setGoodsName(cart.getGoodsName());
            orderDetail.setOrderId(order.getId());
            orderDetail.setTotalPrice(cart.getDisPrice() != null ? cart.getDisTotal() : cart.getGoodsTotal());
            orderDetail.setGoodsPrice(cart.getDisPrice() != null ? cart.getDisPrice() : cart.getGoodsPrice());
            orderDetail.setGoodsNum(cart.getGoodsCount());
            orderDetails.add(orderDetail);
            goodsIds.add(cart.getGoodsId());
        }
        // 查询下单的商品, 之后修改商品库存
        List<Goods> goodsList = goodsService.getInfoByIds(goodsIds);
        // 循环扣掉库存
        for (Goods goods : goodsList) {
            for (Cart cart : cartInfoByUserId) {
                if(cart.getGoodsId().equals(goods.getId())) {
                    goods.setGoodsStock(goods.getGoodsStock() - cart.getGoodsCount());
                }
            }
        }
        // 更新商品库存信息
        Boolean updateGoods = goodsService.updateInfos(goodsList);
        // 插入订单详情
        Boolean insertOrderDetail = orderDetailService.insertDataList(orderDetails);
        boolean insertSale = saleService.save(new Sale("销售", "1",
                                                             order.getOrderPrice()));
        // 清空购物车
        Boolean deleteCart = cartService.deleteInfoByUserId(user.getId());
        if(insertOrderDetail && insertSale && insertOrder > 0 && deleteCart && updateGoods) {
            return true;
        } else {
            throw new RuntimeException("插入失败！回滚数据！");
        }
    }
}

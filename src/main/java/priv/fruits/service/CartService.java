package priv.fruits.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.pojo.Cart;
import priv.fruits.mapper.CartMapper;
import priv.fruits.pojo.Goods;

/**
 * @Author 冶生华
 * @Date 2022/2/23
 * @Description 下一位读我代码的人,有任何疑问请联系我,QQ：943701114
 */
@Service
public class CartService extends ServiceImpl<CartMapper, Cart> {

    @Autowired
    private CartMapper cartMapper;

    /**
     * 根据用户ID查询用户的购物车信息
     * @param userId
     * @return
     */
    public List<Cart> getCartInfoByUserId(Integer userId) {
        return cartMapper.getCartInfoByUserId(userId);
    }

    /**
     * 根据传入的用户ID和商品ID进行查询单条
     * @param goodsId
     * @param userId
     * @return
     */
    public Cart getCartInfoByGoodsIdAndUserId(Integer goodsId, Integer userId) {
        return cartMapper.selectInfoByParams(goodsId, userId);
    }

    /**
     * 向购物车添加一条信息
     * @param goods 要添加的商品信息
     * @param count 要添加的数量
     * @param isAddOrUpdate  标识本次是更新还是删除
     * @return boolean
     */
    public Integer insertInfo(Goods goods, Integer count, Integer userId, Boolean isAddOrUpdate, Cart selectCartInfo) {
        // 判断是否存在
        if(isAddOrUpdate) {
            // 不存在, 新增一条到购物车
            Cart cart = new Cart();
            cart.setGoodsPrice(goods.getGoodsPrice());
            cart.setGoodsTotal(goods.getGoodsPrice() * count);
            cart.setGoodsCount(count);
            cart.setGoodsHeadImg(goods.getGoodsHeadImg());
            cart.setUserId(userId);
            cart.setGoodsName(goods.getGoodsName());
            cart.setGoodsId(goods.getId());
            // 调用MyBatisPlus生成的保存方法
            return cartMapper.insert(cart);
        } else {
            if(selectCartInfo == null) {
                return -200;
            }
            // 已存在首先判断 新加入的数量 + 原有数量是否大于库存
            Integer goodsCount = selectCartInfo.getGoodsCount();
            Integer newCount = goodsCount + count;
            // 判断是否超出库存
            if(newCount > selectCartInfo.getGoodsStock()) {
                // 库存过大！
                return -500;
            }
            // 已存在, 将已存在的商品数量和小计进行更新
            selectCartInfo.setGoodsCount(selectCartInfo.getGoodsCount() + count);
            selectCartInfo.setGoodsTotal(selectCartInfo.getGoodsCount() * goods.getGoodsPrice());
            return cartMapper.updateById(selectCartInfo);
        }
    }

    /**
     * 更新购物车数量信息
     * @return boolean
     */
    public Boolean updateCartCount(Cart cart) {
        return this.updateById(cart);
    }

    /**
     * 删除购物车信息
     * @param id 要删除的信息的ID
     * @return boolean
     */
    public Boolean deleteCartInfo(Integer id) {
        int deleteResult = cartMapper.delete(new QueryWrapper<Cart>().eq("id", id));
        return deleteResult > 0;
    }

    /**
     * 根据用户ID获取该用户购物车的总记录数
     * @param userId
     * @return
     */
    public Integer getCartCountByUserId(Integer userId) {
        return cartMapper.selectCount(new QueryWrapper<Cart>().eq("user_id", userId));
    }

    /**
     * 根据用户ID查询该用户购物车中商品的总价
     * @param userId
     * @return
     */
    public Integer getCartTotalPriceByUserId(Integer userId) {
        Map<String, Integer> cartTotalPriceMap = cartMapper.getCartTotalPriceByUserId(userId);
        if(cartTotalPriceMap.get("disTotal") != null) {
            return cartTotalPriceMap.get("disTotal");
        }
        return cartTotalPriceMap.get("goodsTotal");
    }

    /**
     * 根据用户ID删除购物车信息
     * @param userId
     * @return
     */
    public Boolean deleteInfoByUserId(Integer userId) {
        return this.remove(new QueryWrapper<Cart>().eq("user_id", userId));
    }

    /**
     * 根据商品ID更新商品名
     * @param goodsId
     * @param goodsName
     */
    public Boolean updateGoodsNameByGoodsId(Integer goodsId, String goodsName) {
        return cartMapper.updateGoodsNameByGoodsId(goodsId, goodsName) >= 0;
    }
}

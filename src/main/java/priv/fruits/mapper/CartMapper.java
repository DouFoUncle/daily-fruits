package priv.fruits.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import priv.fruits.pojo.Cart;

import java.util.List;
import java.util.Map;

/**
 * @Author 冶生华
 * @Date 2022/2/23
 * @Description 下一位读我代码的人,有任何疑问请联系我,QQ：943701114
 */
public interface CartMapper extends BaseMapper<Cart> {

    /**
     * 根据用户ID查询购物车信息
     * @param userId
     * @return
     */
    List<Cart> getCartInfoByUserId(Integer userId);

    /**
     * 根据用户ID查询该用户购物车中商品的总价
     * @param userId
     * @return
     */
    Map<String, Integer> getCartTotalPriceByUserId(Integer userId);

    /**
     * 根据传入的参数查询一条信息
     * @param goodsId
     * @param userId
     * @return
     */
    Cart selectInfoByParams(@Param("goodsId") Integer goodsId, @Param("userId") Integer userId);

    /**
     * 根据商品ID更新商品名
     * @param goodsId
     * @param goodsName
     * @return
     */
    Integer updateGoodsNameByGoodsId(@Param("goodsId") Integer goodsId, @Param("goodsName") String goodsName);
}
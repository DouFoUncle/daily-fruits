package priv.fruits.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import priv.fruits.pojo.PurchaseDetail;

/**
 * t_purchase_detail表的业务层
 */
public interface PurchaseDetailMapper extends BaseMapper<PurchaseDetail> {

    /**
     * 根据商品ID更新商品名
     * @param goodsId
     * @param goodsName
     * @return
     */
    Integer updateGoodsNameByGoodsId(@Param("goodsId") Integer goodsId, @Param("goodsName") String goodsName);
}
package priv.fruits.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import priv.fruits.pojo.Goods;

import java.util.List;

/**
 * t_goods表的业务层
 */
public interface GoodsMapper extends BaseMapper<Goods> {

    /**
     * 查询商品列表
     * @return
     */
    List<Goods> selectGoodsList(Goods goods);

    /**
     * 查询商品列表
     * @return
     */
    Goods selectInfoById(String id);

    /**
     * 更新商品库存
     * @param goods
     * @return
     */
    Integer updateStock(Goods goods);

    /**
     * 根据类型ID修改类型名
     * @param id
     * @param typeName
     * @return
     */
    Integer updateTypeNameByTypeId(@Param("typeId") Integer id, @Param("typeName") String typeName);
}
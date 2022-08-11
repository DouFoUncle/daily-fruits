package priv.fruits.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import priv.fruits.pojo.GoodsType;

import java.util.List;

/**
 * @Author 冶生华
 * @Date 2022/2/18
 * @Description 下一位读我代码的人,有任何疑问请联系我,QQ：943701114
 * 商品类型表的Mapper
 */
public interface GoodsTypeMapper extends BaseMapper<GoodsType> {

    /**
     * 查询所有类型信息, 以及按照每种类型下有多少商品分类好
     */
    List<GoodsType> getTypeInfoByGroup();
}
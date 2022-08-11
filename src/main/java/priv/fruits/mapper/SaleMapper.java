package priv.fruits.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import priv.fruits.pojo.Sale;

import java.util.List;
import java.util.Map;

/**
 * t_sale表的业务层
 */
public interface SaleMapper extends BaseMapper<Sale> {

    /**
     * 根据时间区间查询数据
     * @param startTime
     * @param endTime
     * @return
     */
    List<Map<String, Object>> getAllInfoByDateAndFlag(@Param("startTime") String startTime,
                                                      @Param("endTime") String endTime,
                                                      @Param("flag") String flag);
}
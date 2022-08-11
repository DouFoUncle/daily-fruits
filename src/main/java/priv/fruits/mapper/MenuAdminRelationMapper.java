package priv.fruits.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import priv.fruits.pojo.MenuAdminRelation;

import java.util.List;

/**
 * t_menu_admin_relation表的业务层
 */
@Mapper
public interface MenuAdminRelationMapper extends BaseMapper<MenuAdminRelation> {

    List<MenuAdminRelation> getMenuInfoByUserId(String userId);

}
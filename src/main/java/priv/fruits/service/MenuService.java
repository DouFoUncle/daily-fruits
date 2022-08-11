package priv.fruits.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.mapper.MenuMapper;
import priv.fruits.pojo.Menu;

import java.util.List;

@Service
public class MenuService extends ServiceImpl<MenuMapper, Menu> {

    @Autowired
    private MenuMapper menuMapper;

    /**
     * 获取全部菜单信息
     * @return
     */
    public List<Menu> getAllInfo() {
        return menuMapper.selectList(null);
    }
}

package priv.fruits.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.pojo.Goods;
import priv.fruits.pojo.GoodsType;
import priv.fruits.mapper.GoodsTypeMapper;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author 冶生华
 * @Date 2022/2/18
 * @Description 下一位读我代码的人,有任何疑问请联系我,QQ：943701114
 * 商品类型表的Service
 */
@Service
public class GoodsTypeService extends ServiceImpl<GoodsTypeMapper, GoodsType> {

    @Autowired
    private GoodsTypeMapper goodsTypeMapper;

    @Autowired
    private GoodsService goodsService;

    /**
     * 全量获取所有商品类型
     * @return
     */
    public List<GoodsType> getAllTypeInfo() {
        // 查询所有没有被删除的信息
        return goodsTypeMapper.selectList(new QueryWrapper<GoodsType>().eq("is_delete", "0"));
    }

    /**
     * 根据分页信息和筛选信息获取类型数据
     * @return
     */
    public Page<GoodsType> getInfoByPage(GoodsType goodsType, Integer page, Integer limit) {
        // 使用分页信息
        Page<GoodsType> pageBean = new Page<>(page, limit);
        // 封装好查询条件
        QueryWrapper<GoodsType> queryWrapper = new QueryWrapper<>();
        queryWrapper.like(!StrUtil.isBlankOrUndefined(goodsType.getTypeName()), "type_name", goodsType.getTypeName());
        // 查询未被删除的信息, is_delete 字段 0代表未删除  1代表已删除
        queryWrapper.eq("is_delete", "0");
        // 执行查询
        return goodsTypeMapper.selectPage(pageBean, queryWrapper);
    }

    /**
     * 修改类型信息
     * @return
     */
    public Boolean updateInfo(GoodsType goodsType) {
        // id不可以为空
        if(StrUtil.isBlankOrUndefined(goodsType.getId()+"")) {
            return false;
        }
        // 修改相关信息
        goodsService.updateTypeNameByTypeId(goodsType.getId(), goodsType.getTypeName());
        // 执行修改
        return this.updateById(goodsType);
    }

    /**
     * 新增信息
     * @return
     */
    public Boolean insertInfo(GoodsType goodsType) {
        // 赋初始值
        goodsType.setIsDelete("0");
        goodsType.setCreateDate(DateUtil.now());
        return this.save(goodsType);
    }

    /**
     * 删除或批量删除类型信息
     * 将is_delete字段改为1即可
     * @param ids
     * @return
     */
    public Boolean deleteInfo(String ids) {
        List<GoodsType> updateBeans = new ArrayList<>(16);
        List<String> idList = new ArrayList<>(16);
        // 首先分割id
        if(StrUtil.indexOf(ids, ',') == -1) {
            // 查找分隔符号返回 -1 代表只有一个无需进行分割
            idList.add(ids);
        } else {
            // 不等于-1, 代表要删除多个, 需要将ID分割
            idList = StrUtil.split(ids, ',');
        }
        // 循环封装好要删除的数据
        idList.forEach(item -> {
            GoodsType goodsType = new GoodsType();
            goodsType.setId(Integer.parseInt(item));
            goodsType.setIsDelete("1");
            updateBeans.add(goodsType);
        });
        return this.updateBatchById(updateBeans);
    }

    /**
     * 查询所有类型信息, 以及按照每种类型下有多少商品分类好
     * @return
     */
    public List<GoodsType> getTypeInfoByGroup() {
        return goodsTypeMapper.getTypeInfoByGroup();
    }
}

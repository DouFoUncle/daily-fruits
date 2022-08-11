package priv.fruits.service;

import cn.hutool.core.text.StrSpliter;
import cn.hutool.core.util.StrUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.mapper.GoodsMapper;
import priv.fruits.pojo.Goods;
import priv.fruits.pojo.Goods;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

/**
 * t_goods表的业务层
 */
@Service
public class GoodsService extends ServiceImpl<GoodsMapper, Goods> {

    @Autowired
    private GoodsMapper goodsMapper;

    @Autowired
    private PurchaseDetailService purchaseDetailService;

    @Autowired
    private CartService cartService;

    @Autowired
    private OrderDetailService orderDetailService;

    /**
     * 分页查询数据
     * @param goods
     * @param page
     * @param limit
     * @return
     */
    public PageInfo<Goods> getInfoByPage(Goods goods, Integer page, Integer limit) {
        // 开启分页查询
        PageHelper.startPage(page, limit);
        // 调用查询方法
        return new PageInfo<Goods>(goodsMapper.selectGoodsList(goods));
    }

    /**
     * 获取全部商品信息
     * @return
     */
    public List<Goods> getGodsAllInfo(Goods goods) {
        QueryWrapper<Goods> queryWrapper = new QueryWrapper<>();
        // 根据是否上架查询
        queryWrapper.eq(!StrUtil.isBlankOrUndefined(goods.getGoodsStatus()), "goods_status", goods.getGoodsStatus());
        return goodsMapper.selectList(queryWrapper);
    }

    /**
     * 根据多个ID获取所有商品, 如果不传入ID则查询全部
     * @param ids 多个ID
     * @return
     */
    public List<Goods> getAllInfo(String ids) {
        QueryWrapper<Goods> queryWrapper = new QueryWrapper<>();
        queryWrapper.in(!StrUtil.isBlankOrUndefined(ids), "id", StrSpliter.split(ids, ",", -1, true, true));
        return goodsMapper.selectList(queryWrapper);
    }

    /**
     * 根据主键ID查询信息
     * @param id
     * @return
     */
    public Goods getInfoById(String id) {
        return goodsMapper.selectInfoById(id);
    }

    /**
     * 插入一条数据
     * @param goods
     * @return
     */
    public Integer insertInfo(Goods goods) {
        return goodsMapper.insert(goods);
    }

    /**
     * 更新一条信息
     * @param goods
     * @return
     */
    public Integer updateInfo(Goods goods) {
        // 修改时,将其他相关信息全部修改
        // 购物车的商品名
        cartService.updateGoodsNameByGoodsId(goods.getId(), goods.getGoodsName());
        // 订单详情中的商品名
        orderDetailService.updateGoodsNameByGoodsId(goods.getId(), goods.getGoodsName());
        // 货单详情中的商品名
        purchaseDetailService.updateGoodsNameByGoodsId(goods.getId(), goods.getGoodsName());
        return goodsMapper.updateById(goods);
    }

    /**
     * 删除一条或多条信息 (逻辑删除)
     * @param ids
     * @return
     */
    public Boolean deleteInfo(String ids) {
        // 使用Hutool的StrSpliter工具类将收到的多个ID进行分割, 分割后返回一个List
        List<String> split = StrSpliter.split(ids, ',', -1, true, true);
        // 保存所有要删除的商品信息
        List<Goods> deleteList = new ArrayList<>(16);
        for (String s : split) {
            Goods goods = new Goods();
            goods.setId(Integer.parseInt(s));
            // 设置逻辑删除  1是  0否
            goods.setIsDelete("1");
            // 同时设置Goods状态, 0下架   1上架
            goods.setGoodsStatus("0");
            // 封装起来
            deleteList.add(goods);
        }
        // 调用批量更新方法
        return this.updateBatchById(deleteList);
    }

    /**
     * 更新商品库存
     * @param goods
     * @return
     */
    public Integer updateStock(Goods goods) {
        return goodsMapper.updateStock(goods);
    }

    /**
     * 更新多个商品信息
     * @param goods
     * @return
     */
    public Boolean updateInfos(List<Goods> goods) {
        return this.updateBatchById(goods);
    }

    /**
     * 根据多个商品ID查询商品信息
     * @param goodsIds
     * @return
     */
    public List<Goods> getInfoByIds(List<Object> goodsIds) {
        QueryWrapper<Goods> queryWrapper = new QueryWrapper<>();
        queryWrapper.in("id", goodsIds);
        return goodsMapper.selectList(queryWrapper);
    }

    /**
     * 更新商品信息为上架或下架
     * @param goodsIds
     * @param status
     * @return
     */
    public Boolean updateInfoStatus(List<Object> goodsIds, String status) {
        // 查询商品信息
        List<Goods> goodsList = goodsMapper.selectList(new QueryWrapper<Goods>().in("id", goodsIds));
        // 将所有查到的信息改为指定状态
        goodsList.forEach(item -> {
            item.setGoodsStatus(status);
        });
        return this.updateBatchById(goodsList);
    }

    /**
     * 插入Excel读取的商品信息
     * @param goodsList
     * @return
     */
    public Boolean insertExcelInfo(List<Goods> goodsList) {
        return this.saveBatch(goodsList);
    }

    /**
     * 根据类型ID修改类型名
     * @param id
     * @return
     */
    public Boolean updateTypeNameByTypeId(Integer id, String typeName) {
        return goodsMapper.updateTypeNameByTypeId(id, typeName) >= 0;
    }
}

package priv.fruits.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import priv.fruits.mapper.PurchaseMapper;
import priv.fruits.pojo.Goods;
import priv.fruits.pojo.Purchase;
import priv.fruits.pojo.PurchaseDetail;
import priv.fruits.mapper.PurchaseDetailMapper;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * t_purchase_detail表的业务层
 */
@Service
public class PurchaseDetailService extends ServiceImpl<PurchaseDetailMapper, PurchaseDetail> {

    @Autowired
    private PurchaseDetailMapper purchaseDetailMapper;

    @Autowired
    private GoodsService goodsService;

    @Autowired
    private PurchaseService purchaseService;

    /**
     * 分页查询数据
     * @param purchaseDetail
     * @param page
     * @param limit
     * @return
     */
    public IPage<PurchaseDetail> getInfoByPage(PurchaseDetail purchaseDetail, Integer page, Integer limit) {
        // 创建MyBatisPlus的Page类，该类用于封装分页信息
        // 这里使用了构造器来创建Page，传入两个参数  第一个表示当前页，第二个表示每页展示的数量
        IPage<PurchaseDetail> pageBean = new Page<>(page, limit);
        // 封装查询条件
        QueryWrapper<PurchaseDetail> queryWrapper = new QueryWrapper<>();
        // 判断查询字段是否为空， 不为空则拼接查询条件
        // eq方法等于使用 MySQL 的 = 查询 也就是等值查询
        queryWrapper.eq(!StrUtil.isBlank(purchaseDetail.getPurchaseId()+""),"purchase_id", purchaseDetail.getPurchaseId());
        // 调用Service层中MyBatisPlus已经实现好的查询方法（page方法就是分页查询的方法）
        // 会返回一个Page对象
        IPage<PurchaseDetail> resultPage = purchaseDetailMapper.selectPage(pageBean, queryWrapper);
        return resultPage;
    }

    /**
     * 根据货单ID查询详情信息
     * @param purchaseId
     * @return
     */
    public List<PurchaseDetail> getInfoByPurchaseId(String purchaseId) {
        QueryWrapper<PurchaseDetail> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(!StrUtil.isBlankOrUndefined(purchaseId), "purchase_id", purchaseId);
        return purchaseDetailMapper.selectList(queryWrapper);
    }

    /**
     * 更新一条详情的进货数量
     * @param purchaseDetail
     * @return
     */
    public Boolean updateCountInfo(PurchaseDetail purchaseDetail) {
        // 重新计算小计
        purchaseDetail.setTotalPrice(purchaseDetail.getPurchasePrice() * purchaseDetail.getCount());
        boolean updateCount = this.updateById(purchaseDetail);
        // 更新货单信息
        return purchaseService.updatePurchasePrice(purchaseDetail.getPurchaseId()) && updateCount;
    }

    /**
     * 插入一条货单详情信息, 如果该货单详情已存在则跳过
     * @param ids
     * @return
     */
    public Boolean insertInfoByGoodsIds(List<Object> ids, String purchaseId) {
        // 首先查询出该货单下本身就存在的商品ID, 已存在的商品ID进行跳过
        // 但是如果这个ID原本存在在货单中, 但是这次新增的ids不存在了, 则代表需要将其删除
        List<PurchaseDetail> oldDetailList = this.getInfoByPurchaseId(purchaseId);
        // 循环处理, 不存在则将oldDetailList中的记录删除, 存在则将ids中的记录remove
        Iterator<Object> iterator = ids.iterator();
        // 首先将之前的货单信息处理干净
        for (PurchaseDetail purchaseDetail : oldDetailList) {
            // 标记是否存在
            boolean flag = false;
            while (iterator.hasNext()) {
                Object id = iterator.next();
                // 相等代表存在, 则从ids中移除
                if(id.equals(purchaseDetail.getGoodsId()+"")) {
                    flag = true;
                    iterator.remove();
                    break;
                } else {
                    flag = false;
                }
            }
            // ids循环一遍后判断flag, 如果是false代表不存在, 则将该条记录删除
            if(!flag) {
                purchaseDetailMapper.delete(new QueryWrapper<PurchaseDetail>().eq("id", purchaseDetail.getId()));
            }
        }
        if(ids.size() == 0) {
            return true;
        }
        // 循环插入货单信息
        List<Goods> goodsList = goodsService.getInfoByIds(ids);
        List<PurchaseDetail> insertInfos = new ArrayList<>(16);
        for (Goods goods : goodsList) {
            PurchaseDetail purchaseDetail = new PurchaseDetail();
            purchaseDetail.setGoodsId(goods.getId());
            purchaseDetail.setGoodsName(goods.getGoodsName());
            purchaseDetail.setPurchaseDate(DateUtil.now());
            purchaseDetail.setTotalPrice(0);
            purchaseDetail.setCount(0);
            purchaseDetail.setPurchaseId(Integer.parseInt(purchaseId));
            purchaseDetail.setPurchasePrice(goods.getGoodsCostPrice());
            insertInfos.add(purchaseDetail);
        }
        // 插入后再更新货单价格
        return this.saveBatch(insertInfos) && purchaseService.updatePurchasePrice(purchaseId);
    }

    /**
     * 根据商品ID更新商品名
     * @param goodsId
     * @param goodsName
     */
    public Boolean updateGoodsNameByGoodsId(Integer goodsId, String goodsName) {
        return purchaseDetailMapper.updateGoodsNameByGoodsId(goodsId, goodsName) >= 0;
    }
}

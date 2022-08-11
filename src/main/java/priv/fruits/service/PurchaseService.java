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
import priv.fruits.pojo.Sale;

import java.util.List;

/**
 * t_purchase表的业务层
 */
@Service
public class PurchaseService extends ServiceImpl<PurchaseMapper, Purchase> {

    @Autowired
    private PurchaseMapper purchaseMapper;

    @Autowired
    private PurchaseDetailService purchaseDetailService;

    @Autowired
    private GoodsService goodsService;

    @Autowired
    private SaleService saleService;

    /**
     * 分页查询数据
     * @param purchase
     * @param page
     * @param limit
     * @return
     */
    public IPage<Purchase> getInfoByPage(Purchase purchase, Integer page, Integer limit) {
        // 创建MyBatisPlus的Page类，该类用于封装分页信息
        // 这里使用了构造器来创建Page，传入两个参数  第一个表示当前页，第二个表示每页展示的数量
        IPage<Purchase> pageBean = new Page<>(page, limit);
        // 封装查询条件
        QueryWrapper<Purchase> queryWrapper = new QueryWrapper<>();
        // 判断查询字段是否为空， 不为空则拼接查询条件
        // eq方法等于使用 MySQL 的 = 查询 也就是等值查询
        queryWrapper.eq(!StrUtil.isBlank(purchase.getPurchaseNum()),"purchase_num", purchase.getPurchaseNum());
        queryWrapper.eq(!StrUtil.isBlank(purchase.getPurchaseStatus()),"purchase_status", purchase.getPurchaseStatus());
        queryWrapper.orderByAsc("purchase_status");
        queryWrapper.orderByDesc("create_date");
        // 调用Service层中MyBatisPlus已经实现好的查询方法（page方法就是分页查询的方法）
        // 会返回一个Page对象
        IPage<Purchase> resultPage = purchaseMapper.selectPage(pageBean, queryWrapper);
        return resultPage;
    }

    /**
     * 更新一条数据(选择性更新)
     * 更新时的 purchase 对象只用填写要更新的字段, 其他不更新的字段填null即可
     * @param purchase  要更新的对象
     * @return  返回结果(数据库受影响行数)
     */
    public Integer updateInfo(Purchase purchase) {
        switch(purchase.getPurchaseStatus()) {
            case "0":
                // 设置确认订单时间为当前时间
                purchase.setPurchaseDate(DateUtil.now());
                break;
            case "3":
                // 设置取消订单时间为当前时间
                purchase.setCancelDate(DateUtil.now());
                break;
        }
        return purchaseMapper.updateById(purchase);
    }

    /**
     * 新增一条数据
     * @param purchase  新增的运单信息
     * @param purchaseDetailList    该运单信息下的详细信息
     * @return  返回新增后的结果(数据库受影响行数)
     */
    public Boolean insertInfo(Purchase purchase, List<PurchaseDetail> purchaseDetailList) {
        // 首先插入运单信息
        purchaseMapper.insert(purchase);
        // 拿到返回的ID后重新处理 存放详细信息的List集合, 将运单的ID绑定到集合中
        purchaseDetailList.forEach(item -> {
            item.setPurchaseId(purchase.getId());
        });
        // 插入运单详情
        return purchaseDetailService.saveBatch(purchaseDetailList);
    }

    /**
     * 更新货单为已收货同时更新商品库存和新增一条支出的报表记录
     * @param purchase
     * @return
     */
    public Boolean updateInfoAndGoodsStock(Purchase purchase) {
        // 查询该条订单的详情, 为货单包含的所有商品增加库存
        List<PurchaseDetail> detailList = purchaseDetailService.getInfoByPurchaseId(purchase.getId() + "");
        // 循环为商品加库存
        detailList.forEach(item -> {
            Goods goods = new Goods();
            goods.setId(item.getGoodsId());
            goods.setGoodsStock(item.getCount());
            goodsService.updateStock(goods);
        });
        // 设置确认收货时间为当前时间
        purchase.setConfirmDate(DateUtil.now());
        // 创建一条支出的报表记录
        Sale sale = new Sale("进货", "0", purchase.getPurchasePrice());
        // 更新货单信息, 同时新增一条支出记录
        return this.updateById(purchase) && saleService.save(sale);
    }

    /**
     * 重新计算货单价格
     * @param purchaseId
     * @return
     */
    public Boolean updatePurchasePrice(Object purchaseId) {
        // 首先查询该货单下的所有详细信息
        List<PurchaseDetail> detailList = purchaseDetailService.getInfoByPurchaseId(purchaseId+"");
        // 重新计算整个货单的价格
        Integer newTotalPrice = 0;
        // 重新计算小计
        for (PurchaseDetail detail : detailList) {
            newTotalPrice += detail.getTotalPrice();
        }
        // 查询出货单信息
        Purchase purchase = this.getOne(new QueryWrapper<Purchase>().eq("id", purchaseId));
        purchase.setPurchasePrice(newTotalPrice);
        return this.updateById(purchase);
    }
}

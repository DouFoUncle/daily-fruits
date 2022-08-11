package priv.fruits.controller;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import cn.hutool.poi.excel.StyleSet;
import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.poi.ss.usermodel.CellStyle;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import priv.fruits.pojo.Goods;
import priv.fruits.pojo.Purchase;
import priv.fruits.pojo.PurchaseDetail;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.service.GoodsService;
import priv.fruits.service.PurchaseDetailService;
import priv.fruits.service.PurchaseService;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

/**
 * t_purchase表的控制器层
 */
@RestController
@RequestMapping("/purchase")
public class PurchaseController {

    @Autowired
    private PurchaseService purchaseService;

    @Autowired
    private PurchaseDetailService purchaseDetailService;

    @Autowired
    private GoodsService goodsService;

    /**
     * 根据条件分页查询全部数据
     * @param purchase
     * @param page
     * @param limit
     * @return
     */
    @GetMapping("/getAllInfoByPage")
    public ResultMessage getAllInfoByPage(Purchase purchase, Integer page, Integer limit) {
        // 查询数据
        try {
            // 调用Service查询方法收到返回的Page对象
            IPage<Purchase> pageResult = purchaseService.getInfoByPage(purchase, page, limit);
            // 封装数据
            return new ResultMessage(0, "查询成功！", pageResult.getRecords(), pageResult.getTotal());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 生成运单Excel并提供下载 (若不传入ids则进行批量所有商品)
     */
    @GetMapping("/downLoadFile")
    public void downLoadFile(HttpServletResponse response, String ids) {
        try {
            List<Goods> goods = goodsService.getAllInfo(ids);
            List<Object> exportData = new ArrayList<>(16);
            // 循环遍历处理要导出的数据
            goods.forEach(item -> {
                exportData.add(CollectionUtil.newArrayList(item.getId(), item.getGoodsName(), item.getGoodsStock(),
                        item.getGoodsCostPrice() / 100.0 + "元", "输入要采购的数量, 不需要进货的商品可以删掉"));
            });
            ExcelWriter writer = ExcelUtil.getWriter();
            writer.setColumnWidth(0, 20);
            writer.setColumnWidth(1, 40);
            writer.setColumnWidth(2, 20);
            writer.setColumnWidth(3, 20);
            writer.setColumnWidth(4, 45);
            writer.setDefaultRowHeight(21);
            // 一次性写出内容，使用默认样式，强制输出标题
            writer.writeHeadRow(CollectionUtil.newArrayList("商品ID", "商品名", "当前库存", "采购原价", "要采购的数量"));
            writer.writeHeadRow(CollectionUtil.newArrayList("goodsId", "goodsName", "goodsStock", "purchasePrice", "count"));
            writer.write(exportData, false);
            //out为OutputStream，需要写出到的目标流
            //response为HttpServletResponse对象
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            //test.xls是弹出下载对话框的文件名，不能为中文，中文请自行编码
            String fileName = "模板文件" + DateUtil.format(new Date(), "yyyyMMddHHmmss") + ".xls";
            // 中文字处理, 防止文件名乱码
            response.setHeader("Content-Disposition","attachment;filename=" + new String(fileName.getBytes(), "ISO-8859-1"));
            ServletOutputStream out=response.getOutputStream();
            writer.flush(out, true);
            // 关闭writer，释放内存
            writer.close();
            //此处记得关闭输出Servlet流
            IoUtil.close(out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 导入模板文件创建货单
     * @return
     */
    @PostMapping("/importExcel")
    public ResultMessage importExcel(@RequestParam("file") MultipartFile file) {
        try {
            if(file == null || file.getSize() <= 0) {
                return new ResultMessage(500, "不能上传空文件! ");
            }
            ExcelReader reader = ExcelUtil.getReader(file.getInputStream());
            // 读取导入的Excel模板文件, 标题从第二行开始
            List<Map> importData = reader.read(1, 2, Map.class);
            Iterator<Map> importDataIterator = importData.iterator();
            // 创建运单详情的集合, 用于插入运单信息后, 继续插入运单的详细信息
            List<PurchaseDetail> purchaseDetailList = new ArrayList<>(16);
            // 运单总价格
            Integer sumPrice = 0;
            // 去除没有填写进货数量的对象
            while (importDataIterator.hasNext()) {
                Map nextMap = importDataIterator.next();
                if(StrUtil.isBlankOrUndefined(nextMap.get("count")+"")) {
                    // 进货数量为空, 移除该对象
                    importDataIterator.remove();
                } else {
                    // 不为空, 计算小计价格 (本条运单详情的小计)
                    // 首先取出进货价, 注意这里进货价需要进行处理, 因为在导出的模板中, 进货价后面加了一个汉字 "元", 需要将其截取掉
                    String costPrice = nextMap.get("purchasePrice").toString().substring(0, nextMap.get("purchasePrice").toString().length() - 1);
                    Integer totalPrice = (int) (Integer.parseInt(nextMap.get("count")+"") * (Double.parseDouble(costPrice) * 100.0));
                    // 封装运单详情
                    PurchaseDetail purchaseDetail = new PurchaseDetail();
                    purchaseDetail.setCount(Integer.parseInt(nextMap.get("count")+""));
                    purchaseDetail.setGoodsId(Integer.parseInt(nextMap.get("goodsId")+""));
                    purchaseDetail.setPurchaseDate(DateUtil.now());
                    purchaseDetail.setTotalPrice(totalPrice);
                    purchaseDetail.setPurchasePrice((int) ((Double.parseDouble(costPrice) * 100.0)));
                    purchaseDetail.setGoodsName(nextMap.get("goodsName").toString());
                    // 将运单详情加入集合
                    purchaseDetailList.add(purchaseDetail);
                    // 累加计算运单总价
                    sumPrice += totalPrice;
                }
            }
            // 创建运单信息
            Purchase purchase = new Purchase();
            purchase.setCreateDate(DateUtil.now());
            purchase.setPurchaseNum(DateUtil.format(new Date(), "yyyyMMddHHmmss"));
            // 设置订单总价
            purchase.setPurchasePrice(sumPrice);
            // 设置状态为未确认下单
            purchase.setPurchaseStatus("2");
            // 插入一条运单信息
            Boolean result = purchaseService.insertInfo(purchase, purchaseDetailList);
            // 返回结果
            if(result) {
                return new ResultMessage(0, "货单创建成功!");
            } else {
                return new ResultMessage(207, "货单创建失败! 后台无异常, 请稍后再试!");
            }
        } catch (IOException e) {
            e.printStackTrace();
            return new ResultMessage(207, "货单创建失败! 后台出现异常：" + e.getMessage());
        }
    }

    /**
     * 根据ID导出货单信息
     */
    @GetMapping("/exportPurchaseInfo")
    public void exportPurchaseInfo(HttpServletResponse response, String id, String purchaseNum) {
        if(!StrUtil.isBlankOrUndefined(id)) {
            try {
                // 根据ID查询货单详细信息
                List<PurchaseDetail> purchaseDetailList = purchaseDetailService.getInfoByPurchaseId(id);
                // 封装要导出的数据
                List<Object> exportData = new ArrayList<>(16);
                purchaseDetailList.forEach(item -> {
                    exportData.add(CollectionUtil.newArrayList(item.getGoodsId(), item.getGoodsName(), (item.getPurchasePrice() / 100.0) + "元",
                                                                item.getCount(), (item.getTotalPrice() / 100.0) + "元"));
                });
                ExcelWriter writer = ExcelUtil.getWriter();
                writer.setColumnWidth(0, 20);
                writer.setColumnWidth(1, 40);
                writer.setColumnWidth(2, 20);
                writer.setColumnWidth(3, 20);
                writer.setColumnWidth(4, 20);
                writer.setDefaultRowHeight(21);
                // 一次性写出内容，使用默认样式，强制输出标题
                writer.writeHeadRow(CollectionUtil.newArrayList("商品ID", "商品名", "采购原价", "采购数量", "价格小计"));
                writer.write(exportData, false);
                //out为OutputStream，需要写出到的目标流
                //response为HttpServletResponse对象
                response.setContentType("application/vnd.ms-excel;charset=utf-8");
                //test.xls是弹出下载对话框的文件名，不能为中文，中文请自行编码
                String fileName = purchaseNum + "货单的详细信息.xls";
                // 中文字处理, 防止文件名乱码
                response.setHeader("Content-Disposition", "attachment;filename=" + new String(fileName.getBytes(), "ISO-8859-1"));
                ServletOutputStream out = response.getOutputStream();
                writer.flush(out, true);
                // 关闭writer，释放内存
                writer.close();
                //此处记得关闭输出Servlet流
                IoUtil.close(out);
                out.flush();
                out.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 更新一条purchase信息
     * @param purchase
     * @return
     */
    @PutMapping("/updateInfo")
    public ResultMessage updateInfo(@RequestBody Purchase purchase) {
        try {
            // 调用Service方法
            Integer result = purchaseService.updateInfo(purchase);
            if(result > 0) {
                // 封装数据
                return new ResultMessage(0, "操作成功！");
            } else {
                // 封装数据
                return new ResultMessage(207, "数据无变化！后台无异常！请稍后再试！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "操作出现异常：" + e.getMessage());
        }
    }

    /**
     * 更新货单为已收货同时更新商品库存
     * @param purchase  要更新的对象
     * @return          返回更新结果
     */
    @PutMapping("/updateInfoAndGoodsStock")
    public ResultMessage updateInfoAndGoodsStock(@RequestBody Purchase purchase) {
        try {
            // 调用Service方法
            Boolean result = purchaseService.updateInfoAndGoodsStock(purchase);
            if(result) {
                // 封装数据
                return new ResultMessage(0, "操作成功！");
            } else {
                // 封装数据
                return new ResultMessage(207, "数据无变化！后台无异常！请稍后再试！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "操作出现异常：" + e.getMessage());
        }
    }

}

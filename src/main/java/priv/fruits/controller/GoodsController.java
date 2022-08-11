package priv.fruits.controller;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.extra.pinyin.PinyinUtil;
import cn.hutool.poi.excel.ExcelReader;
import cn.hutool.poi.excel.ExcelUtil;
import cn.hutool.poi.excel.ExcelWriter;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import priv.fruits.pojo.*;
import priv.fruits.service.GoodsService;
import priv.fruits.service.GoodsService;
import priv.fruits.service.GoodsTypeService;
import priv.fruits.service.PurchaseDetailService;
import priv.fruits.util.ServletUtils;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

/**
 * t_goods表的控制器层
 */
@RestController
@RequestMapping("/goods")
public class GoodsController {

    @Autowired
    private GoodsService goodsService;

    @Autowired
    private PurchaseDetailService purchaseDetailService;

    @Autowired
    private GoodsTypeService goodsTypeService;

    /**
     * 根据条件分页查询全部数据
     * @param goods
     * @param page
     * @param limit
     * @return
     */
    @GetMapping("/getAllInfoByPage")
    public ResultMessage getAllInfoByPage(Goods goods, Integer page, Integer limit) {
        // 查询数据
        try {
            // 调用Service查询方法收到返回的Page对象
            PageInfo<Goods> pageResult = goodsService.getInfoByPage(goods, page, limit);
            // 封装数据
            return new ResultMessage(0, "查询成功！", pageResult.getList(), pageResult.getTotal());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 获取全部商品信息
     * @return
     */
    @GetMapping("/getGoodsByLayuiTransfer")
    public ResultMessage getGoodsByLayuiTransfer(Goods goods, String purchaseId) {
        // 查询数据
        try {
            // 调用Service查询方法收到返回的Page对象
            List<Goods> goodsList = goodsService.getGodsAllInfo(goods);
            // 最终返回的数据(data)
            Map<String, Object> resultData = new HashMap<>(16);
            List<LayuiTransFerData> leftDataList = new ArrayList<>(16);
            goodsList.forEach(item -> {
                // 构建最终数据
                LayuiTransFerData transFerData = new LayuiTransFerData();
                transFerData.setChecked(false);
                transFerData.setDisabled("0".equals(item.getGoodsStatus()));
                transFerData.setValue(item.getId()+"");
                transFerData.setTitle(item.getGoodsName() + " —— <span style='color: #FF5722;'>当前库存：" + item.getGoodsStock()+"</span>");
                leftDataList.add(transFerData);
            });
            resultData.put("leftData", leftDataList);
            // 如果货单ID不为空, 则代表要修改货单的内容, 需要将该货单中已加入的商品信息查询出来(用于展示右侧穿梭框)
            if(!StrUtil.isBlankOrUndefined(purchaseId)) {
                // 根据货单ID查询出货单中的所有商品信息
                List<PurchaseDetail> detailList = purchaseDetailService.getInfoByPurchaseId(purchaseId);
                List<Object> goodsIds = new ArrayList<>(16);
                for (PurchaseDetail purchaseDetail : detailList) {
                    goodsIds.add(purchaseDetail.getGoodsId());
                }
                // 只用指出商品ID即可渲染右侧数据
                resultData.put("rightData", goodsIds);
            }
            // 封装数据
            return new ResultMessage(0, "查询成功！", resultData);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, e.getMessage());
        }
    }

    /**
     * 插入一条goods信息
     * @param goods
     * @return
     */
    @PostMapping("/insertInfo")
    public ResultMessage insertInfo(@RequestBody Goods goods, HttpServletRequest request) {
        // 分割类型
        String[] split = goods.getGoodsType().split("\\|");
        goods.setGoodsTypeId(Integer.parseInt(split[0]));
        goods.setGoodsType(split[1]);
        try {
            // 调用Service方法
            Integer result = goodsService.insertInfo(goods);
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
     * 更新一条goods信息
     * @param goods
     * @return
     */
    @PutMapping("/updateInfo")
    public ResultMessage updateInfo(@RequestBody Goods goods, HttpServletRequest request) {
        // 分割类型
        String[] split = goods.getGoodsType().split("\\|");
        goods.setGoodsTypeId(Integer.parseInt(split[0]));
        goods.setGoodsType(split[1]);
        try {
            // 调用Service方法
            Integer result = goodsService.updateInfo(goods);
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
     * 更新一条goods信息
     * @param paramMap
     * @return
     */
    @PutMapping("/upOrDownGoods")
    public ResultMessage upOrDownGoods(@RequestBody Map<String, Object> paramMap) {
        try {
            List<Object> goodsIds = (List<Object>) paramMap.get("goodsIds");
            String status = paramMap.get("status") + "";
            // 调用Service方法
            Boolean result = goodsService.updateInfoStatus(goodsIds, status);
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

    /**
     * 删除一条或多条goods信息
     * @param ids
     * @return
     */
    @GetMapping("/deleteInfo")
    public ResultMessage deleteInfo(String ids) {
        try {
            // 调用Service方法
            Boolean result = goodsService.deleteInfo(ids);
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
                exportData.add(CollectionUtil.newArrayList(
                        "请填写商品名称",
                        "商品类型ID, 参考sheet2中的数据",
                        "商品类型名, 参考sheet2中的数据",
                        "填写商品的搜索关键字",
                        "商品售价",
                        "商品进货价",
                        "请填写商品库存, 默认为：0",
                        "请填写商品展示时首图的图片名称, 例如：1.png",
                        "请填写商品展示的图片名称, 多个图片名要用英文分号隔开, 例如：1.png;2.png;3.png",
                        "请填写商品描述",
                        "请填写商品规格, 例如：500g/份"
                ));
            });
            ExcelWriter writer = ExcelUtil.getWriter();
            writer.setColumnWidth(0, 30);
            writer.setColumnWidth(1, 30);
            writer.setColumnWidth(2, 30);
            writer.setColumnWidth(3, 20);
            writer.setColumnWidth(4, 20);
            writer.setColumnWidth(5, 20);
            writer.setColumnWidth(6, 25);
            writer.setColumnWidth(7, 45);
            writer.setColumnWidth(8, 75);
            writer.setColumnWidth(9, 20);
            writer.setColumnWidth(10, 30);
            writer.setDefaultRowHeight(21);
            // 一次性写出内容，使用默认样式，强制输出标题
            writer.writeHeadRow(CollectionUtil.newArrayList("商品名称", "商品类型ID", "商品类型名", "搜索关键字", "商品售价",
                    "商品进货价", "商品库存", "商品首图展示图名字", "商品展示图名字", "商品描述", "商品规格"));
            writer.writeHeadRow(CollectionUtil.newArrayList("goodsName", "goodsTypeId", "goodsType", "goodsKeyword"
                    , "goodsPrice", "goodsCostPrice", "goodsStock", "goodsHeadImg", "goodsImg", "goodsReadme", "goodsNorms"));
            writer.write(exportData, false);
            // 创建Sheet2
            ExcelWriter writerTypeSheet = writer.setSheet("sheet2");
            writerTypeSheet.setDefaultRowHeight(21);
            writerTypeSheet.setColumnWidth(0, 30);
            writerTypeSheet.setColumnWidth(1, 30);
            writerTypeSheet.writeHeadRow(CollectionUtil.newArrayList("商品类型ID", "商品类型名"));
            // 查询所有类型信息
            List<GoodsType> getAllTypeInfo = goodsTypeService.getAllTypeInfo();
            List<Object> typeData = new ArrayList<>(16);
            getAllTypeInfo.forEach(item -> {
                typeData.add(CollectionUtil.newArrayList(
                        item.getId(), item.getTypeName()
                ));
            });
            writerTypeSheet.write(typeData, false);
            //out为OutputStream，需要写出到的目标流
            //response为HttpServletResponse对象
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            //test.xls是弹出下载对话框的文件名，不能为中文，中文请自行编码
            String fileName = "商品模板文件" + DateUtil.format(new Date(), "yyyyMMddHHmmss") + ".xls";
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
     * 导入Excel模板插入数据
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
            List<Goods> goodsList = new ArrayList<>(16);
            importData.forEach(item -> {
                // 处理读取的数据
                Goods goods = new Goods();
                goods.setIsDelete("0");
                goods.setGoodsTypeId(Integer.parseInt(item.get("goodsTypeId")+""));
                goods.setGoodsType(item.get("goodsType")+"");
                goods.setGoodsName(item.get("goodsName")+"");
                goods.setGoodsImg(item.get("goodsImg")+"");
                goods.setGoodsHeadImg(item.get("goodsHeadImg")+"");
                goods.setGoodsKeyword(item.get("goodsKeyword")+"");
                goods.setGoodsNorms(item.get("goodsNorms")+"");
                Double goodsPriceDouble = Double.parseDouble(item.get("goodsPrice")+"");
                Double goodsCostPriceDouble = Double.parseDouble(item.get("goodsCostPrice")+"");
                goods.setGoodsPrice((int) (goodsPriceDouble * 100));
                goods.setGoodsCostPrice((int) (goodsCostPriceDouble * 100));
                goods.setGoodsReadme(item.get("goodsReadme")+"");
                String stock = item.get("goodsStock")+"";
                if(StrUtil.isBlankOrUndefined(stock)) {
                    goods.setGoodsStock(0);
                } else {
                    goods.setGoodsStock(Integer.parseInt(stock));
                }
                goods.setGoodsStatus("1");
                goodsList.add(goods);
            });
            // 插入读取并处理好的信息
            Boolean result = goodsService.insertExcelInfo(goodsList);
            // 返回结果
            if(result) {
                return new ResultMessage(0, "导入商品信息完成!");
            } else {
                return new ResultMessage(207, "导入商品信息失败! 后台无异常, 请稍后再试!");
            }
        } catch (IOException e) {
            e.printStackTrace();
            return new ResultMessage(207, "导入商品信息失败! 后台出现异常：" + e.getMessage());
        }
    }


}

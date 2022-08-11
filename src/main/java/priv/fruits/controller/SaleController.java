package priv.fruits.controller;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import priv.fruits.pojo.Goods;
import priv.fruits.pojo.Sale;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.service.SaleService;

import java.util.*;

/**
 * t_sale表的控制器层
 */
@RestController
@RequestMapping("/sale")
public class SaleController {

    @Autowired
    private SaleService saleService;

    /**
     * 根据条件分页查询全部数据
     * @param sale
     * @param page
     * @param limit
     * @return
     */
    @GetMapping("/getAllInfoByPage")
    public ResultMessage getAllInfoByPage(Sale sale, String start, String end, Integer page, Integer limit) {
        // 查询数据
        try {
            if(!StrUtil.isBlankOrUndefined(start) && StrUtil.isBlankOrUndefined(end)) {
                end = start;
            }
            // 调用Service查询方法收到返回的Page对象
            IPage<Sale> pageResult = saleService.getInfoByPage(sale, start, end,  page, limit);
            // 封装数据
            return new ResultMessage(0, "查询成功！", pageResult.getRecords(), pageResult.getTotal());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 根据天数获取图表数据
     * @param day
     * @param start
     * @param end
     * @return
     */
    @GetMapping("/getInfoByDay")
    public ResultMessage getInfoByDay(Integer day, String start, String end) {
        // 查询数据
        try {
            if(StrUtil.isBlankOrUndefined(day+"")) {
                day = 7;
            }
            // 默认查询数据 (查询最近七天的数据)
            String startTime = DateUtil.format(DateUtil.offsetDay(new Date(), -(day-1)), "yyyy-MM-dd");
            String endTime = DateUtil.format(new Date(), "yyyy-MM-dd");
            // 查询数据支出的数据
            List<Map<String, Object>> saleList = saleService.getAllInfoByDateAndTypeFlag(startTime, endTime, null);
            Integer totalIncome = 0;
            Integer totalExpend = 0;
            // 计算该时间段总支出收入等
            for (Map<String, Object> map : saleList) {
                String typeFlag = map.get("sale_type_flag")+"";
                if("0".equals(typeFlag)) {
                    totalExpend += Integer.parseInt(map.get("totalPrice")+"");
                } else if("1".equals(typeFlag)) {
                    totalIncome += Integer.parseInt(map.get("totalPrice")+"");
                }
            }
            // 计算这七天每天的数据
            List<Map<String, Object>> everyDayMap = new ArrayList<>(16);
            // 得到这七天的日期
            List<String> dateList = new ArrayList<>(16);
            for (int i = day - 1; i >= 0; i--) {
                Date date = DateUtil.parseDate(startTime);
                String dateStr = DateUtil.format(DateUtil.offsetDay(date, i), "yyyy-MM-dd");
                dateList.add(dateStr);
            }
            // 双重循环处理数据
            for (String date : dateList) {
                Map<String, Object> resultMap = new HashMap<>(16);
                resultMap.put("date", date);
                for (Map<String, Object> map : saleList) {
                    String mapDateStr = map.get("date")+"";
                    if(date.equals(mapDateStr)) {
                        // 保存本条记录
                        resultMap.put("0".equals(map.get("sale_type_flag")+"") ? "expend" : "income"
                                , map.get("totalPrice"));
                    }
                }
                // 判断是否有数据不存在, 比如今天没有收入, 或者没有支出时
                if(StrUtil.isBlankOrUndefined(resultMap.get("income")+"")
                        && StrUtil.isBlankOrUndefined(resultMap.get("expend")+"")) {
                    // 支出和收入都没有(直接设置净赚为0)
                    resultMap.put("netIncome", "0");
                    resultMap.put("expend", "0");
                    resultMap.put("income", "0");
                } else if(StrUtil.isBlankOrUndefined(resultMap.get("expend")+"")) {
                    // 有收入没支出(设置净赚为收入)
                    resultMap.put("netIncome", resultMap.get("income"));
                    resultMap.put("expend", "0");
                } else if(StrUtil.isBlankOrUndefined(resultMap.get("income")+"")) {
                    // 有支出没收入(设置净赚为0-支出)
                    resultMap.put("netIncome", "-" + resultMap.get("expend"));
                    resultMap.put("income", "0");
                } else if(!StrUtil.isBlankOrUndefined(resultMap.get("income")+"")
                        && !StrUtil.isBlankOrUndefined(resultMap.get("expend")+"")) {
                    // 收入和支出都不为空, (净赚 = 收入-支出)
                    resultMap.put("netIncome", Integer.parseInt(resultMap.get("income")+"")
                            - Integer.parseInt(resultMap.get("expend")+""));
                }
                everyDayMap.add(resultMap);
            }
            Map<String, Object> resultMap = new HashMap<>(16);
            resultMap.put("everyDayMap", everyDayMap);
            resultMap.put("totalIncome", totalIncome);
            resultMap.put("totalExpend", totalExpend);
            resultMap.put("netIncome", totalIncome - totalExpend);
            resultMap.put("day", day);
            return new ResultMessage(0, "查询成功!", resultMap);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 根据时间段获取图表数据
     * @param start
     * @param end
     * @return
     */
    @GetMapping("/getInfoByDate")
    public ResultMessage getInfoByDate(String start, String end) {
        // 查询数据
        try {
            Integer day = 0;
            if(StrUtil.isBlankOrUndefined(start)) {
                return new ResultMessage(400, "缺少日期的必要参数!");
            }
            if(StrUtil.isBlankOrUndefined(end)) {
                end = start;
            }
            List<Map<String, Object>> saleList = saleService.getAllInfoByDateAndTypeFlag(start, end, null);
            if(start.equals(end)) {
                day = 0;
            } else {
                day = (int) DateUtil.betweenDay(DateUtil.parse(start), DateUtil.parseDate(end), true);
            }
            Integer totalIncome = 0;
            Integer totalExpend = 0;
            // 计算该时间段总支出收入等
            for (Map<String, Object> map : saleList) {
                String typeFlag = map.get("sale_type_flag")+"";
                if("0".equals(typeFlag)) {
                    totalExpend += Integer.parseInt(map.get("totalPrice")+"");
                } else if("1".equals(typeFlag)) {
                    totalIncome += Integer.parseInt(map.get("totalPrice")+"");
                }
            }
            // 计算该时间段每天的数据
            List<Map<String, Object>> everyDayMap = new ArrayList<>(16);
            // 得到这该时间段每天的日期
            List<String> dateList = new ArrayList<>(16);
            for (int i = day; i >= 0; i--) {
                Date date = DateUtil.parseDate(start);
                String dateStr = DateUtil.format(DateUtil.offsetDay(date, i), "yyyy-MM-dd");
                dateList.add(dateStr);
            }
            // 双重循环处理数据
            for (String date : dateList) {
                Map<String, Object> resultMap = new HashMap<>(16);
                resultMap.put("date", date);
                for (Map<String, Object> map : saleList) {
                    String mapDateStr = map.get("date")+"";
                    if(date.equals(mapDateStr)) {
                        // 保存本条记录
                        resultMap.put("0".equals(map.get("sale_type_flag")+"") ? "expend" : "income"
                                , map.get("totalPrice"));
                    }
                }
                // 判断是否有数据不存在, 比如今天没有收入, 或者没有支出时
                if(StrUtil.isBlankOrUndefined(resultMap.get("income")+"")
                        && StrUtil.isBlankOrUndefined(resultMap.get("expend")+"")) {
                    // 支出和收入都没有(直接设置净赚为0)
                    resultMap.put("netIncome", "0");
                    resultMap.put("expend", "0");
                    resultMap.put("income", "0");
                } else if(StrUtil.isBlankOrUndefined(resultMap.get("expend")+"")) {
                    // 有收入没支出(设置净赚为收入)
                    resultMap.put("netIncome", resultMap.get("income"));
                    resultMap.put("expend", "0");
                } else if(StrUtil.isBlankOrUndefined(resultMap.get("income")+"")) {
                    // 有支出没收入(设置净赚为0-支出)
                    resultMap.put("netIncome", "-" + resultMap.get("expend"));
                    resultMap.put("income", "0");
                } else if(!StrUtil.isBlankOrUndefined(resultMap.get("income")+"")
                        && !StrUtil.isBlankOrUndefined(resultMap.get("expend")+"")) {
                    // 收入和支出都不为空, (净赚 = 收入-支出)
                    resultMap.put("netIncome", Integer.parseInt(resultMap.get("income")+"")
                            - Integer.parseInt(resultMap.get("expend")+""));
                }
                everyDayMap.add(resultMap);
            }
            Map<String, Object> resultMap = new HashMap<>(16);
            resultMap.put("everyDayMap", everyDayMap);
            resultMap.put("totalIncome", totalIncome);
            resultMap.put("totalExpend", totalExpend);
            resultMap.put("netIncome", totalIncome - totalExpend);
            resultMap.put("findStart", start);
            resultMap.put("findEnd", end);
            return new ResultMessage(0, "查询成功!", resultMap);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "查询出现异常：" + e.getMessage());
        }
    }

    /**
     * 插入一条sale信息
     * @param sale
     * @return
     */
    @PostMapping("/insertInfo")
    public ResultMessage insertInfo(@RequestBody Sale sale) {
        return null;
    }

    /**
     * 更新一条sale信息
     * @param sale
     * @return
     */
    @PutMapping("/updateInfo")
    public ResultMessage updateInfo(@RequestBody Sale sale) {
        return null;
    }

    /**
     * 删除一条或多条sale信息
     * @param ids
     * @return
     */
    @GetMapping("/deleteInfo")
    public ResultMessage deleteInfo(String ids) {
        return null;
    }

}

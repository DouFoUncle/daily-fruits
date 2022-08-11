package priv.fruits.controller.web;

import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import priv.fruits.pojo.Cart;
import priv.fruits.pojo.Goods;
import priv.fruits.pojo.GoodsType;
import priv.fruits.pojo.User;
import priv.fruits.service.CartService;
import priv.fruits.service.GoodsService;
import priv.fruits.service.GoodsTypeService;
import priv.fruits.service.UserService;
import priv.fruits.util.ServletUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @Author 冶生华
 * @Description 果蔬超市
 */
@Controller
@RequestMapping("/webSystem")
public class WebSystemController {

    @Autowired
    private GoodsService goodsService;

    @Autowired
    private GoodsTypeService goodsTypeService;

    @Autowired
    private UserService userService;

    @Autowired
    private CartService cartService;

    /**
     * 跳转到用户登录页面
     * @return
     */
    @GetMapping("/toLoginPage/{type}")
    public ModelAndView toLoginPage(ModelAndView modelAndView, @PathVariable("type") String type) {
        modelAndView.addObject("type", type);
        modelAndView.setViewName("web/login");
        return modelAndView;
    }

    /**
     * 跳转到前台首页
     * @return
     */
    @GetMapping("/toWebIndexPage")
    public ModelAndView toWebIndexPage(ModelAndView modelAndView, HttpServletRequest request) {
        // 取出15个
        List<Goods> goodsList = goodsService.getInfoByPage(null, 1, 15).getList();
        // 如果有测试商品则移除
        Iterator<Goods> iterator = goodsList.iterator();
        while (iterator.hasNext()) {
            Goods next = iterator.next();
            if (next.getGoodsName().contains("测试")) {
                iterator.remove();
            }
        }
        // 筛选完成后, 取出8个存入
        List<Goods> resultList = new ArrayList<>(8);
        for (int i = 0; i < 8; i++) {
            resultList.add(goodsList.get(i));
        }
        modelAndView.addObject("goodsList", resultList);
        modelAndView.addObject("projectPath", ServletUtils.getProjectHttpUrl(request));
        // 保存购物车当前数量
        Integer userId = ServletUtils.getWebUserIdInfo(request);
        if(userId != null) {
            Integer cartListCount = cartService.getCartCountByUserId(userId);
            request.getSession().setAttribute("cartListCount", cartListCount);
        }
        modelAndView.setViewName("web/index");
        return modelAndView;
    }

    /**
     * 跳转到商城页面
     * @return
     */
    @GetMapping("/toShopPage")
    public ModelAndView toShopPage(ModelAndView modelAndView, HttpServletRequest request, Goods goods, Integer page) {
        if (page == null) {
            page = 1;
        }
        if(goods == null) {
            goods = new Goods();
        }
        goods.setGoodsStatus("1");
        PageInfo<Goods> goodsPage = goodsService.getInfoByPage(goods, page, 12);
        // 设置侧边栏随机5个商品
        setSideGoodsInfo(request, goodsPage, goods, page);
        modelAndView.addObject("pageInfo", goodsPage);
        modelAndView.addObject("pages", goodsPage.getPages());
        modelAndView.addObject("projectPath", ServletUtils.getProjectHttpUrl(request));
        modelAndView.setViewName("web/shop");
        return modelAndView;
    }

    /**
     * 跳转到商品详情页面
     * @return
     */
    @GetMapping("/toShopDetailPage")
    public ModelAndView toShopDetailPage(ModelAndView modelAndView, String id, HttpServletRequest request) {
        // 设置侧边栏随机5个商品
        setSideGoodsInfo(request, null, null, null);
        Goods goodsInfo = goodsService.getInfoById(id);
        String imgStr = goodsInfo.getGoodsImg();
        List<String> imgList = StrUtil.split(imgStr, ';');
        modelAndView.addObject("goodsInfo", goodsInfo);
        modelAndView.addObject("imgList", imgList);
        modelAndView.addObject("projectPath", ServletUtils.getProjectHttpUrl(request));
        modelAndView.setViewName("web/shop-detail");
        return modelAndView;
    }

    /**
     * 跳转到联系我们
     * @return
     */
    @GetMapping("/toContactPage")
    public ModelAndView toContactPage(ModelAndView modelAndView) {
        modelAndView.setViewName("web/contact-us");
        return modelAndView;
    }

    /**
     * 设置侧边栏信息
     * @param request
     * @param goodsPage
     * @param goods
     * @param page
     */
    private void setSideGoodsInfo(HttpServletRequest request, PageInfo<Goods> goodsPage, Goods goods, Integer page) {
        HttpSession session = request.getSession();
        Object sideGoodsObj = session.getAttribute("sideGoods");
        if (goodsPage == null) {
            goodsPage = goodsService.getInfoByPage(goods, page == null ? 1 : page, 12);
        }
        // 如果已经保存的有侧边栏商品信息, 则不再进行保存
        if (sideGoodsObj == null) {
            // 随机取出5个存入, 用于侧边栏展示
            Set<Goods> sideGoods = new HashSet<>(8);
            int randomNum = -1;
            while (true) {
                if (sideGoods.size() == 5) {
                    break;
                }
                int randomInt = RandomUtil.randomInt(0, goodsPage.getList().size() - 1);
                if (randomNum != randomInt) {
                    Goods addGoods = goodsPage.getList().get(randomInt);
                    if (!addGoods.getGoodsName().contains("测试")) {
                        sideGoods.add(addGoods);
                    }
                }
            }
            session.setAttribute("sideGoods", sideGoods);
        }

        // 设置类型信息
        // 查询类型信息并统计每种类型下的商品数量
        List<GoodsType> goodsTypeList = goodsTypeService.getTypeInfoByGroup();
        List<GoodsType> goodsTypes = new ArrayList<>();
        GoodsType goodsType = new GoodsType();
        goodsType.setTypeName("全部");
        goodsType.setGoodsCount((int) goodsPage.getTotal());
        goodsType.setId(-100);
        goodsTypes.add(goodsType);
        goodsTypes.addAll(goodsTypeList);
        session.setAttribute("goodsTypeList", goodsTypes);
    }
}

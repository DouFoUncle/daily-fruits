package priv.fruits.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @Author 冶生华
 * 自定义的异常跳转页
 */
@Controller
@RequestMapping("error")
public class MyErrorPageController {

    /**
     * 404错误的跳转地址
     * @return
     */
    @RequestMapping("error-404")
    public String toPage404(){
        return "admin/error/error-404";
    }

    /**
     * 400错误的跳转地址
     * @return
     */
    @RequestMapping("error-400")
    public String toPage400(){
        return "admin/error/error-400";
    }

    /**
     * 401错误的跳转地址
     * @return
     */
    @RequestMapping("error-401")
    public String toPage401(){
        return "admin/error/error-401";
    }

    /**
     * 500错误的跳转地址
     * @return
     */
    @RequestMapping("error-500")
    public String toPage500(){
        return "admin/error/error-500";
    }

    /**
     * 没有权限
     * @return
     */
    @RequestMapping("toNoPowerPage")
    public String toNoPowerPage(){
        return "admin/error/noPower";
    }
}

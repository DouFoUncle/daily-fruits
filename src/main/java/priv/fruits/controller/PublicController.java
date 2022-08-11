package priv.fruits.controller;


import cn.hutool.core.util.StrUtil;
import cn.hutool.extra.pinyin.PinyinUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import priv.fruits.pojo.ResultMessage;
import priv.fruits.util.ServletUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * @Author Mr.Zheng
 * @Date 2020/12/10
 * @Description 一些公共的控制器
 */
@Controller
@RequestMapping("/public")
public class PublicController {
    /**
     * 打开上传文件的窗口
     * @return
     */
    @RequestMapping("/toUploadImage")
    public String toUploadImagePage(Model model) {
        return "admin/uploadImageOverride";
    }

    /**
     * 上传文件
     * @return
     */
    @RequestMapping("/uploadImages")
    @ResponseBody
    public ResultMessage toUploadImagesOverride(@RequestParam("files") MultipartFile[] files,
                                       HttpServletRequest request) {
        // 设置文件存放路径
        String path = request.getSession().getServletContext().getRealPath("/upload/");
        String fileName = "";
        System.out.println("=============path==============：" + path);
        try {
            for (int i = 0; i < files.length; i++) {
                MultipartFile file = files[i];
                // 判断文件是否为空
                System.out.println(file.getSize());
                if (file.isEmpty() || file.getSize() <= 0) {
                    return new ResultMessage(207, "上传文件为空！");
                }
                // 获取上传文件的名字
                fileName = file.getOriginalFilename();
                // 创建文件
                File dest = new File(path + fileName);
                // 检测目录是否存在
                if (!dest.getParentFile().exists()) {
                    // 不存在就创建
                    dest.getParentFile().mkdir();
                }
                // 文件写入
                file.transferTo(dest);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultMessage(500, "出现异常：" + e.getMessage());
        }
        return new ResultMessage(0, "上传成功！");
    }
}

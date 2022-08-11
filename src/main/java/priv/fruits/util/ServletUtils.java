package priv.fruits.util;

import priv.fruits.pojo.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * @Author 冶生华
 * @Date 2020/9/14
 * @Description 果蔬超市
 */
public class ServletUtils {

    /**
     * 获取当前前台已登录用户的信息
     * @param request
     * @return
     */
    public static Integer getWebUserIdInfo(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User webUserInfo = (User) session.getAttribute("webUserInfo");
        if(webUserInfo == null) {
            return null;
        }
        return webUserInfo.getId();
    }

    /**
     * 获取项目网络地址
     * http://ip:port/projectName/
     * @param request
     * @return
     */
    public static String getProjectHttpUrl(HttpServletRequest request) {
        // 获取项目名称
        String contextPath = request.getContextPath();
        // 获取协议
        String scheme = request.getScheme();
        // 获取ip
        String serverName = request.getServerName();
        // 获取端口
        int serverPort = request.getServerPort();
        String showPath = scheme + "://" + serverName + ":" + serverPort + contextPath + "/";
        return showPath;
    }

    /**
     * 获取登陆用户的信息
     * @param request
     * @return
     */
    public static User getWebUserInfo(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User webUserInfo = (User) session.getAttribute("webUserInfo");
        return webUserInfo;
    }
}

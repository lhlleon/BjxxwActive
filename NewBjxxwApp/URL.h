//
//  URL.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/5.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#ifndef URL_h
#define URL_h

#define SCREEN_4S ([[UIScreen mainScreen] bounds].size.height<=480) //判断屏幕是比3.5英寸大
#define SCREEN_5S  ([[UIScreen mainScreen] bounds].size.height >480 && [[UIScreen mainScreen] bounds].size.height<=568) //判断屏幕是比4英寸大
#define SCREEN_6S ([[UIScreen mainScreen] bounds].size.height>568 && [[UIScreen mainScreen] bounds].size.height<=667) //判断屏幕是等于或者比4.7英寸大
#define SCREEN_6Ps ([[UIScreen mainScreen] bounds].size.height>667 && [[UIScreen mainScreen] bounds].size.height<=736) //判断屏幕是等于5.5英寸


#define SYPMW [[UIScreen mainScreen]bounds].size.width
#define SYPMH [[UIScreen mainScreen]bounds].size.height
// 系统相关信息
#define SYSTEM_MODEL (([[UIDevice currentDevice] model]))
#define SYSTEM_VERSION ([[UIDevice currentDevice] systemVersion])
//#define IOS7  ( [[[UIDevice currentDevice ] systemVersion]floatValue]>=7)
#define IOS7_OR_LATER ( SYSTEM_VERSION.floatValue >= 7.0 || SYSTEM_VERSION.floatValue < 8.0) //判断是否为iOS7及以后版本
#define IOS8_OR_LATER (SYSTEM_VERSION.floatValue > 8.0 )
#define SCREEN_4S ([[UIScreen mainScreen] bounds].size.height<=480) //判断屏幕是比3.5英寸大

#endif /* URL_h */

//拼接的接口
#define BaseUrl @"http://active.bjxxw.com"
//显示图片的借口
#define TPXSURL @"http://active.bjxxw.com/app/"

//广告
#define GGUrl @"http://active.bjxxw.com/app/guanggao.php"
//首页的
#define ShouYeUrl @"http://active.bjxxw.com/app/scale.php"
//首页轮播图
#define LunBoUrl @"http://active.bjxxw.com/app/slunbotu.php"
//首页四张图片
#define FourUrl @"http://active.bjxxw.com/app/sales.php"
//首页热门推荐
#define HotUrl @"http://active.bjxxw.com/app/index.php"
//详情页
#define XQUrl @"http://active.bjxxw.com/app/xiangqing.php" //如果  baoming == 1 需要报名,,, 否则隐藏
//详情网页
#define XQWUrl @"http://active.bjxxw.com/app/xq_ios.php?&hid="
//用户活动评论
#define PlUrl @"http://active.bjxxw.com/app/comment.php"
//添加评论
#define TJPLUrl @"http://active.bjxxw.com/app/addcomment.php"//(用户uid  活动hid  内容content)
//商家搜索
#define Business @"http://active.bjxxw.com/app/business_search.php"



//发布List
#define FBLB @"http://active.bjxxw.com/app/fabu_list.php"
//发布活动
#define FBHD @"http://active.bjxxw.com/app/user_add_hd.php"

//分类个数
#define FLGSUrl @"http://active.bjxxw.com/app/list_h.php"
//分类数据
#define FLZUrl @"http://active.bjxxw.com/app/fenlei_all.php"

//用户活动列表
#define YHLUrl @"http://active.bjxxw.com/app/user_list.php"
//用户活动详情
#define YHHDXQUrl @"http://active.bjxxw.com/app/user_xiangqing.php"
//用户活动评价详情
#define YHHDPLURL @"http://active.bjxxw.com/app/comment_user.php"
//用户活动发布评论
#define YHHDFBPLUrl @"http://active.bjxxw.com/app/user_add_comment.php"
//用户订单
#define YHDD @"http://active.bjxxw.com/app/my_order.php"
//取消订单
#define QXDD @"http://active.bjxxw.com/app/order_cancel.php"
//删除订单
#define SCDD @"http://active.bjxxw.com/app/order_del.php"


//注册用户
#define ZhuCe @"http://active.bjxxw.com/app/useradd.php"
//登陆
#define LogIn @"http://active.bjxxw.com/app/userlogin.php"
//修改个人信息
#define XiuGaiXX @"http://active.bjxxw.com/app/about_update.php"
//用户个人信息
#define PXinXi @"http://active.bjxxw.com/app/about_me.php"
//是否支付
#define HQSY @"http://active.bjxxw.com/app/if_baoming.php"
//判断支付
#define PDZF @"http://active.bjxxw.com/app/if_pay.php"


//头像userPhoto
#define TXSC @"http://active.bjxxw.com/app/user_ios_up.php"


//确认订单(报名)
#define BaoMingQueRen @"http://active.bjxxw.com/app/orders_u.php"


//是否收藏
#define SFSC @"http://active.bjxxw.com/app/if_collect.php"
//收藏
#define ADDSC @"http://active.bjxxw.com/app/addcollect.php"


//关于我们
#define aboutUs @"http://bjxxw.com/foot/guanyuwomen/about_us.html"

//我的收藏
#define allSC @"http://active.bjxxw.com/app/allcollect.php"

//我的评论
#define myPL @"http://active.bjxxw.com/app/mycomment.php"

//删除评论
#define ShanChuPl @"http://active.bjxxw.com/app/mycomment_del.php"

//我的发布
#define WDFBUrl @"http://active.bjxxw.com/app/my_fabu.php"

//忘记密码
#define ForgetUrl @"http://active.bjxxw.com/app/forget_password.php"

//用户活动图片上传
#define YHHDTP @"http://active.bjxxw.com/app/uploads.php"



/**
 *  58312880    客服电话
 */




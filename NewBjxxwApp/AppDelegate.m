//
//  AppDelegate.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/4/27.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"

#import "ShouYeViewController.h"
#import "FenLeiViewController.h"
#import "HuoDongViewController.h"
#import "WoDeViewController.h"
#import "IQKeyboardManager.h"
#import "XZMCoreNewFeatureVC.h"
#import "XHLaunchAd.h"
#import "WebViewController.h"
#import "LHLPushHelper.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#import "EditViewController.h"
#import "WebViewController.h"


//支付
#import "BeeCloud.h"


@interface AppDelegate ()
{
    UIWebView * webview;
    UIButton * backButton;
    UIImageView * navigation;
    UILabel * my;
    UINavigationController * nvc;
}

@property (nonatomic,strong) NSString * miao;
@property (nonatomic,strong) NSString * path;
@property (nonatomic,strong) NSString * surl;
@property (nonatomic,strong) NSString * titles;
@property (nonatomic,assign) CGFloat YWidth;
@property (nonatomic,assign) CGFloat YHeigh;

@end

@implementation AppDelegate

-(NSString *)miao
{
    if (_miao == nil) {
        _miao = [[NSString alloc]init];
    }
    return _miao;
}
-(NSString *)path
{
    if (_path == nil) {
        _path = [[NSString alloc]init];
    }
    return _path;
}
-(NSString *)surl
{
    if (_surl == nil) {
        _path = [[NSString alloc]init];
    }
    return _path;
}
-(NSString *)title
{
    if (_titles == nil) {
        _titles = [[NSString alloc]init];
    }
    return _titles;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // Override point for customization after application launch.
    
    
    [LHLPushHelper setupWithOptions:launchOptions];
    /*
     如果使用BeeCloud控制台的APP Secret初始化，代表初始化生产环境；
     如果使用BeeCloud控制台的Test Secret初始化，代表初始化沙箱测试环境;
     测试账号 appid: c5d1cba1-5e3f-4ba0-941d-9b0a371fe719
     appSecret: 39a7a518-9ac8-4a9e-87bc-7885f33cf18c
     testSecret: 4bfdd244-574d-4bf3-b034-0c751ed34fee
     由于支付宝的政策原因，测试账号的支付宝支付不能在生产环境中使用，带来不便，敬请原谅！
     */
    [BeeCloud initWithAppID:@"c675f68b-ee7c-4716-911a-95e1098bfb9a" andAppSecret:@"b51cb9b0-797c-4cf7-86be-d839b2933b3b"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(root:) name:@"tuichu" object:nil];
    
    
    UIWindow * window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];;
    self.window = window;
    self.window.backgroundColor = [UIColor whiteColor];
    
    //    self.window.backgroundColor = [UIColor whiteColor];
    
    //判断是否需要显示：（内部已经考虑版本及本地版本缓存）
    BOOL canShow = [XZMCoreNewFeatureVC canShowNewFeature];
    
    //判断是否是第一次登陆!!!!!
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        canShow = YES;
        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
    }
    else
    {
        
        canShow = NO;
//        NSLog(@"不是第一次启动");
        //如果不是第一次启动的话,使用LoginViewController作为根视图
    }
    
    if(canShow){ // 初始化新特性界面
        window.rootViewController = [XZMCoreNewFeatureVC newFeatureVCWithImageNames:@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"] enterBlock:^{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
            NSLog(@"第一次启动");
            NSLog(@"进入主页面");
            ShouYeViewController * svc = [[ShouYeViewController alloc]init];
            FenLeiViewController * fvc = [[FenLeiViewController alloc]init];
            HuoDongViewController * hvc = [[HuoDongViewController alloc]init];
            WoDeViewController * wvc = [[WoDeViewController alloc]init];
            
            TabBarViewController * tbc = [[TabBarViewController alloc]init];
            tbc.viewControllers = @[svc,fvc,hvc,wvc];
            
            nvc = [[UINavigationController alloc]initWithRootViewController:tbc];
            
            
            
            //隐藏官方的navigationbar隐藏
            nvc.navigationBarHidden = YES;
            
            self.window.rootViewController = nvc;
            
        } configuration:^(UIButton *enterButton) { // 配置进入按钮
            [enterButton setBackgroundImage:[UIImage imageNamed:@"jin"] forState:UIControlStateNormal];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"jin"] forState:UIControlStateHighlighted];
            
            //120 35
            if (SCREEN_5S) {
                _YWidth = 90;
                _YHeigh = 25;
            }else
            {
                _YWidth = 120;
                _YHeigh = 35;
            }
            enterButton.bounds = CGRectMake(0, 0, _YWidth, _YHeigh);
            enterButton.center = CGPointMake(KScreenW * 0.5, KScreenH* 0.7);
        }];
        
    }else{
        
        ShouYeViewController * svc = [[ShouYeViewController alloc]init];
        FenLeiViewController * fvc = [[FenLeiViewController alloc]init];
        HuoDongViewController * hvc = [[HuoDongViewController alloc]init];
        WoDeViewController * wvc = [[WoDeViewController alloc]init];
        
        TabBarViewController * tbc = [[TabBarViewController alloc]init];
        tbc.viewControllers = @[svc,fvc,hvc,wvc];
        
        nvc = [[UINavigationController alloc]initWithRootViewController:tbc];
        
        //隐藏官方的navigationbar隐藏
        nvc.navigationBarHidden = YES;
        
        self.window.rootViewController = nvc;
    }
    
#pragma mark - 键盘遮挡!
    
    /**
     *  下面代码解决键盘挡住视图问题!!!!!!!
     */
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    /**
     到这里结束
     */
    //1.初始化启动页广告
    XHLaunchAd *launchAd = [[XHLaunchAd alloc] initWithFrame:CGRectMake(0, 0,self.window.bounds.size.width,  self.window.bounds.size.height-150) andDuration:6];
    
    //2.设置启动页广告图片的url(必须)
    NSString *imgUrlString =@"http://active.bjxxw.com//app/img/qixi.jpg";
    
    [launchAd imgUrlString:imgUrlString completed:^(UIImage *image, NSURL *url) {
        //异步加载图片完成回调(若需根据图片实际尺寸,刷新广告frame,可在这里操作)
        launchAd.adFrame = self.window.bounds;
        NSLog(@"OK");
        
    }];
    
    //是否影藏'倒计时/跳过'按钮[默认显示](可选)
    launchAd.hideSkip = NO;
    
    //广告点击事件(可选)
    launchAd.clickBlock = ^()
    {
//        NSString *url = @"http://www.bjxxw.com/actioncenter/qixi/wap/index.html";
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"广告" object:url];

//        WebViewController * wb = [[WebViewController alloc]init];
//
//        [self.window.rootViewController presentViewController:wb animated:YES completion:^{
        
//        }];
    
        
        
        [self webview];
        
    };
    
    //3.添加至根控制器视图上
    [self.window.rootViewController.view addSubview:launchAd];
    
    [self.window makeKeyAndVisible];
    
    
    
#pragma mark - 3Dtouch
    //创建应用图标上的3D touch快捷选项
    [self creatShortcutItem];
    
    
    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    //如果是从快捷选项标签启动app，则根据不同标识执行不同操作，然后返回NO，防止调用- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
    if (shortcutItem) {
        //判断先前我们设置的快捷选项标签唯一标识，根据不同标识执行不同操作
        if([shortcutItem.type isEqualToString:@"com.mycompany.myapp.one"]){
            NSArray *arr = @[@"hello 3D Touch"];
            UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
            [self.window.rootViewController presentViewController:vc animated:YES completion:^{
            }];
        } else if ([shortcutItem.type isEqualToString:@"com.mycompany.myapp.search"]) {//进入搜索界面
            
     
            
        } else if ([shortcutItem.type isEqualToString:@"com.mycompany.myapp.share"]) {//进入分享界面
            
            EditViewController * edvc = [[EditViewController alloc]init];
            [nvc pushViewController:edvc animated:YES];
        }
        return NO;
    }
    
    
    

    
    
    return YES;

}




#pragma mark - 点击广告做的事情
-(void)webview
{
    //基本的背景
    navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor whiteColor];
    
    my = [[UILabel alloc]initWithFrame:CGRectMake(self.window.frame.size.width/2 - 100  , 10, 200, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text =  @"相约七夕.鹊桥汇";
    my.textColor = [UIColor blackColor];
    
    [self.window addSubview:navigation];
    [self.window addSubview:my];
    
    
    //返回按钮
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 28, 25, 25);
    [backButton setBackgroundImage:[UIImage imageNamed:@"fh"] forState:UIControlStateNormal];
    [backButton addTarget: self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:backButton];
    
    
    //网页视图
    NSString *url = @"http://www.bjxxw.com/actioncenter/qixi/wap/index.html";
    NSURL * urls = [NSURL URLWithString:url];
    webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.window.frame.size.width, self.window.frame.size.height - 64)];
    webview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSURLRequest * request = [NSURLRequest requestWithURL:urls];
    [webview loadRequest:request];
    [self.window addSubview:webview];
}


-(void)backClick
{
    [backButton removeFromSuperview];
    [navigation removeFromSuperview];
    [my removeFromSuperview];
    [webview removeFromSuperview];
}


#pragma mark - 进主页的动作
-(void)enter
{
    
    
    ShouYeViewController * svc = [[ShouYeViewController alloc]init];
    FenLeiViewController * fvc = [[FenLeiViewController alloc]init];
    HuoDongViewController * hvc = [[HuoDongViewController alloc]init];
    WoDeViewController * wvc = [[WoDeViewController alloc]init];
    
    TabBarViewController * tbc = [[TabBarViewController alloc]init];
    tbc.viewControllers = @[svc,fvc,hvc,wvc];
    
    nvc = [[UINavigationController alloc]initWithRootViewController:tbc];
    
    //隐藏官方的navigationbar隐藏
    nvc.navigationBarHidden = YES;
    
    self.window.rootViewController = nvc;
    

    
}

//点击退出按钮的时候所做的事情
-(void)root:(NSNotification *)click
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(root:) name:@"tuichu" object:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ShouYeViewController * svc = [[ShouYeViewController alloc]init];
    FenLeiViewController * fvc = [[FenLeiViewController alloc]init];
    HuoDongViewController * hvc = [[HuoDongViewController alloc]init];
    WoDeViewController * wvc = [[WoDeViewController alloc]init];
    
    TabBarViewController * tbc = [[TabBarViewController alloc]init];
    tbc.viewControllers = @[svc,fvc,hvc,wvc];
    
    nvc = [[UINavigationController alloc]initWithRootViewController:tbc];
    
    //隐藏官方的navigationbar隐藏
    nvc.navigationBarHidden = YES;
    
    self.window.rootViewController = nvc;
    [self.window makeKeyAndVisible];
    

}

#pragma mark - 支付完成之后跳转回app
//iOS9之后官方推荐用此方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSLog(@"options %@", options);
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
    }
    return YES;
}

#pragma mark - 推送的一些设置
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [LHLPushHelper registerDeviceToken:deviceToken];
    return;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [LHLPushHelper handleRemoteNotification:userInfo completion:nil];
    return;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
// ios7.0以后才有此功能
- (void)application:(UIApplication *)application didReceiveRemoteNotification
                   :(NSDictionary *)userInfo fetchCompletionHandler
                   :(void (^)(UIBackgroundFetchResult))completionHandler {
    [LHLPushHelper handleRemoteNotification:userInfo completion:completionHandler];

    // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新的消息哦~~~"
                                                        message:userInfo[@"aps"][@"alert"]
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        [alert show];
    }
    return;
}
#endif



- (void)d:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
#pragma mark - 角标去除
    //去除角标   -----> badgeNumber == 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//如果app在后台，通过快捷选项标签进入app，则调用该方法，如果app不在后台已杀死，则处理通过快捷选项标签进入app的逻辑在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions中
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    ShouYeViewController * svc = [[ShouYeViewController alloc]init];
    FenLeiViewController * fvc = [[FenLeiViewController alloc]init];
    HuoDongViewController * hvc = [[HuoDongViewController alloc]init];
    WoDeViewController * wvc = [[WoDeViewController alloc]init];
    
    TabBarViewController * tbc = [[TabBarViewController alloc]init];
    tbc.viewControllers = @[svc,fvc,hvc,wvc];
    
    nvc = [[UINavigationController alloc]initWithRootViewController:tbc];
    
    //隐藏官方的navigationbar隐藏
    nvc.navigationBarHidden = YES;
    
    self.window.rootViewController = nvc;
    
    [self.window makeKeyAndVisible];
    
    //判断先前我们设置的快捷选项标签唯一标识，根据不同标识执行不同操作
    if([shortcutItem.type isEqualToString:@"com.mycompany.myapp.one"]){
        NSArray *arr = @[@"hello 3D Touch"];
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
        }];
    } else if ([shortcutItem.type isEqualToString:@"com.mycompany.myapp.search"]) {//进入搜索界面

        
    } else if ([shortcutItem.type isEqualToString:@"com.mycompany.myapp.share"]) {//进入分享界面
        EditViewController * edvc = [[EditViewController alloc]init];
        [nvc pushViewController:edvc animated:YES];
    }
    
    if (completionHandler) {
        completionHandler(YES);
    }
}


//创建应用图标上的3D touch快捷选项
- (void)creatShortcutItem {
    //创建系统风格的icon
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    
    //    //创建自定义图标的icon
    //    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"分享.png"];
    
    //创建快捷选项
    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc]initWithType:@"com.mycompany.myapp.share" localizedTitle:@"发布" localizedSubtitle:@"用户发布活动" icon:icon userInfo:nil];
    
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[item];
}



@end

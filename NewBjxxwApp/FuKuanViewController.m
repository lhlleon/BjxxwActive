//
//  FuKuanViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/13.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "FuKuanViewController.h"
#import "BeeCloud.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "BCPayObjects.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface FuKuanViewController ()<BeeCloudDelegate>
{
    UIButton * backButton;
}
@end

@implementation FuKuanViewController

- (void)viewWillAppear:(BOOL)animated {
#pragma mark - 设置delegate
    [BeeCloud setBeeCloudDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    /**
     *  只是测试用的  
     一会可能就要删除
     */
    self.fd_prefersNavigationBarHidden = YES;

    
    NSLog(@"%@",_titles);
    NSLog(@"%@",_oreder);
    NSLog(@"-----%@",self.hid);
    // Do any additional setup after loading the view.
    [self createNavigaton];
    [self createBackButton];
    [self createView];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(SYPMW/2 - 50, 260, 100, 50);
    [button setTitle:@"立即付款" forState:UIControlStateNormal];//设置button显示内容
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置button字体颜色
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(dian:) forControlEvents:UIControlEventTouchUpInside];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:10.0];
    [self.view addSubview:button];
    
}

-(void)createView{
    //标题
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, SYPMW, 50)];
    title.text = self.titles;
    title.backgroundColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:title];
    //显示报名金额
    UILabel * bmje = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, SYPMW - 100, 50)];
    bmje.text = @"    报名金额";
    bmje.font = [UIFont systemFontOfSize:14];
    bmje.backgroundColor = [UIColor whiteColor];
    bmje.textColor = [UIColor lightGrayColor];
    [self.view addSubview:bmje];
    //金额显示
    CGFloat _priceX = CGRectGetMaxX(bmje.frame);
    UILabel * price = [[UILabel alloc]initWithFrame:CGRectMake( _priceX, 155, SYPMW-_priceX-60, 50)];
    price.text = self.price;
    price.textColor = [UIColor redColor];
    price.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:price];
    //元
    CGFloat _yuanX = CGRectGetMaxX(price.frame);
    UILabel * yuan = [[UILabel alloc]initWithFrame:CGRectMake(_yuanX, 155, SYPMW-_yuanX, 50)];
    yuan.textColor = [UIColor lightGrayColor];
    yuan.text = @"元";
    yuan.font = [UIFont systemFontOfSize:14];
    yuan.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:yuan];
}

#pragma mark - 以下都是付款的各种东西,,,反正宝宝也看不懂,,,就那样吧~~
-(void)dian:(UIButton *)button
{
    [self doPay:PayChannelAli];
}

- (void)doPay:(PayChannel)channel {
    /*
     一些必要的操作
     */
    NSString *title = [self.titles substringWithRange:NSMakeRange(1,15)];//订单名称截取
//    NSLog(@"billNO = = =%@",billNO);r
    //价格变化- -
    float intp = [self.price floatValue];
    NSLog(@"%f",intp);
    intp = intp * 100;
    int a = (int)intp;
    self.price = [NSString stringWithFormat:@"%d",a];//变化价格....* 100
    NSLog(@"price === %@",self.price);
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"asdf",@"asdf", nil];
    /**
     按住键盘上的option键，点击参数名称，可以查看参数说明
     **/
    BCPayReq *payReq = [[BCPayReq alloc] init];
    /**
     *  支付渠道，PayChannelWxApp,PayChannelAliApp,PayChannelUnApp,PayChannelBaiduApp
     */
    payReq.channel = PayChannelAliApp; //支付渠道
//    payReq.title = @"2016板野友美亚洲巡回演唱";//订单标题
    payReq.title = title;
//    payReq.totalFee = @"1";//订单价格; channel为BC_APP的时候最小值为100，即1元
    payReq.totalFee = self.price;
    payReq.billNo = self.oreder;//商户自定义订单号
    NSLog(@"%@",self.oreder);
//    payReq.billNo = @"adf998a8d78239f9adf223";
    payReq.scheme = @"payDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = self; //银联支付和Sandbox环境必填
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回
    [BeeCloud sendBCReq:payReq];
}

-(void)onBeeCloudResp:(BCBaseResp *)resp
{
            // 支付请求响应
            BCPayResp *tempResp = (BCPayResp *)resp;
            if (tempResp.resultCode == 0) {
                BCPayReq *payReq = (BCPayReq *)resp.request;
                //百度钱包比较特殊需要用户用获取到的orderInfo，调用百度钱包SDK发起支付
                if (payReq.channel == PayChannelBaiduApp && ![BeeCloud getCurrentMode]) {
                    
                } else {
                    //微信、支付宝、银联支付成功
#pragma mark - 支付成功之后做的事情
                    [self createAF];//做网络请求,,,给服务器返回支付消息
                    
                    [self showAlertView:resp.resultMsg];

                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            } else {
                //支付取消或者支付失败
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }

}
- (void)showAlertView:(NSString *)msg {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - 网络请求
-(void)createAF
{
    
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    self.uid =[defaults objectForKey:@"uid"];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"uid":self.uid,@"order_code":self.oreder,@"hid":self.hid};
    
    [manager POST:PDZF parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
                NSLog(@"arr= = = = = = = =%@",arr);
//        NSString * tishi = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"tishi"]];
//        NSLog(@"%@",tishi);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" = = =%@",error);
        
    }];
    

}
#pragma mark - 导航里面的东西
-(void)createNavigaton
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor orangeColor];
    
    UILabel * my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"付款";
    my.textColor = [UIColor whiteColor];
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
}

-(void)createBackButton
{
    backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"fhb"] forState:UIControlStateNormal];
    [backButton addTarget: self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}
//返回按钮
-(void)backClick:(UIButton *)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

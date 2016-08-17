//
//  ForgetPassWordViewController.m
//  北京信息网·活动
//
//  Created by LiHanlun on 16/7/5.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "XHToast.h"
#import "LXAlertView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


@interface ForgetPassWordViewController ()<UITextFieldDelegate>
{
    UITextField * nameField;
    UIButton * YesBtn;
}
@property (nonatomic,strong) UIActivityIndicatorView * activityIndicator;

@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self CreateNavigaton];
    [self backButton];
    [self createView];
}


-(void)createView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(20, 64+ (SYPMH-64)/20, SYPMW-40, (SYPMH-64)/15)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    //输入用户名
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(10, (SYPMH-64)/30 -(view.frame.size.height/2-4)/2 , SYPMW-20, view.frame.size.height/2)];
    nameField.placeholder =@"请输入邮箱";
    nameField.delegate =self;
    [view addSubview:nameField];
    
    CGFloat _enterY = CGRectGetMaxY(view.frame);
    
    
    //登录按钮
    YesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    YesBtn.frame =CGRectMake(20, _enterY + 30, SYPMW-40, view.frame.size.height);
    YesBtn.layer.cornerRadius = 5;
    YesBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:84/255.0 blue:0/255.0 alpha:1];
    //  YesBtn.userInteractionEnabled = NO;
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(YesBtn.frame.size.width/3, 0, YesBtn.frame.size.width/3, YesBtn.frame.size.height)];
    label2.text = @"提 交";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    [YesBtn addTarget:self action:@selector(tijiao:) forControlEvents:UIControlEventTouchUpInside];
    [YesBtn addSubview:label2];
    [self.view addSubview:YesBtn];
}

-(void)tijiao:(UIButton *)YesBtn
{
    
    [nameField resignFirstResponder];

    
    //    创建UIActivityIndicatorVIew  提示正在处理中
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(SYPMW/2 - 50 , (SYPMH )/2 -50 , 100, 100)];
    [view setTag:100];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    [view setAlpha:0.8];
    
    [[view layer] setBorderColor:[UIColor blackColor].CGColor];//颜色
    [[view layer]setCornerRadius:15.0];//圆角
    [view.layer setMasksToBounds:YES];
    
    
    
    [self.view addSubview:view];
    
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    [_activityIndicator setCenter:self.view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:_activityIndicator];
    
    [_activityIndicator startAnimating];
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:ForgetUrl parameters:@{@"email":nameField.text} progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSArray * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dic);
        
        NSString * st = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"tishi"]];
        
//        NSLog(@"%@",st);
        if([st isEqualToString:@"(null)"]){
            
            [_activityIndicator stopAnimating];
            
            [XHToast showCenterWithText:@"新密码已经发送至输入的邮箱\n登录邮箱查看新密码,并重新登录吧~"];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
//
            }];
        }else{
            [_activityIndicator stopAnimating];

            [XHToast showCenterWithText:st];
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error == %@",error);
    }];
}




#pragma mark - 创建导航控制器
-(void)CreateNavigaton
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor whiteColor];
    
    UILabel * my = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width/2-50 , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"找回密码";
    my.textColor = [UIColor blackColor];
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
    
}



#pragma mark - 返回按钮
-(void)backButton
{
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"fh"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}
-(void)onClick:(UIButton *)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
    //摸态视图退出
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
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

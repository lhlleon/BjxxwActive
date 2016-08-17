//
//  ZhuCeViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/29.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "ZhuCeViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "URL.h"
#import "LXAlertView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


#define width1 [[UIScreen mainScreen]bounds].size.width
#define heigh [[UIScreen mainScreen]bounds].size.height


@interface ZhuCeViewController ()<UITextFieldDelegate>
{
    UIImageView * Bimageview;
    UITextField * nameField;
    UITextField * passwordField;
    UITextField * querenPassWord;
    UITextField * email;
    UIButton * YesBtn;
}

@property (nonatomic,strong) UIActivityIndicatorView * activityIndicator;


@end

@implementation ZhuCeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0  blue:236/255.0  alpha:1];

    [self CreateNavigaton];
    [self backButton];
    [self BackView];
    //点击空白地方收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGr];
}
//点击收起键盘
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.view endEditing:YES];
}



#pragma mark - 创建对话框
-(void)BackView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(20, 64+ (heigh-64)/20, width1-40, (heigh-64)/15*4)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIView * view2= [[UIView alloc]initWithFrame:CGRectMake(10, heigh/2-1, width1-20, 1)];
    view2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:view2];
    
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, width1-20, view.frame.size.height/6-4)];
    nameField.placeholder =@"请输入用户名";
    nameField.delegate =self;
    //  nameField.backgroundColor = [UIColor orangeColor];
    [view addSubview:nameField];
    
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(10, view.frame.size.height/4+2, width1-20, view.frame.size.height/6-4)];
    passwordField.placeholder =@"请输入密码";
    passwordField.secureTextEntry =YES;
    passwordField.delegate =self;
    //  passwordField.backgroundColor = [UIColor orangeColor];
    [view addSubview:passwordField];
    
    querenPassWord = [[UITextField alloc]initWithFrame:CGRectMake(10, view.frame.size.height/2+2, width1-20, view.frame.size.height/6-4)];
    querenPassWord.placeholder =@"请输入密码";
    querenPassWord.secureTextEntry =YES;
    querenPassWord.delegate =self;
//    querenPassWord.backgroundColor = [UIColor orangeColor];
    
    [view addSubview:querenPassWord];
    
    email = [[UITextField alloc]initWithFrame:CGRectMake(10, view.frame.size.height -  view.frame.size.height/6-10, width1-20, view.frame.size.height/6-4)];
    email.placeholder =@"请输入邮箱";
    email.delegate =self;
//        email.backgroundColor = [UIColor orangeColor];
    
    [view addSubview:email];
    
    YesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    YesBtn.frame =CGRectMake(20, 140 +(self.view.frame.size.height-64)/15 * 4, width1-40, view.frame.size.height/4);
    YesBtn.layer.cornerRadius = 5;
    YesBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:84/255.0 blue:0/255.0 alpha:1];
    //  YesBtn.userInteractionEnabled = NO;
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(YesBtn.frame.size.width/3, 0, YesBtn.frame.size.width/3, YesBtn.frame.size.height)];
    label2.text = @"注 册";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    [YesBtn addTarget:self action:@selector(zhuCe) forControlEvents:UIControlEventTouchUpInside];
    [YesBtn addSubview:label2];
    [self.view addSubview:YesBtn];
    
    
}
-(void)zhuCe
{
    
    [nameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [querenPassWord resignFirstResponder];
    [email resignFirstResponder];
    
    //    创建UIActivityIndicatorVIew
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
    
    NSLog(@"111");
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    用户名username，一次密码password，二次密码repassword，邮箱email
    NSDictionary * feedback = @{@"username":nameField.text,@"password":passwordField.text,@"repassword":querenPassWord.text,@"email":email.text};
    [manager POST:ZhuCe parameters:feedback progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
        NSArray * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        
        NSString * tishi = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"tishi"]];
        NSLog(@"%@",tishi);
        
        if ([tishi isEqualToString:@"1"]) {
            
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"注册成功,即将返回登录页,并登陆账号~" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            //alert.dontDissmiss=YES;
            //设置动画类型(默认是缩放)
            //_alert.animationStyle=LXASAnimationTopShake;
            [alert showLXAlertView];
            [_activityIndicator stopAnimating];
            [view removeFromSuperview];
            
        }else
        {
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:tishi cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
                
            }];
            //alert.dontDissmiss=YES;
            //设置动画类型(默认是缩放)
            //_alert.animationStyle=LXASAnimationTopShake;
            [alert showLXAlertView];
            [_activityIndicator stopAnimating];
            [view removeFromSuperview];

        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    

}


#pragma mark - 返回按钮
-(void)backButton
{
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"fh"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

#pragma mark - 创建导航控制器
-(void)CreateNavigaton
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor whiteColor];
    
    UILabel * my = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width/2-50 , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"注册";
    my.textColor = [UIColor blackColor];
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
    
}

-(void)onClick:(UIButton *)backButton
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

//
//  LogInViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/20.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "LogInViewController.h"
#import "AFNetworking.h"
#import "URL.h"
#import "MJExtension.h"
#import "ZhuCeViewController.h"
#import "XHToast.h"
#import "ForgetPassWordViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


#define width1 [[UIScreen mainScreen]bounds].size.width
#define heigh [[UIScreen mainScreen]bounds].size.height

@interface LogInViewController ()<UITextFieldDelegate>
{
    UIImageView * Bimageview;
    UITextField * nameField;
    UITextField * passwordField;
    UIButton * YesBtn;
}
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0  blue:236/255.0  alpha:1];
    [self CreateNavigaton];
    [self backButton];
    
    [self BackView];
    
    //点击空白地方收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGr];
    

}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.view endEditing:YES];
}
#pragma mark - 创建对话框
-(void)BackView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(20, 64+ (heigh-64)/20, width1-40, (heigh-64)/15*2)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIView * view2= [[UIView alloc]initWithFrame:CGRectMake(10, heigh/2-1, width1-20, 1)];
    view2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:view2];
    
    
    //输入用户名
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(10, 2, width1-20, view.frame.size.height/2-4)];
    nameField.placeholder =@"请输入用户名";
    nameField.delegate =self;
    [view addSubview:nameField];
    
    
    //输入密码
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(10, view.frame.size.height/2+2, width1-20, view.frame.size.height/2-4)];
    passwordField.placeholder =@"请输入密码";
    passwordField.secureTextEntry =YES;
    passwordField.delegate =self;
    //  passwordField.backgroundColor = [UIColor orangeColor];
    [view addSubview:passwordField];
    
    //登录按钮
    YesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    YesBtn.frame =CGRectMake(20, 64 +(self.view.frame.size.height-64)/15 * 4, width1-40, view.frame.size.height/2);
    YesBtn.layer.cornerRadius = 5;
    YesBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:84/255.0 blue:0/255.0 alpha:1];
    //  YesBtn.userInteractionEnabled = NO;
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(YesBtn.frame.size.width/3, 0, YesBtn.frame.size.width/3, YesBtn.frame.size.height)];
    label2.text = @"登 录";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    [YesBtn addTarget:self action:@selector(LoginClick) forControlEvents:UIControlEventTouchUpInside];
    [YesBtn addSubview:label2];
    [self.view addSubview:YesBtn];
    
    
    //注册账号按钮
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(SYPMW/2 - width1/8, 79 +(self.view.frame.size.height-64)/15 * 4+(self.view.frame.size.height-64)/15, width1/4, view.frame.size.height/2);
    [registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    
    [registerButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [registerButton addTarget:self action:@selector(ForgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    CGFloat _findY = CGRectGetMaxY(registerButton.frame);
    
    //找回密码按钮
    UIButton * find = [[UIButton alloc]initWithFrame:CGRectMake( SYPMW/2 - width1/8, _findY + 15, width1/4, view.frame.size.height/2)];
    [find setTitle:@"找回密码" forState:UIControlStateNormal];
    [find setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [find addTarget:self action:@selector(PassWord:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:find];
}

-(void)PassWord:(UIButton *)find{
    //模态试图推出界面
    ForgetPassWordViewController * forger = [[ForgetPassWordViewController alloc]init];
//    [self presentViewController:forger animated:YES completion:nil];
    [self presentViewController:forger animated:YES completion:^{
        
    }];
}

-(void)ForgetClick:(UIButton *)ForgetBtn{
    ZhuCeViewController *zcv = [[ZhuCeViewController alloc]init];
    
    [self.navigationController pushViewController:zcv animated:YES];
}



-(void)LoginClick
{
    //点击按钮收起键盘
    [nameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    NSLog(@"1111");
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * feedback = @{@"username":nameField.text,@"password":passwordField.text};
    [manager POST:LogIn parameters:feedback progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSArray * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        if (dic == NULL) {
            [XHToast showCenterWithText:@"用户名或密码错误"];
        }else
        {
            [XHToast showCenterWithText:@"正在登录"];

        }
        NSString * tishi = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"tishi"]];
        NSLog(@"%@",tishi);
        
        if ([tishi isEqualToString:@"1"]) {
            //保存是否登录
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:[dic[0] objectForKey:@"tishi"] forKey:@"login"];
            [defaults synchronize];

            
            NSString * st = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"uid"]];
            
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary * dic = @{@"uid":st};
            
            [manager POST:PXinXi parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSArray * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
                
                NSString * birthday = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"birthday"]];
                NSLog(@"%@",birthday);
                NSString * face = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"face"]];
                NSLog(@"%@",face);
                NSString * sex = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"sex"]];
                NSLog(@"%@",sex);
                NSString * st = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"st"]];
                NSLog(@"%@",st);
                NSString * uid = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"uid"]];
                NSLog(@"%@",uid);
                NSString * username = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"username"]];
                NSLog(@"%@",username);
                NSString * nickname = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"nickname"]];
                NSLog(@"%@",nickname);
#pragma mark - 保存用户个人信息
                if (uid != NULL) {
                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                    
                    //2保存数据(如果设置数据之后没有同步, 会在将来某一时间点自动将数据保存到Preferences文件夹下面)
                    [defaults setObject:[dic[0] objectForKey:@"face"] forKey:@"tupian"];
                    [defaults setObject:[dic[0] objectForKey:@"uid"] forKey:@"uid"];
                    [defaults setObject:[dic[0] objectForKey:@"username"] forKey:@"username"];
                    [defaults setObject:[dic[0] objectForKey:@"birthday"] forKey:@"birthday"];
                    [defaults setObject:[dic[0] objectForKey:@"sex"] forKey:@"sex"];
                    [defaults setObject:[dic[0] objectForKey:@"st"] forKey:@"st"];
                    [defaults setObject:[dic[0] objectForKey:@"nickname"] forKey:@"nickname"];
                    
                    [defaults synchronize];
                }
                
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"touxiang" object:nil];
                            [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        
        }else
        {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)xinxiAF
{

    
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
    my.text = @"登陆";
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

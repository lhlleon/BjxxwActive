//
//  WebViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/16.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "WebViewController.h"
#import "URL.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface WebViewController ()<UIWebViewDelegate>
{
    UIWebView * wbView;
    UIButton * fanhui;
}

@property (nonatomic,strong) UIActivityIndicatorView * activityIndicator;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;

    // Do any additional setup after loading the view.
    [self CreateNavigaton];
    [self backButton];
    wbView = [[UIWebView alloc]init];
    wbView.frame = CGRectMake(0, 64, SYPMW, SYPMH - 64);
    
    NSURL * url = [NSURL URLWithString:self.url];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [wbView loadRequest:request];
    
    wbView.delegate = self;
    
    [self.view addSubview:wbView];
    
}


#pragma mark - 创建导航控制器
-(void)CreateNavigaton
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor whiteColor];
    
    UILabel * my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100  , 10, 200, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = self.titles;
    my.textColor = [UIColor blackColor];
    my.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:navigation];
    [self.view addSubview:my];

    
}


#pragma mark - 网页代理设置
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
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
    
    

    
}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    UIView * view = (UIView *)[self.view viewWithTag:100];
    [view removeFromSuperview];
    [_activityIndicator stopAnimating];
    

    if (wbView.canGoBack == YES) {
        [self fanhui];
    }else if(webView.canGoBack == NO){
        [fanhui removeFromSuperview];
    }

}

-(void)fanhui
{
    fanhui = [[UIButton alloc]initWithFrame:CGRectMake(40, 28, 50, 25)];
    [fanhui setTitle:@"返回" forState:UIControlStateNormal];
    [fanhui setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [fanhui addTarget:self action:@selector(fanhui:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fanhui];
}

-(void)fanhui:(UIButton *)fanhui
{
    [wbView goBack];
}



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

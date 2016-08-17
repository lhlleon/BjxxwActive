//
//  BaoMingViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/6.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "BaoMingViewController.h"
#import "SlideHeadView.h"
#import "QuanBuViewController.h"
#import "WeiWanChengViewController.h"
#import "YiWanChengViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface BaoMingViewController ()
{
    UIImageView * navigation;
    UILabel * my;
    
}
@end

@implementation BaoMingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNavigation];
    
    SlideHeadView *slideVC = [[SlideHeadView alloc]init];
    slideVC.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:slideVC];
    
    QuanBuViewController * wbv = [[QuanBuViewController alloc]init];
    WeiWanChengViewController * bv = [[WeiWanChengViewController alloc]init];
    YiWanChengViewController * hv = [[YiWanChengViewController alloc]init];
    
    NSArray * titleArr = @[@"全部",@"未完成",@"已完成"];
    slideVC.titlesArr = titleArr;
    [slideVC addChildViewController:wbv title:titleArr[0]];
    [slideVC addChildViewController:bv title:titleArr[1]];
    [slideVC addChildViewController:hv title:titleArr[2]];
    
    [slideVC setSlideHeadView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 创建导航控制器
-(void)createNavigation
{
    navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor orangeColor];
    
    my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"我的订单";
    my.textColor = [UIColor whiteColor];
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"fhb"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
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

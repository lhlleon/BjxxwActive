//
//  HuoDongViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/4/27.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "HuoDongViewController.h"
#import "SlideHeadView.h"
#import "WBViewController.h"
#import "BeginViewController.h"
#import "HistoricalViewController.h"



@interface HuoDongViewController ()
{
    UIImageView * navigation;
    UILabel * my;
}
@end

@implementation HuoDongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化SlideHeadView，并加进view
    [self createNavigation];
    SlideHeadView *slideVC = [[SlideHeadView alloc]init];
    [self.view addSubview:slideVC];
    
    WBViewController * wbv = [[WBViewController alloc]init];
    BeginViewController * bv = [[BeginViewController alloc]init];
    HistoricalViewController * hv = [[HistoricalViewController alloc]init];
    
    NSArray * titleArr = @[@"即将开始",@"进行中",@"历史活动"];
    slideVC.titlesArr = titleArr;
    [slideVC addChildViewController:wbv title:titleArr[0]];
    [slideVC addChildViewController:bv title:titleArr[1]];
    [slideVC addChildViewController:hv title:titleArr[2]];
    
    [slideVC setSlideHeadView];
}
#pragma mark - 创建导航控制器
-(void)createNavigation
{
    navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor orangeColor];
    
    my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"用户活动 ";
    my.textColor = [UIColor whiteColor];
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
    
    
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

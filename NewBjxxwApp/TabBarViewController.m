//
//  TabBarViewController.m
//  Bjxxw_Activity
//
//  Created by hanlunlee on 16/2/24.
//  Copyright © 2016年 Leon. All rights reserved.
//




#import "TabBarViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#define KWidth self.view.bounds.size.width
#define KHeight self.view.bounds.size.height
#define KStartMargin 20
#define KtabbarHeight 49
#define KItemWidth 40
#define KItenHeigt 31


@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTabBar];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.fd_prefersNavigationBarHidden = YES;

}

-(void)createTabBar
{
    //隐藏官方
    self.tabBar.hidden = YES;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, KHeight - KtabbarHeight, KWidth, KtabbarHeight)];
    
    //修改tabbar背景色吧！！！！想怎么修改就怎么修改吧！！！冲吧宝宝！
    imageView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    


    
    [self.view addSubview:imageView];
    NSArray * tabBarTitles = @[@"首页",@"分类",@"用户活动",@"我的"];
    NSArray * normalImages = @[@"sy",@"fl",@"yhhd",@"wd"];
    NSArray * selectedImages = @[@"sySelect",@"flSelect",@"yhhdSelect",@"wdSelect"];
    for (NSInteger i = 0 ; i < 4; i++) {
        CGFloat margin = (KWidth - 4 * KItemWidth - KStartMargin * 2)/3;
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(KStartMargin + i * (KItemWidth + margin) + 12 , 10 + 5, KItemWidth, KItenHeigt)];
        [button setTitle:tabBarTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:255/255.0 green:84/255.0 blue:0 alpha:1] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        
        //设置title偏移量
        button.titleEdgeInsets = UIEdgeInsetsMake(12, -87.5, 0, 0);
        
        [button setImage:[UIImage imageNamed:normalImages[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectedImages[i]] forState:UIControlStateSelected];
        //设置图片偏移量
        button.imageEdgeInsets = UIEdgeInsetsMake(-8, 0, 15, 15);
        
//        button.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 20, 20);
        
        
//        button.backgroundColor = [UIColor blackColor];
        
        //关闭点击闪烁
        button.adjustsImageWhenHighlighted = YES;
        button.tag = 100 + i;
        if (i==0) {
            button.selected = YES;
            //设置选中后不允许点击
            button.userInteractionEnabled = NO;
        }
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [imageView addSubview:button];
        imageView.userInteractionEnabled = YES;
    }
 

}

-(void)onClick:(UIButton *)button
{
    self.selectedIndex = button.tag -100;
    
    button.selected = YES;
    button.userInteractionEnabled = NO;
    for (NSInteger i = 0 ; i < 4; i++) {
        UIButton * bt = (id)[self.view viewWithTag:100 + i];
        if (bt.tag == button.tag) {
            continue;
        }
        bt.selected = NO;
        bt.userInteractionEnabled = YES;
    }
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



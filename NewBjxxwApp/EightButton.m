//
//  EightButton.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/4.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "EightButton.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "URL.h"


#define Klheigt self.frame.size.width/2
#define Kiwidth self.frame.size.width/4
#define totalPages 4


@interface EightButton ()
{
    UIButton * button;
}

@property (nonatomic,strong) NSArray * buttonsTitles;

@end

@implementation EightButton
-(NSArray *)buttonsTitles
{
    if (_buttonsTitles == nil) {
        _buttonsTitles = [NSArray arrayWithObjects:@"房产家居",@"汽车活动",@"赛事活动",@"电影活动",@"户外旅游",@"教育亲子",@"音乐演出",@"公益环保", nil];
    }
    return _buttonsTitles;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

        
        [self createButton];
    }
    return self;
}


-(void)createButton
{
    NSArray * image = [NSArray array];
    image = @[@"fcjj.png",@"qchd.png",@"sshd.png",@"dyhd.png",@"hwly.png",@"xjqy.png",@"yyyc.png",@"gyhb.png"];
    for (int i = 0 ; i < 2; i++) {
        for (int a = 0 ; a < 4;  a++) {

            
            //创建button
            button = [[UIButton alloc]initWithFrame:CGRectMake(Kiwidth * a + 20, Kiwidth * i + 10, Kiwidth-40, Kiwidth - 40)];
            [button setBackgroundImage:[UIImage imageNamed:image[4*i + a]] forState:UIControlStateNormal];
            
            
            UILabel * labels = [[UILabel alloc]initWithFrame:CGRectMake(Kiwidth * a + 5, Kiwidth * i +Kiwidth - 20, Kiwidth - 10, 10)];
            labels.text = self.buttonsTitles[4 * i + a];
            //            labels.numberOfLines = 1;
            //            labels.minimumFontSize = 10;
            labels.textAlignment = NSTextAlignmentCenter;
            
    
            
            if (SCREEN_5S || SCREEN_4S) {
                labels.font = [UIFont systemFontOfSize:12];
            }else if (SCREEN_6S){
                labels.font = [UIFont systemFontOfSize:13];
            }else{
                labels.font = [UIFont systemFontOfSize:15];
            }
            
            button.tag =  4*i + a;
            
            
            
            [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:labels];
            [self addSubview:button];
            
        }
    }
}



#pragma mark - button的点击事件
-(void)click:(UIButton *)button
{
    NSArray * hidArr = @[@"186",@"184",@"185",@"163",@"167",@"178",@"183",@"172"];
    NSString * st = [NSString stringWithFormat:@"%@",hidArr[button.tag]];
    NSString * title = [NSString stringWithFormat:@"%@",self.buttonsTitles[button.tag]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"anniuname" object:title];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"anniu" object:st];
}


























@end

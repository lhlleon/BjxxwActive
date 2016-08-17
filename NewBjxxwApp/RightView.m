//
//  RightView.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/10.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "RightView.h"

@interface RightView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * rightTable;
}

@end


@implementation RightView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createList];
        
        
    }
    return self;
}

-(void)createList
{
    rightTable = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
    rightTable.delegate = self;
    rightTable.dataSource = self;
    
    [self addSubview:rightTable];
}

#pragma mark - 数据源


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (section == 0) {
        return 3;
    }
    else
    {
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        
        

        //所有文字，图片
        UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(30, 13, 25, 25)];
        
        UILabel * title1 = [[UILabel alloc]initWithFrame:CGRectMake(75 , 15, 100, 20)];
        
        UIImageView * jianTou = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 30, 10, 25,25)];
        jianTou.image = [UIImage imageNamed:@"jiantou"];
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    imageView1.image = [UIImage imageNamed:@"qlhc"];
                    title1.text = @"清理缓存";
                    break;
                case 1:
                    imageView1.image = [UIImage imageNamed:@"jcgx"];
                    title1.text = @"检查更新";
                    break;
                case 2:
                    imageView1.image = [UIImage imageNamed:@"yjfk"];
                    title1.text = @"意见反馈";
                    break;
                default:
                    break;
            }
        }else
        {
            switch (indexPath.row) {
                case 0:
                    imageView1.image = [UIImage imageNamed:@"gywm"];
                    title1.text = @"关于我们";
                    break;
                case 1:
                    imageView1.image = [UIImage imageNamed:@"kfdh"];
                    title1.text = @"客服电话";
                    break;
                    
                default:
                    break;
            }
        }
        

        [cell addSubview:imageView1];
        [cell addSubview:title1];
        [cell addSubview:jianTou];
    }
    return cell;
    
    
}






-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"1");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


@end

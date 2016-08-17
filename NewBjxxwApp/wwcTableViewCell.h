//
//  wwcTableViewCell.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/14.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaoMingModel.h"

@interface wwcTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UILabel *zhuangtai;

@property (weak, nonatomic) IBOutlet UILabel *shutiao;

@property (weak, nonatomic) IBOutlet UILabel *bjxxw;

@property (weak, nonatomic) IBOutlet UILabel *fga;

@property (weak, nonatomic) IBOutlet UILabel *fgb;

-(void)loadViewsWithModel:(BaoMingModel *)model;

@property (nonatomic,strong) UIButton * dingdanButton;

@property (nonatomic,strong) UIButton * dianping;

@property (nonatomic,strong) NSString * order_code;

@property (nonatomic,strong) NSString * hid;

@property (nonatomic,strong) NSString * uid;

@end

//
//  HDXQTableViewCell.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/27.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHXQModel.h"

@interface HDXQTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *pleace;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *qq;

//一条线
@property (weak, nonatomic) IBOutlet UILabel *Xview;

-(void)loadViewsWithModel:(YHXQModel *)model;

@end

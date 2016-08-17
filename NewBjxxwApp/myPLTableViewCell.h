//
//  myPLTableViewCell.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/16.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYPLModel.h"

@interface myPLTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titles;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *stime;

@property (weak, nonatomic) IBOutlet UIButton *sc;

@property (weak, nonatomic) IBOutlet UILabel *kuang;

-(void)loadViewsWithModel:(MYPLModel *)model;

@end

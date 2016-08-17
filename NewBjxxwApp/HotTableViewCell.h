//
//  HotTableViewCell.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/13.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotModel.h"

@interface HotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *starTime;
@property (weak, nonatomic) IBOutlet UILabel *pleace;
@property (weak, nonatomic) IBOutlet UILabel *introduce;
@property (weak, nonatomic) IBOutlet UIImageView *ljImage;


@property (weak, nonatomic) IBOutlet UIImageView *ljck;

-(void)loadViewsWithModel:(HotModel *)model;


@end

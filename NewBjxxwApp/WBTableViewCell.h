//
//  WBTableViewCell.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/25.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBModel.h"

@interface WBTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backIm;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *pleace;

-(void)loadViewsWithModel:(WBModel *)model;

@end

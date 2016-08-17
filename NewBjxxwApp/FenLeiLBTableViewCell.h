//
//  FenLeiLBTableViewCell.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/1.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FenLeiModel.h"

@interface FenLeiLBTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *starTime;
@property (weak, nonatomic) IBOutlet UILabel *pleace;
@property (weak, nonatomic) IBOutlet UILabel *introduce;
@property (weak, nonatomic) IBOutlet UIImageView *ljImage;


@property (weak, nonatomic) IBOutlet UIImageView *ljck;

-(void)loadViewsWithModel:(FenLeiModel *)model;
@end

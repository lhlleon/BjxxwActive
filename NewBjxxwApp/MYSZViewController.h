//
//  MYSZViewController.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/24.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSZViewController : UIViewController

@property (nonatomic,strong) UIPickerView * datePick;

@property (weak, nonatomic) IBOutlet UILabel *mylabel;
@property (weak, nonatomic) IBOutlet UIImageView *txImage;
@property (weak, nonatomic) IBOutlet UIButton *txSelect;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *Sex;
@property (weak, nonatomic) IBOutlet UIButton *briSelect;
@property (weak, nonatomic) IBOutlet UILabel *brithDay;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *ncLabel;

@property (weak, nonatomic) IBOutlet UITextField *ncText;
@property (weak, nonatomic) IBOutlet UILabel *xbLabel;

@end

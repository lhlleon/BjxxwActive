//
//  FuKuanViewController.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/13.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeeCloud.h"

@interface FuKuanViewController : UIViewController

@property (nonatomic,strong) NSString * price;//价格

@property (nonatomic,strong) NSString * titles;//标题

@property (nonatomic,strong) NSString * oreder;//订单号

@property (strong, nonatomic) BCBaseResp *orderList;

@property (nonatomic,strong) NSString * hid;

@property (nonatomic,strong) NSString * uid;//用户id

@end

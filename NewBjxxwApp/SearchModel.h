//
//  SearchModel.h
//  北京信息网·活动
//
//  Created by LiHanlun on 16/6/20.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

@property (nonatomic,strong) NSString * area;

@property (nonatomic,strong) NSString * de;//结束时间

@property (nonatomic,strong) NSString * hid;//id

@property (nonatomic,strong) NSString * path;//图片

@property (nonatomic,strong) NSString * place;//地点

@property (nonatomic,strong) NSString * st;//开始时间

@property (nonatomic,strong) NSString * title;//标题

@end

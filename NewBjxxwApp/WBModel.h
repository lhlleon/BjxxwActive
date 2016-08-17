//
//  WBModel.h
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/25.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBModel : NSObject

//id
@property (nonatomic,strong) NSString * hid;
//地点
@property (nonatomic,strong) NSString * place;
//是否收藏
@property (nonatomic,strong) NSString * shoucang;
//开始时间
@property (nonatomic,strong) NSString * sta;
//结束时间
@property (nonatomic,strong) NSString * stp;
//标题
@property (nonatomic,strong) NSString * title;
//显示图片
@property (nonatomic,strong) NSString * titlepage;

@end

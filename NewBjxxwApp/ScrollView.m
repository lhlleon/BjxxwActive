//
//  ScrollView.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/12.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "ScrollView.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "AYPageControl.h"

#import "URL.h"


@interface ScrollView ()<UIScrollViewDelegate>

{
    UIScrollView * SYScroll;
    NSMutableArray * lunDate;
    UIImageView * imageView;
    NSInteger page;

}

@property (nonatomic, strong) AYPageControlView *pageControlView;


@end

@implementation ScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                [self AF];
        [self createScroll];

    }
    return self;
}

#pragma mark - 滚动试图的网络数据
-(void)AF
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:LunBoUrl parameters:self progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        lunDate = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
//        NSLog(@"111%@",lunDate);
        [self aaaa];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)aaaa
{
    //添加图片链接
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i< lunDate.count; i++) {
        NSString * str = [NSString stringWithFormat:@"%@%@",BaseUrl,[lunDate[i] objectForKey:@"path"]];
        NSLog(@"%@",str);
        [array addObject:str];
    }
    
    SYScroll.contentSize = CGSizeMake(self.frame.size.width * array.count, self.frame.size.width/2);

    for (int i = 0; i < array.count; i++) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.width/2)];
        NSURL * url = [NSURL URLWithString:array[i]];
//        NSLog(@"%@",url);
    
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tphc1"]];
        [SYScroll addSubview:imageView];
        self.pageControlView = [[AYPageControlView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-50, self.frame.size.width/2 -20, 100, 20)];
        //设置小球的页数
        self.pageControlView.numberOfPages = array.count;
        //绑定对应的scroll
        self.pageControlView.bindingScrollView = SYScroll;
        //  设置形变小球的颜色
        self.pageControlView.selectedColor = [UIColor lightGrayColor];
        //  设置背景小球的颜色
        self.pageControlView.unSelectedColor = [UIColor whiteColor];
        self.pageControlView.backgroundColor = [UIColor clearColor];

        [self addSubview:self.pageControlView];
    }
}


#pragma mark - pageControll的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {//  将scrollview的contentOffset.x赋值给pageControl进行计算
    self.pageControlView.contentOffset_x = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {//  scrollview滑动玩后将最终的contentOffset传递过去
    page =scrollView.contentOffset.x;

    self.pageControlView.lastContentOffset_x = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {//  scrollview滑动玩后将最终的contentOffset传递过去
    self.pageControlView.lastContentOffset_x = scrollView.contentOffset.x;
}



#pragma mark - 创建滚动视图
-(void)createScroll
{
    SYScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/2)];

    //隐藏横向纵向滚动条
    SYScroll.showsHorizontalScrollIndicator = NO;
    SYScroll.showsVerticalScrollIndicator = NO;
    //设置按页滚动效果
    SYScroll.pagingEnabled = YES;
    
    SYScroll.delegate = self;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
    [SYScroll addGestureRecognizer:singleTap];
    [self addSubview:SYScroll];
}

#pragma mrk - 滚动视图的点击事件
-(void)onClickImage:(UITapGestureRecognizer *)singleTap
{
//    page = SYScroll.frame.origin.x;
    /**
     发送通知给controller
     */
    
#pragma mark - 轮播图点击事件，是活的，，可以无限添加  通过arr。count判断
    for (int i = 0; i < lunDate.count; i++) {
        if (page == SYPMW * i) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"lunbo1url" object:[lunDate[i] objectForKey:@"surl"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"lunbo1title" object:[lunDate[i] objectForKey:@"title"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"tiaozhuan1" object:nil];
        }
    }
    
    

}

@end

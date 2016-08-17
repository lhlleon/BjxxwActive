//
//  EightButtonViewController.m
//  北京信息网·活动
//
//  Created by LiHanlun on 16/6/17.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "EightButtonViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "FenLeiModel.h"
#import "FenLeiLBTableViewCell.h"
#import "XQViewController.h"
#import "XTPopView.h"
#import "HamburgerButtonTwo.h"
#import "HamburgerButtonOne.h"
#import "UINavigationController+FDFullscreenPopGesture.h"



@interface EightButtonViewController ()<UITableViewDelegate,UITableViewDataSource,selectIndexPathDelegate>
{
    UIButton * backButton;
    UITableView * anniuTable;
}

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic, strong) HamburgerButtonTwo *customBtn;//选择时间时间的button

@property (nonatomic,strong) NSString * ftime;

@end

@implementation EightButtonViewController
-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self createNavigaton];
    [self createBackButton];
    
    anniuTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYPMW, SYPMH - 64) style:UITableViewStylePlain];
    anniuTable.delegate = self;
    anniuTable.dataSource = self;
    [self.view addSubview:anniuTable];
    [self Refresh];
    [anniuTable headerBeginRefreshing];
#pragma mark - 选择时间的button
    
    
    /**
     
     选择器的动画  包括位置
     
     */
    _customBtn = [[HamburgerButtonTwo alloc] initWithFrame:CGRectZero];
    _customBtn.transform = CGAffineTransformMakeScale(0.5, 0.5);
    _customBtn.center = CGPointMake(SYPMW - 40, 42);
    [_customBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_customBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qxdh:) name:@"取消动画" object:nil];
}

-(void)qxdh:(NSNotification *)click
{
    self.customBtn.showMenu = !self.customBtn.showMenu;
}

- (void)btnClick:(UIButton *)btn
{
    
    self.customBtn.showMenu = !self.customBtn.showMenu;
    //初始化的一些东西
    CGPoint point = CGPointMake(_customBtn.center.x,_customBtn.frame.origin.y +45);
    XTPopView *view1 = [[XTPopView alloc] initWithOrigin:point Width:130 Height:40 * 4 Type:XTTypeOfUpRight Color:[UIColor colorWithRed:0.2737 green:0.2737 blue:0.2737 alpha:1.0]];
    view1.dataArray = @[@"全部时间",@"今天", @"一周内", @"一个月内"];
    //    view1.images = @[@"发起群聊",@"添加朋友", @"扫一扫", @"付款"];
    view1.fontSize = 13;
    view1.row_height = 40;
    view1.titleTextColor = [UIColor whiteColor];
    view1.delegate = self;
    [view1 popView];
}



- (void)selectIndexPathRow:(NSInteger)index
{
    
    self.customBtn.showMenu = !self.customBtn.showMenu;
    
    
    switch (index) {
        case 0:
        {
//            self.ftime = @"";
        }
            break;
        case 1:
        {
//            self.ftime = @"1";
        }
            break;
        case 2:
        {
//            self.ftime = @"2";
        }
            break;
        case 3:
        {
//            self.ftime = @"3";
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - 添加刷新控件
-(void)Refresh{
    
    //下拉刷新
    [anniuTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    // [_collectionView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [anniuTable addFooterWithTarget:self action:@selector(footerRereshing)];
    //一些设置
    // 设置文字
    anniuTable.headerPullToRefreshText = @"下拉可以刷新了";
    anniuTable.headerReleaseToRefreshText = @"松开马上刷新了";
    anniuTable.headerRefreshingText = @"努力加载中~";
    
    anniuTable.footerPullToRefreshText = @"上拉可以加载更多数据了";
    anniuTable.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    anniuTable.footerRefreshingText = @"努力加载中~";
}



//下拉刷新
-(void)headerRereshing
{
    _page = 0;
    NSString * page  = [NSString stringWithFormat:@"%d",_page];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"page":page,@"ftime":@"",@"classid":self.cid};
    
    [manager POST:FLZUrl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.dataSource removeAllObjects];
        
        //        NSLog(@"lalalalalala%@",responseObject);
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (arr == nil) {
            NSLog(@"1");
        }else{
            NSLog(@"2");
        }
        NSArray * arr2 = [FenLeiModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
        
        [anniuTable reloadData];
        [anniuTable headerEndRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}

//上拉加载
-(void)footerRereshing
{
    
    _page++;
    if (_page == 1) {
        [anniuTable footerEndRefreshing];
        return;
    }
    
    NSString * page  = [NSString stringWithFormat:@"%d",_page];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"page":page,@"ftime":@"",@"classid":self.cid};
    
    [manager POST:FLZUrl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        
        
        NSArray * arr2 = [FenLeiModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
        
        
        [anniuTable reloadData];
        [anniuTable footerEndRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}


#pragma mark - tableView的delegate 和 datesource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * iden = @"hello";
    
    FenLeiLBTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (cell1 == nil) {
        cell1 = [[[NSBundle mainBundle]loadNibNamed:@"FenLeiLBTableViewCell" owner:self options:nil]lastObject];
    }
    //    if (_dataSource.count <= 1) {
    //            [XHToast showBottomWithText:@"暂无数据"];
    //    }
    
    //    NSLog(@"%lu",(unsigned long)_dataSource.count);
    
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    FenLeiModel * model = (FenLeiModel *)[_dataSource objectAtIndex:indexPath.row];
    [cell1 loadViewsWithModel:model];
    
    //    cell1.textLabel.text = self.la;
    //    NSLog(@"%@",self.la);
    
    
    return cell1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_5S) {
        return 150;
    }if (SCREEN_6S) {
        return 180;
    }else{
        return 200;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XQViewController * xqv = [[XQViewController alloc]init];
    FenLeiModel * mode = (FenLeiModel *)[_dataSource objectAtIndex:indexPath.row];
    xqv.hid = mode.hid;
    [self.navigationController pushViewController:xqv animated:YES];
}



#pragma mark - 导航里面的东西
-(void)createNavigaton
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor orangeColor];
    
    UILabel * my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100  , 10, 200, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = self.titles;
    my.textColor = [UIColor whiteColor];
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
}


-(void)createBackButton
{
    backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"fhb"] forState:UIControlStateNormal];
    [backButton addTarget: self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}

//返回按钮
-(void)backClick:(UIButton *)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

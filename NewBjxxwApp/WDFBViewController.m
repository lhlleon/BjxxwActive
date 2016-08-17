//
//  WDFBViewController.m
//  北京信息网·活动
//
//  Created by LiHanlun on 16/7/1.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "WDFBViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "FenLeiModel.h"
#import "FenLeiLBTableViewCell.h"
#import "YHXQViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "MJRefresh.h"


@interface WDFBViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView * navigation;
    UILabel * my;
    UITableView * wdfbTable;
}
@property (nonatomic,strong) NSString * uid;

@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,assign) int page;//页码

@end

@implementation WDFBViewController
-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

-(NSString *)uid
{
    if (_uid == nil) {
        _uid = [[NSString alloc]init];
    }
    return _uid;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    self.uid =[defaults objectForKey:@"uid"];
    
    // Do any additional setup after loading the view.
    [self createNavigation];
    [self createTable];
    [self Refresh];
    [wdfbTable headerBeginRefreshing];
}

#pragma mark - 添加刷新控件
-(void)Refresh{
    //下拉刷新
    [wdfbTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    // [_collectionView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [wdfbTable addFooterWithTarget:self action:@selector(footerRereshing)];
    //一些设置
    // 设置文字
    wdfbTable.headerPullToRefreshText = @"下拉可以刷新了";
    wdfbTable.headerReleaseToRefreshText = @"松开马上刷新了";
    wdfbTable.headerRefreshingText = @"努力加载中~";
    
    wdfbTable.footerPullToRefreshText = @"上拉可以加载更多数据了";
    wdfbTable.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    wdfbTable.footerRefreshingText = @"努力加载中~";
}

-(void)headerRereshing{
    
    _page = 0;
    NSString * page  = [NSString stringWithFormat:@"%d",_page];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:WDFBUrl parameters:@{@"uid":self.uid,@"page":page} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.dataSource removeAllObjects];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",arr);
        if (arr == NULL) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SYPMW, SYPMH - 64)];
            view.backgroundColor = [UIColor whiteColor];
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(SYPMW/4, self.view.frame.size.height/2 - SYPMW/4 -64, SYPMW/2, SYPMW/2 )];
            image.image = [UIImage imageNamed:@"meiyoufabu"];
            [view addSubview:image];
            [self.view addSubview:view];
        }
        
        NSArray * arr2 = [FenLeiModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
        
        [wdfbTable reloadData];
        [wdfbTable headerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)footerRereshing
{
    _page++;
    NSString * page  = [NSString stringWithFormat:@"%d",_page];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:WDFBUrl parameters:@{@"uid":self.uid,@"page":page} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray * arr2 = [FenLeiModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
        
        [wdfbTable reloadData];
        [wdfbTable footerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}



-(void)createTable
{
    wdfbTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYPMW, SYPMH-64) style:UITableViewStylePlain];
    wdfbTable.delegate = self;
    wdfbTable.dataSource = self;
    [self.view addSubview:wdfbTable];
}

#pragma mark - tableview的delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * iden = @"klkl";
    FenLeiLBTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FenLeiLBTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FenLeiModel * model = (FenLeiModel *)[_dataSource objectAtIndex:indexPath.row];
    [cell loadViewsWithModel:model];
    return cell;
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
    FenLeiModel * model = (FenLeiModel *)[_dataSource objectAtIndex:indexPath.row];
    NSLog(@"%@",model.hid);
    YHXQViewController * yhxq = [[YHXQViewController alloc]init];
    yhxq.hid = model.hid;
    [self.navigationController pushViewController:yhxq animated:YES];
}

#pragma mark - 创建导航控制器
-(void)createNavigation
{
    navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor orangeColor];
    
    my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"我的发布";
    my.textColor = [UIColor whiteColor];
    if (SCREEN_5S || SCREEN_4S) {
        my.font = [UIFont systemFontOfSize:14];
    }else{
        my.font = [UIFont systemFontOfSize:17];
    }
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"fhb"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}
-(void)onClick:(UIButton *)backButton
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

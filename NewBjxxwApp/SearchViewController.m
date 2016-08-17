//
//  SearchViewController.m
//  北京信息网·活动
//
//  Created by LiHanlun on 16/6/20.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "SearchViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "SearchModel.h"
#import "SearchTableViewCell.h"
#import "XQViewController.h"
#import "MJRefresh.h"


@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * searchTableView;
}
@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,assign) int page;

@end

@implementation SearchViewController


-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateNavigaton];
    [self backButton];

    searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYPMW, SYPMH - 64) style:UITableViewStylePlain];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    [self.view addSubview:searchTableView];
    [self Refresh];
    [searchTableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
}

#pragma mark - 添加刷新控件
-(void)Refresh{
    
    //下拉刷新
    [searchTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // [_collectionView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [searchTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    //一些设置
    // 设置文字
    searchTableView.headerPullToRefreshText = @"下拉可以刷新了";
    searchTableView.headerReleaseToRefreshText = @"松开马上刷新了";
    searchTableView.headerRefreshingText = @"努力加载中~";
    
    searchTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    searchTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    searchTableView.footerRefreshingText = @"努力加载中~";
}


#pragma mark - 刷新加载
-(void)headerRereshing
{
    _page = 0;
    NSString * page  = [NSString stringWithFormat:@"%d",_page];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:Business parameters:@{@"result":self.title,@"page":page} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.dataSource removeAllObjects];
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",arr);
        NSArray * arr2 = [SearchModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
        
        [searchTableView reloadData];
        [searchTableView headerEndRefreshing];
        
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
    
    [manager POST:Business parameters:@{@"result":self.title,@"page":page} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",arr);
        NSArray * arr2 = [SearchModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
        
        [searchTableView reloadData];
        [searchTableView footerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}

#pragma mark - 代理设置
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * iden = @"dee";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
//    }
//    cell.textLabel.text = @"111";
    SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SearchModel * model = (SearchModel *)[_dataSource objectAtIndex:indexPath.row];
    [cell loadViewsWithModel:model];
    
    self.cellHeight = CGRectGetMaxY(cell.place.frame) + 8;
#pragma mark - 赋值价格
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XQViewController * xqv = [[XQViewController alloc]init];
    SearchModel * model = (SearchModel *)[_dataSource objectAtIndex:indexPath.row];

    xqv.hid = model.hid;
    [self.navigationController pushViewController:xqv animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

#pragma mark - 创建导航控制器
-(void)CreateNavigaton
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor whiteColor];
    
    UILabel * my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = self.title;
    my.textColor = [UIColor blackColor];
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
    
}
-(void)backButton
{
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"fh"] forState:UIControlStateNormal];
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

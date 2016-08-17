//
//  BeginViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/23.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "BeginViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "WBModel.h"
#import "WBTableViewCell.h"
#import "YHXQViewController.h"
#import "MJRefresh.h"


@interface BeginViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView * wbTable;
}
@property (nonatomic,assign)int page;

@property (nonatomic,strong)NSMutableArray * dateSource;

@end

@implementation BeginViewController

-(NSMutableArray *)dateSource
{
    if (_dateSource == nil) {
        _dateSource = [NSMutableArray array];
    }
    return _dateSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTable];
    [self Refresh];
    [wbTable headerBeginRefreshing];
}
-(void)Refresh{
    
    //下拉刷新
    [wbTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    // [_collectionView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [wbTable addFooterWithTarget:self action:@selector(footerRereshing)];
    //一些设置
    // 设置文字
    wbTable.headerPullToRefreshText = @"下拉可以刷新了";
    wbTable.headerReleaseToRefreshText = @"松开马上刷新了";
    wbTable.headerRefreshingText = @"努力加载中~";
    
    wbTable.footerPullToRefreshText = @"上拉可以加载更多数据了";
    wbTable.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    wbTable.footerRefreshingText = @"努力加载中~";
}



#pragma mark - 网路请求
-(void)headerRereshing
{
    _page = 0;
    NSString * page  = [NSString stringWithFormat:@"%d",_page];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary * dic = @{@"page":page,@"ftime":@"2"};
    
    [manager POST:YHLUrl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.dateSource removeAllObjects];

        [self.dateSource removeAllObjects];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
//        NSLog(@"arr==%@",arr);
        
        NSArray * arr2 = [WBModel mj_objectArrayWithKeyValuesArray:arr];
        [self.dateSource addObjectsFromArray:arr2];
        
//        NSLog(@"date == %@",self.dateSource);
        
        [wbTable reloadData];
        [wbTable headerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}

-(void)footerRereshing{
    _page++;
    NSString * page  = [NSString stringWithFormat:@"%d",_page];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary * dic = @{@"page":page,@"ftime":@"2"};
    
    [manager POST:YHLUrl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * arr2 = [WBModel mj_objectArrayWithKeyValuesArray:arr];
        [self.dateSource addObjectsFromArray:arr2];
        
        [wbTable reloadData];
        [wbTable footerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark - tableView初始化
-(void)createTable
{
    wbTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SYPMW, SYPMH-156) style:UITableViewStylePlain];
    wbTable.delegate = self;
    wbTable.dataSource = self;
    wbTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:wbTable];
}

#pragma mark - table delegate 和 datesource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dateSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //唯一辨识符
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    WBTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WBTableViewCell" owner:self options:nil]lastObject];
    }
    
    WBModel  * model = (WBModel *)[_dateSource objectAtIndex:indexPath.row];
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 10, 10);
    
    [cell loadViewsWithModel:model];
    
    //点击时背景不变色
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_5S) {
        return 280;
    }else if(SCREEN_6S){
        return 330;
    }else{
        return 350;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YHXQViewController * yhxq = [[YHXQViewController alloc]init];
    yhxq.hid = [_dateSource [indexPath.row] hid];
    [self.navigationController pushViewController:yhxq animated:YES];
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

//
//  TableViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/30.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "TableViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "FenLeiModel.h"
#import "URL.h"
#import "FenLeiLBTableViewCell.h"
#import "MJRefresh.h"
#import "MJRefresh.h"
#import "XQViewController.h"
#import "XHToast.h"

@interface TableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * table;
}

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray * dataSource;

@end


@implementation TableViewController

-(NSString *)ftime
{
    if (_ftime == nil ) {
        _ftime = [[NSString alloc]init];
    }
    return _ftime;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

-(void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, self.view.frame.size.height-158) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self Refresh];
    [table headerBeginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClick:) name:@"fenleishuaxin" object:nil];


}

-(void)onClick:(NSNotification *)click
{
    self.ftime = click.object;
    [table headerBeginRefreshing];
    
}

#pragma mark - 添加刷新控件
-(void)Refresh{
    
    //下拉刷新
    [table addHeaderWithTarget:self action:@selector(headerRereshing)];
    // [_collectionView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [table addFooterWithTarget:self action:@selector(footerRereshing)];
    //一些设置
    // 设置文字
    table.headerPullToRefreshText = @"下拉可以刷新了";
    table.headerReleaseToRefreshText = @"松开马上刷新了";
    table.headerRefreshingText = @"努力加载中~";
    
    table.footerPullToRefreshText = @"上拉可以加载更多数据了";
    table.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    table.footerRefreshingText = @"努力加载中~";
}



//下拉刷新
-(void)headerRereshing
{
    _page = 0;
    NSString * page  = [NSString stringWithFormat:@"%d",_page];

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"page":page,@"ftime":self.ftime,@"classid":self.la};
    
    [manager POST:FLZUrl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.dataSource removeAllObjects];
        
        //        NSLog(@"lalalalalala%@",responseObject);
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

//        if (arr == NULL) {
//            [XHToast showBottomWithText:@"暂无数据"];
//        }else{
////            [XHToast showBottomWithText:@"有数据"];
//        }
        
        NSArray * arr2 = [FenLeiModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
        
        [table reloadData];
        [table headerEndRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}

//上拉加载
-(void)footerRereshing
{
    
    _page++;
    
    NSString * page  = [NSString stringWithFormat:@"%d",_page];

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"page":page,@"ftime":self.ftime,@"classid":self.la};
    
    [manager POST:FLZUrl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray * arr2 = [FenLeiModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];

        
        [table reloadData];
        [table footerEndRefreshing];
        
        
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

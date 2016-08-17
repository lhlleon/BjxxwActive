//
//  PingLunViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/6.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "PingLunViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MYPLModel.h"
#import "myPLTableViewCell.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface PingLunViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView * navigation;
    UILabel * my;
    UITableView * tableview;//
}

@property (nonatomic,strong) NSString * uid;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation PingLunViewController
-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    self.uid =[defaults objectForKey:@"uid"];
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    // Do any additional setup after loading the view.
    [self createNavigation];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYPMW, SYPMH - 64) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    [self Refresh];

    [tableview headerBeginRefreshing];
}


#pragma mark - 添加刷新控件
-(void)Refresh{
    
    //下拉刷新
    [tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    // [_collectionView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    //一些设置
    // 设置文字
    tableview.headerPullToRefreshText = @"下拉可以刷新了";
    tableview.headerReleaseToRefreshText = @"松开马上刷新了";
    tableview.headerRefreshingText = @"努力加载中~";
    
    tableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
    tableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    tableview.footerRefreshingText = @"努力加载中~";
}
-(void)headerRereshing
{
    
    _page = 0;
    NSString * page  = [NSString stringWithFormat:@"%d",_page];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"page":page,@"uid":self.uid};
    
    [manager POST:myPL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.dataSource removeAllObjects];
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        NSLog(@"%@",arr);
        
        NSArray * arr2 = [MYPLModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
//
//        //        NSLog(@"%@",_dataSource);
//        
//        
        [tableview reloadData];
        [tableview headerEndRefreshing];
        
        
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
    
    NSDictionary * dic = @{@"page":page,@"uid":self.uid};
    
    [manager POST:myPL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",arr);
        
        NSArray * arr2 = [MYPLModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
        //
        //        //        NSLog(@"%@",_dataSource);
        //
        //
        [tableview reloadData];
        [tableview footerEndRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}


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
        NSString * iden = @"helloo";
        
        myPLTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
        
        if (cell1 == nil) {
            cell1 = [[[NSBundle mainBundle]loadNibNamed:@"myPLTableViewCell" owner:self options:nil]lastObject];
            
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        MYPLModel * model = (MYPLModel *)[_dataSource objectAtIndex:indexPath.row];
        [cell1 loadViewsWithModel:model];
        
        //    cell1.textLabel.text = self.la;
        //    NSLog(@"%@",self.la);
        
        
        return cell1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}



#pragma mark - 创建导航控制器
-(void)createNavigation
{
    navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor orangeColor];
    
    my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"我的评论";
    my.textColor = [UIColor whiteColor];
    
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

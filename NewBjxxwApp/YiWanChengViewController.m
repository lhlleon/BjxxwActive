//
//  QuanBuViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/6.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "YiWanChengViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "BaoMingModel.h"
#import "TableViewCell.h"
#import "LXAlertView.h"
#import "MJRefresh.h"


@interface YiWanChengViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * QBTable;
}

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSString * uid;

@property (nonatomic,strong) NSMutableArray * dateSource;

@property (nonatomic,assign)CGFloat cellHeight;

@property (nonatomic,strong) NSString * panDuan;

@end

@implementation YiWanChengViewController

-(NSMutableArray *)dateSource
{
    if (!_dateSource ) {
        _dateSource = [[NSMutableArray alloc]init];
    }
    return _dateSource;
}
-(void)viewWillAppear:(BOOL)animated
{
        [QBTable headerBeginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.uid =[defaults objectForKey:@"uid"];
    //tableview初始化
    QBTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYPMW, SYPMH - 108) style:UITableViewStylePlain];
    QBTable.delegate = self;
    QBTable.dataSource = self;
    [self.view addSubview:QBTable];
    //添加刷新
    [self setupRefresh];

    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxin:) name:@"shuaxin3" object:nil];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 通知收取!
-(void)shuaxin:(NSNotification *)click
{
    NSLog(@"点击了  准备刷新");
    /**
     *  刷新界面
     */
        [self headerRereshing];

}
#pragma mark - 上拉刷新下拉加载
//开始刷新自定义方法
- (void)setupRefresh
{
    //下拉刷新
    [QBTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [QBTable addFooterWithTarget:self action:@selector(footerRereshing)];
    //一些设置
    // 设置文字
    QBTable.headerPullToRefreshText = @"下拉可以刷新了";
    QBTable.headerReleaseToRefreshText = @"松开马上刷新了";
    QBTable.headerRefreshingText = @"刷新中。。。";
    
    QBTable.footerPullToRefreshText = @"上拉可以加载更多数据了";
    QBTable.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    QBTable.footerRefreshingText = @"加载中。。。";
}

#pragma mark - 上拉刷新
-(void)headerRereshing
{
    _page = 0;
    NSString * page  = [NSString stringWithFormat:@"%d",_page];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary * dic = @{@"page":page,@"uid":self.uid,@"code_id":@"3"};
    NSLog(@"%@",self.uid);
    
    [manager POST:YHDD parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.dateSource removeAllObjects];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (arr == NULL) {
            self.panDuan = @"1";
        }else{
            self.panDuan = @"0";
        }
        
        if ([self.panDuan isEqualToString:@"1"]) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYPMW, SYPMH - 108)];
            view.backgroundColor = [UIColor whiteColor];
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(SYPMW/4, self.view.frame.size.height/2 - SYPMW/4, SYPMW/2, SYPMW/2)];
            image.image = [UIImage imageNamed:@"ktxr"];
            [view addSubview:image];
            [self.view addSubview:view];
        }else{
            //                NSLog(@"arr==%@",arr);
            
            NSArray * arr2 = [BaoMingModel mj_objectArrayWithKeyValuesArray:arr];
            [self.dateSource addObjectsFromArray:arr2];
            
            //                NSLog(@"date == %@",self.dateSource);
            
            [QBTable reloadData];
            [QBTable headerEndRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
}
#pragma mark - 下拉加载
-(void)footerRereshing
{
    _page++;
    NSString * page  = [NSString stringWithFormat:@"%d",_page];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary * dic = @{@"page":page,@"uid":self.uid,@"code_id":@"3"};
    NSLog(@"%@",self.uid);
    
    [manager POST:YHDD parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [self.dateSource removeAllObjects];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //                NSLog(@"arr==%@",arr);
        
        NSArray * arr2 = [BaoMingModel mj_objectArrayWithKeyValuesArray:arr];
        [self.dateSource addObjectsFromArray:arr2];
        
        //                NSLog(@"date == %@",self.dateSource);
        
        [QBTable reloadData];
        [QBTable footerEndRefreshing];
        
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
    return _dateSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * iden = @"bababa";
    //    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    //    }
    //    cell.textLabel.text = @"1111";
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:self options:nil]lastObject];
    }
    BaoMingModel * model = (BaoMingModel *)[_dateSource objectAtIndex:indexPath.row];
    [cell loadViewsWithModel:model];
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;//选中不变色

    _cellHeight = cell.dingdanButton.frame.origin.y + cell.dingdanButton.frame.size.height;
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight + 10;
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

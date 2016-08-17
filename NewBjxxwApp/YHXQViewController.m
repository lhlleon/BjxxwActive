//
//  YHXQViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/26.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "YHXQViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "HotPlModel.h"
#import "HDXQTableViewCell.h"
#import "FBPLViewController.h"
#import "HotPLTableViewCell.h"


@interface YHXQViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * xqTable;
    UIImageView *navigation;
    UILabel * my;
    UIButton * backButton;
    NSMutableArray * date;
}

@property (nonatomic,strong) NSMutableArray * plDataSource;

@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,assign)CGFloat cellHeight;

@property (nonatomic,assign)CGFloat cellHeighForOne;//第一个index.row的高度

@property (nonatomic,assign)CGFloat cellHeightForPl;//评论的indexPath.row的高度


@end

@implementation YHXQViewController

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(NSMutableArray *)plDataSource{
    if (_plDataSource == nil) {
        _plDataSource = [[NSMutableArray alloc]init];
    }
    return _plDataSource;
}

-(void)viewWillAppear:(BOOL)animated{
    [_plDataSource removeAllObjects];
    [self plAF];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog(@" id= = = =   %@",_hid);
    [self createNavigation];
    [self createBackButton];
    
    [self xqOneAF];
    [self plAF];
    [self createTable];
    
}

#pragma mark - 网络请求
-(void)xqOneAF{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"hid":self.hid};
    
    [manager POST:YHHDXQUrl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                    NSLog(@"arr= = = = = = = =%@",arr);
        
        NSArray * arr2 = [YHXQModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
        
//        NSLog(@"date == %@",self.dataSource);
        
        [xqTable reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];

}

/**
 评论的数据请求
 */
-(void)plAF{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"hid":self.hid};
    
    [manager POST:YHHDPLURL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [_plDataSource removeAllObjects];
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"arr= = = = = = = =%@",arr);
        
        NSArray * arr2 = [HotPlModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.plDataSource addObjectsFromArray:arr2];
        
//        NSLog(@"date == %@",self.plDataSource);
        
        [xqTable reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}

-(void)createTable{
    xqTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYPMW, SYPMH-64) style:UITableViewStyleGrouped];
    xqTable.delegate = self;
    xqTable.dataSource = self;
    [self.view addSubview:xqTable];
}

#pragma mark - tableview  delegate  和 datesource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 2) {
        //评论行的row个数
        return self.plDataSource.count;
    }else{
    return self.dataSource.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.section == 0) {
        NSString * iden = @"cell1";
        HDXQTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"HDXQTableViewCell" owner:self options:nil]lastObject];
        }
        
//        NSLog(@"cell的高度 == %f",cell.frame.size.height);
        
        if (SCREEN_5S) {
            _cellHeighForOne = cell.frame.size.height - 20;
        }else{
            _cellHeighForOne = cell.frame.size.height;
        }
        
        YHXQModel  * model = (YHXQModel *)[_dataSource objectAtIndex:indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 10, 10);
        
        [cell loadViewsWithModel:model];
        
        //点击时背景不变色
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        return cell;

    }else if(indexPath.section == 2){
        NSString * ide = @"bushi";
        HotPLTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:ide];
        
        cell1 = [[[NSBundle mainBundle]loadNibNamed:@"HotPLTableViewCell" owner:self options:nil]lastObject];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        HotPlModel * model1 = (HotPlModel *)[_plDataSource objectAtIndex:indexPath.row];
        NSLog(@"%@",self.dataSource);
        [cell1 loadViewsWithModel:model1];
        cell1.selectionStyle =UITableViewCellSelectionStyleNone;
        
        _cellHeightForPl = cell1.frame.size.height;
        
        return cell1;
        
    }else{
    NSString * iden = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];

    }
        //从model中获取content
        YHXQModel  * model = (YHXQModel *)[_dataSource objectAtIndex:indexPath.row];
        
        NSLog(@"%@",model.path);

        UILabel * xq = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        
        xq.text = model.content;
        
        xq.numberOfLines = 0;
        //自动换行属性
//        xq.lineBreakMode = NSLineBreakByWordWrapping;
        if (SCREEN_5S) {
            xq.font = [UIFont systemFontOfSize:13];
        }else{
            xq.font = [UIFont systemFontOfSize:17];
        }
        
        CGSize size = [xq sizeThatFits:CGSizeMake(xq.frame.size.width, MAXFLOAT)];
        xq.frame = CGRectMake(8, 0, self.view.frame.size.width - 16, size.height +100);
        cell.selectionStyle =UITableViewCellSelectionStyleNone;

        [cell addSubview:xq];

        _cellHeight = xq.frame.size.height;

    return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 1) {
        return 40;
    }else{
        return 0.001;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if (section == 2 ) {
        UIView * viwe = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYPMW, 30)];
        viwe.backgroundColor = [UIColor whiteColor];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(8, 6, 3, 27)];
        label.backgroundColor = [UIColor redColor];
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(18, 6, 100, 27)];
        title.text = @"活动评论";
        title.font = [UIFont systemFontOfSize:14];
        
        UIButton * fbButton = [[UIButton alloc]initWithFrame:CGRectMake(SYPMW - SYPMW/10-45, 5, SYPMW/10 + 35, 30)];
        
        UIImageView * fbImage = [[UIImageView alloc]initWithFrame:CGRectMake(SYPMW - SYPMW/10-45, 5, SYPMW/10 + 35, 30)];
        fbImage.image = [UIImage imageNamed:@"pl"];
        
        [fbButton addTarget:self action:@selector(onClick1:) forControlEvents:UIControlEventTouchUpInside];
        
        [viwe addSubview:fbButton];
        [viwe addSubview:fbImage];
        [viwe addSubview:label];
        [viwe addSubview:title];
        return viwe;
    }else if (section == 1){
        UIView * viwe = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYPMW, 30)];
        viwe.backgroundColor = [UIColor whiteColor];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(8, 6, 3, 27)];
        label.backgroundColor = [UIColor redColor];
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(18, 6, 100, 27)];
        title.text = @"活动详情";
        title.font = [UIFont systemFontOfSize:14];
        
        [viwe addSubview:label];
        [viwe addSubview:title];
        return viwe;
    }
    else{
        return nil;
    }
    
    
}

#pragma mark - 评论按钮的点击事件
-(void)onClick1:(UIButton *)fbButton
{
    FBPLViewController * fbpl = [[FBPLViewController alloc]init];
    fbpl.hid = _hid;
    fbpl.isTrue = @"1";
    [self.navigationController pushViewController:fbpl animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (SCREEN_5S) {
            return _cellHeighForOne ;
        }else{
            return _cellHeighForOne + 20;
        }
    }else if (indexPath.section == 2){
        return _cellHeightForPl;
    }else{
    return _cellHeight;
    }
}


#pragma mark - 创建导航控制器
-(void)createNavigation
{
    navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor whiteColor];
    
    my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"活动介绍";
    my.textColor = [UIColor blackColor];
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
}

-(void)createBackButton
{
    backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"fh"] forState:UIControlStateNormal];
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

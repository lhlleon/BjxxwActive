//
//  XQViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/14.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "XQViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "XiangQingModel.h"
#import "XQTableViewCell.h"
#import "XiangQingModel.h"
#import "HotPLTableViewCell.h"
#import "HotPlModel.h"
#import "FBPLViewController.h"
#import "BMViewController.h"
#import "XHToast.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width


#import "URL.h"

@interface XQViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

{
    UIButton * backButton;
    UITableView * XqTable;
}

@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,strong) UIActivityIndicatorView * activityIndicator;

@property (nonatomic,strong) NSMutableArray * plDataSource;

@property (nonatomic,strong) UIWebView * XQWeb;

@property (nonatomic,strong) NSString * price;

@property (nonatomic,strong) NSString * uid;//用户id

@property (nonatomic,strong) UIButton * sc;

@property (nonatomic,strong) NSString * isture;//是否收藏

@end

@implementation XQViewController
-(UIButton *)sc
{
    if (_sc == nil) {
        _sc = [[UIButton alloc]init];
    }
    return _sc;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
        
    }
    return _dataSource;
}

-(NSMutableArray *)plDataSource
{
    if (_plDataSource == nil) {
        _plDataSource = [[NSMutableArray alloc]init];
    }
    return _plDataSource;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self createPLXQ];
    [self createSC];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    _XQWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width,100)];
    _XQWeb.delegate = self;
    NSString * str = [NSString stringWithFormat:@"%@%@",XQWUrl,self.hid];
    _XQWeb.scrollView.scrollEnabled = NO;
//    _XQWeb.scalesPageToFit = YES;
    [self.XQWeb loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:str]]];
    
//    NSLog(@"跳转的hid : %@",_hid);
    [self AFNet];
    [self createPLXQ];
    [self createNavigaton];
    [self createBackButton];
    // 注册加载完成高度的通知
    [self createTable];

    self.fd_prefersNavigationBarHidden = YES;

}

#pragma mark - 收藏

-(void)createSC
{
    
    self.sc = [UIButton buttonWithType:UIButtonTypeCustom];
    _sc.frame = CGRectMake(SYPMW - 45, 28, 25, 25);
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    self.uid =[defaults objectForKey:@"uid"];
    if (self.uid == NULL) {
        return;
    }
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"hid":self.hid,@"uid":self.uid};
    
    [manager POST:SFSC parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"arr= = = = = = = =%@",arr);
        
        _isture = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"tishi"]];
        
        if ([_isture isEqualToString:@"2"]) {
            [_sc setBackgroundImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
        }else{
            [_sc setBackgroundImage:[UIImage imageNamed:@"sc1"] forState:UIControlStateNormal];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

    [_sc addTarget:self action:@selector(sc:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sc];
}

-(void)sc:(UIButton *)sc
{
    [self.sc removeFromSuperview];//删除按钮
//    NSLog(@"%@",self.price);
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * pd = [NSString string];
    if ([_isture isEqualToString:@"1"]) {
        pd = @"2";
    }else{
        pd = @"1";
    }
    
    
    //sid
    NSDictionary * dic = @{@"hid":self.hid,@"uid":self.uid,@"pic":self.price,@"sid":pd};
    
    [manager POST:ADDSC parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString * st = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"tishi"]];
        
        [XHToast showBottomWithText:st];
        [self createSC];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 网路请求
-(void)AFNet
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"hid":self.hid};
    
    [manager POST:XQUrl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //                NSLog(@"arr==%@",arr);
        
        NSArray * arr2 = [XiangQingModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
        
        //        NSLog(@"date == %@",self.dataSource);
        
        [XqTable reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}

//评论详情网络数据
-(void)createPLXQ{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"hid":self.hid};
    
    [manager POST:PlUrl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [self.plDataSource removeAllObjects];
        
            NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"arr= = = = = = = =%@",arr);

            NSArray * arr2 = [HotPlModel mj_objectArrayWithKeyValuesArray:arr];
        
            [self.plDataSource addObjectsFromArray:arr2];
            
//            NSLog(@"date == %@",self.plDataSource);
        
            [XqTable reloadData];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}


#pragma mark - 创建tableview
-(void)createTable
{
    XqTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    XqTable.delegate = self;
    XqTable.dataSource = self;
    
    [self.view addSubview:XqTable];
}


#pragma mark - tableviewDelegate代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {//第一个section和第二个section  row的个数
        return 1;
    }else{//第三个section   row的个数
        return self.plDataSource.count;
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


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 2;
    }else{
    return 15;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (indexPath.section == 0 ) {
        
        NSString * ide = @"hellp";
        XQTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:ide];
        cell1 = [[[NSBundle mainBundle]loadNibNamed:@"XQTableViewCell" owner:self options:nil]lastObject];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        XiangQingModel * model = (XiangQingModel *)[_dataSource objectAtIndex:indexPath.row];
#pragma mark - 赋值价格
        self.price = model.price;
        self.titles = model.title;
        
        if (model.path == nil) {
            cell1.textLabel.text = @" ";
        }else{
//            NSLog(@"%@",self.dataSource);
            [cell1 loadViewsWithModel:model];
        }

        return cell1;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        NSString * inden = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:inden];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inden];
            
        }
        
        [cell.contentView addSubview:_XQWeb];
//        NSLog(@"%@",)
        /* 忽略点击效果 */
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        return cell;
    }else
    {
        
        NSString * ide = @"hello";
        HotPLTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:ide];
        
        cell1 = [[[NSBundle mainBundle]loadNibNamed:@"HotPLTableViewCell" owner:self options:nil]lastObject];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        HotPlModel * model1 = (HotPlModel *)[_plDataSource objectAtIndex:indexPath.row];
//        NSLog(@"%@",self.dataSource);
        [cell1 loadViewsWithModel:model1];
        return cell1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.view.frame.size.width/2 - 20;
    }else if (indexPath.section == 1){
        return _XQWeb.frame.size.height;
    }
    else{
        return self.view.frame.size.width/2 - 20;
    }
    
}
#pragma mark - 评论按钮的点击事件
-(void)onClick1:(UIButton *)fbButton
{
    FBPLViewController * fbpl = [[FBPLViewController alloc]init];
    fbpl.hid = _hid;
    [self.navigationController pushViewController:fbpl animated:YES];
}


#pragma mark - 导航里面的东西
-(void)createNavigaton
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor orangeColor];
    
    UILabel * my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"活动介绍";
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma mark - 跳转到报名页
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        NSLog(@"%@",self.price);
        BMViewController * bmv = [[BMViewController alloc]init];
        bmv.titles = self.titles;
        bmv.price = self.price;
        bmv.hid = self.hid;
        [self.navigationController pushViewController:bmv animated:YES];
    }
    else{
//        NSLog(@"%ld",(long)indexPath.section);
    }
}

//返回按钮
-(void)backClick:(UIButton *)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - webview的代理方法,,为了cell的自适应!!!!!!(这玩意害死老子了!!!!!)
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height = [[_XQWeb stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    _XQWeb.frame = CGRectMake(_XQWeb.frame.origin.x,_XQWeb.frame.origin.y, kScreenWidth, height +20);
    [XqTable reloadData];
    
    
    UIView * view = (UIView *)[self.view viewWithTag:100];
    [view removeFromSuperview];
    [_activityIndicator stopAnimating];
    
}



#pragma mark 禁止webview中的链接点击

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if(navigationType==UIWebViewNavigationTypeLinkClicked)//判断是否是点击链接
        
    {
        return NO;
    }
    
    else{
        return YES;
    }
    
}
#pragma mark - 网页代理设置
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    //    创建UIActivityIndicatorVIew
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(SYPMW/2 - 50 , (SYPMH )/2 -50 , 100, 100)];
    [view setTag:100];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    [view setAlpha:0.8];
    
    [[view layer] setBorderColor:[UIColor blackColor].CGColor];//颜色
    [[view layer]setCornerRadius:15.0];//圆角
    [view.layer setMasksToBounds:YES];
    
    
    
    [self.view addSubview:view];
    
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    [_activityIndicator setCenter:self.view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:_activityIndicator];
    
    [_activityIndicator startAnimating];
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

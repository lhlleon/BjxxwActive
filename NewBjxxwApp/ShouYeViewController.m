//
//  ShouYeViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/4/27.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "ShouYeViewController.h"
#import "EditViewController.h"
#import "EightButton.h"
#import "SYTableView.h"
#import "XQViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "URL.h"
#import "WebViewController.h"
#import "EightButtonViewController.h"
#import "SearchViewController.h"
#import "DQHotSearchViewController.h"


@interface ShouYeViewController ()<UISearchBarDelegate>
{
    UISearchBar * sou;
    UIButton * sousuo;
    UIButton * editButton;
    NSString * hid;
}

@property (nonatomic,strong) NSMutableArray * a;

@property (nonatomic,strong) NSMutableArray * b;

@property (nonatomic,strong) NSMutableArray * titleArr;

@property (nonatomic,strong) NSMutableArray * fbTitleArr;//发布的

@property (nonatomic,strong) NSMutableArray * hidi;

@property (nonatomic,strong) NSMutableArray * hidid;//发布的

@property (nonatomic,strong) NSString * url;//跳转的url   轮播图

@property (nonatomic,strong) NSString * titles;//跳转的标题   轮播图

@property (nonatomic,strong) NSString * anniuTitle;//按钮跳转的标题

@end

@implementation ShouYeViewController
-(NSString *)anniuTitle
{
    if (_anniuTitle == nil) {
        _anniuTitle = [[NSString alloc]init];
    }
    return _anniuTitle;
}

-(NSMutableArray *)fbTitleArr
{
    if (_fbTitleArr == nil) {
        _fbTitleArr = [[NSMutableArray alloc]init];
    }
    return _fbTitleArr;
}

-(NSMutableArray *)hidid
{
    if (_hidid == nil) {
        _hidid = [[NSMutableArray alloc]init];
    }
    return _hidid;
}

-(NSMutableArray *)hidi
{
    if (_hidi == nil) {
        _hidi = [[NSMutableArray alloc]init];
    }
    return _hidi;
}

-(NSMutableArray *)a
{
    if (_a == nil) {
        _a = [[NSMutableArray alloc]init];
    }
    return _a;
}
-(NSMutableArray *)b
{
    if (_b == nil) {
        _b = [[NSMutableArray alloc]init];
    }
    return _b;
}

-(NSMutableArray *)titleArr
{
    if (_titleArr == nil) {
        _titleArr = [[NSMutableArray alloc]init];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];//创建主页tableview的试图
    [self createNavigation];//创建导航控制器
    [self createEditButton];//创建发布按钮
    [self secDate];
    [self fbDate];
    
    /**
     *  轮播图跳转
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tiaozhuan:) name:@"tiaole" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lunbo1url:) name:@"lunbo1url" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lunbo1title:) name:@"lunbo1title" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tiaozhuan1:) name:@"tiaozhuan1" object:nil];
    /**
     *  按钮跳转
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anniu:) name:@"anniu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anniuname:) name:@"anniuname" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fourtiao:) name:@"fourtiao" object:nil];
    
    
    /**
     *  广告页面跳转
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guanggao:) name:@"广告" object:nil];
}
#pragma mark - 广告业跳转
-(void)guanggao:(NSNotification *)click
{
    WebViewController * wb  = [[WebViewController alloc]init];
    
    wb.url = click.object;
    wb.titles = @"相约七夕.鹊桥汇";
//    [self presentViewController:wb animated:YES completion:^{
    
//    }];
    [self.navigationController pushViewController:wb animated:YES];
        
}

#pragma mark - 四个按钮跳转
-(void)fourtiao:(NSNotification *)click
{
    XQViewController * xq = [[XQViewController alloc]init];
    xq.hid = click.object;
    [self.navigationController pushViewController:xq animated:YES];
}

#pragma mark - 按钮的跳转
-(void)anniuname:(NSNotification *)click
{
    self.anniuTitle = click.object;
//    NSLog(@"%@",self.anniuTitle);
}

-(void)anniu:(NSNotification *)click
{
    EightButtonViewController * ebv = [[EightButtonViewController alloc]init];
    ebv.cid = click.object;
    ebv.titles = self.anniuTitle;
    [self.navigationController pushViewController:ebv animated:YES];
}


#pragma mark - 轮播图的跳转
-(void)lunbo1url:(NSNotification *)click
{
    self.url = click.object;
//    NSLog(@"%@",click.object);
}
-(void)lunbo1title:(NSNotification *)click
{
    self.titles = click.object;
//    NSLog(@"%@",click.object);
}
-(void)tiaozhuan1:(NSNotification *)click
{
    WebViewController * wb = [[WebViewController alloc]init];
    wb.url = self.url;
    wb.titles = self.titles;
    [self.navigationController pushViewController:wb animated:YES];
}



-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
//    [self.view endEditing:YES];
}
-(void)tiaozhuan:(NSNotification *)click
{

//    NSLog(@"23423423423 \n%@",click.object);
    XQViewController * xqv = [[XQViewController alloc]init];
    hid = click.object;
    xqv.hid = hid;
    [self.navigationController pushViewController:xqv animated:YES];

    
}




#pragma mark - 右侧编辑button
-(void)createEditButton
{
    editButton = [[UIButton alloc]init];
    if (SCREEN_5S) {
        editButton.frame = CGRectMake(self.view.frame.size.width-35, 30, 20, 20);
    }else{
        editButton.frame = CGRectMake(self.view.frame.size.width-35, 27, 25, 25);
    }
    [editButton setBackgroundImage:[UIImage imageNamed:@"fb"] forState:UIControlStateNormal];
    //添加button点击事件
    [editButton addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
}

-(void)editClick:(UIButton *)editButton
{
//    NSLog(@"balabala");
    EditViewController * evc = [[EditViewController alloc]init];
    [self.navigationController pushViewController:evc animated:YES];
}



#pragma mark - 创建导航控制器
-(void)createNavigation
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor orangeColor];
    
    sousuo = [UIButton buttonWithType:UIButtonTypeCustom];

    [sousuo setBackgroundImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
    sousuo.adjustsImageWhenHighlighted = NO;
    [sousuo addTarget: self action:@selector(sousuo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sousuo];
    
    UILabel * title = [[UILabel alloc]init];
    title.frame = CGRectMake(5, 20, 100, 40);
    title.text = @"北京信息网";
    title.font = [UIFont fontWithName:@"Times New Roman" size:17];
    title.textColor = [UIColor whiteColor];
    if (SCREEN_5S) {
        sousuo.frame = CGRectMake(100, 28, self.view.frame.size.width - 150, 24);
        
    }else{
        sousuo.frame = CGRectMake(100, 23, self.view.frame.size.width - 150, 30);
    }
    [self.view addSubview:navigation];
    [self.view addSubview:sousuo];
    [self.view addSubview:title];

}

-(void)sousuo:(UIButton *)sousuo
{
//    SearchViewController * sv = [[SearchViewController alloc]init];
    DQHotSearchViewController *hotSearchCtl = [DQHotSearchViewController new];

    [self.navigationController pushViewController:hotSearchCtl animated:YES];
    
}

#pragma mark - 创建主页tableview
-(void)createTableView
{
    SYTableView * sv = [[SYTableView alloc]initWithFrame:CGRectMake(0, 9, self.view.frame.size.width, self.view.frame.size.height - 56)];
    [self.view addSubview:sv];
}







#pragma mark - 为第二页做准备
-(void)secDate
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
       //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:@"ListHeard.plist"];
    
    NSString *filePath1 = [docPath stringByAppendingPathComponent:@"HidHeard.plist"];
    

    
    //新建一个数组(作为例子)
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:FLGSUrl parameters:self progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [self.a addObjectsFromArray:arr];
        
        
        for (int i = 0 ;  i < self.a.count ; i ++ ) {
            NSString * str = [NSString stringWithFormat:@"%@",[_a[i] objectForKey:@"title"]];
            [self.titleArr addObject:str];
        }
        for (int i = 0 ; i < self.a.count; i ++ ) {
            NSString * str = [NSString stringWithFormat:@"%@",[_a[i] objectForKey:@"hid"]];
            [self.hidi addObject:str];
        }
        
        //将数组存储到文件中
        [self.titleArr writeToFile:filePath atomically:YES];
        
        [self.hidi writeToFile:filePath1 atomically:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}

-(void)fbDate
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:@"FBListHeard.plist"];
    NSString *filePath1 = [docPath stringByAppendingPathComponent:@"FBListId.plist"];
//    NSLog(@"%@",filePath);
    
    //新建一个数组(作为例子)
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://active.bjxxw.com/app/fabu_list.php" parameters:self progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [self.b addObjectsFromArray:arr];
        
        for (int i = 0 ;  i < self.b.count ; i ++ ) {
            NSString * str = [NSString stringWithFormat:@"%@",[_b[i] objectForKey:@"title"]];
            [self.fbTitleArr addObject:str];
        }
        for (int i = 0 ; i < self.b.count; i ++ ) {
            NSString * str = [NSString stringWithFormat:@"%@",[_b[i] objectForKey:@"hid"]];
            [self.hidid addObject:str];
        }
        
        //将数组存储到文件中
        [self.fbTitleArr writeToFile:filePath atomically:YES];
        [self.hidid writeToFile:filePath1 atomically:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
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

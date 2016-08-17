//
//  WoDeViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/4/27.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "WoDeViewController.h"
#import "RightButtonViewController.h"
#import "LogInViewController.h"
#import "URL.h"
#import "UIImageView+WebCache.h"
#import "MYSZViewController.h"
#import "EditViewController.h"
#import "BaoMingViewController.h"
#import "ShouCangViewController.h"
#import "PingLunViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "XHToast.h"
#import "WDFBViewController.h"


@interface WoDeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * szButton;
    UITableView * myTableView;
    UIImageView * jianTou;
    UIImageView * imageView ;
    UIImageView * navigation;
    UILabel * my;
}
@property (nonatomic,strong) NSString * name;

@property (nonatomic,strong) NSString * uid;

@property (nonatomic,strong) NSString * tupian;

@property (nonatomic,strong) NSString * pdLogin;

@end

@implementation WoDeViewController
//
//-(NSString *)name{
//    if (_name == nil) {
//        _name = [[NSString alloc]init];
//    }
//    return _name;
//}
//
//-(NSString *)uid{
//    if (_uid == nil) {
//        _uid = [[NSString alloc]init];
//    }
//    return _uid;
//}
//
//-(NSString *)tupian{
//    if (_tupian == nil) {
//        _tupian = [[NSString alloc]init];
//    }
//    return _tupian;
//}

-(void)viewWillAppear:(BOOL)animated
{
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    self.name =[defaults objectForKey:@"nickname"];
    self.uid =[defaults objectForKey:@"uid"];
    self.tupian = [defaults objectForKey:@"tupian"];
    self.pdLogin = [defaults objectForKey:@"login"];
    //打印数据
    
    //获取用户的资料
    NSLog(@"name = %@,uid = %@,tupian = %@ 是否登录 = %@",self.name,self.uid,self.tupian,self.pdLogin);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.x
    
    [self createList];
    [self createNavigation];
    [self createButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touxiang:) name:@"touxiang" object:nil];
}
#pragma mark - 接受的头像通知
-(void)touxiang:(NSNotification *)click
{
    [myTableView removeFromSuperview];
    [navigation removeFromSuperview];
    [my removeFromSuperview];
    [szButton removeFromSuperview];
    
    [self createList];
    [self createNavigation];
    [self createButton];
}



#pragma mark - 设置按钮
//创建右上角的button
-(void)createButton
{

    szButton =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50 , 22, 30, 30)];
    [szButton setBackgroundImage:[UIImage imageNamed:@"sz"] forState:UIControlStateNormal];
    [szButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:szButton];
}

//button的点击事件
-(void)onClick:(UIButton *)button
{
    NSLog(@"点了");
    
    RightButtonViewController * rbv = [[RightButtonViewController alloc]init];
    rbv.uid = self.uid;
    [self.navigationController pushViewController:rbv animated:YES];
}

#pragma mark - 创建导航控制器
-(void)createNavigation
{
    navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor orangeColor];
    
    my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"我的";
    my.textColor = [UIColor whiteColor];
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
}


#pragma mark - 创建列表
//创建列表

-(void)createList
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-90) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:myTableView];
}

#pragma mark - 数据源


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (section == 1) {
        return 3;
    }else if (section == 0){
        return 1;
    }else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString * identifier = @"cellIdentifier";
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //创建每行前面的图片(第一行的)
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 150/2-40, 80, 80)];
        
        //创建每行显示的文字(第一行的)
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(130, 150/2 -20, 200, 40)];
        
        //除了第一行的所有文字，图片
        UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(30, 13, 25, 25)];
        
        UILabel * title1 = [[UILabel alloc]initWithFrame:CGRectMake(75 , 15, 100, 20)];
        
        jianTou = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 30, 10, 25,25)];
        jianTou.image = [UIImage imageNamed:@"jiantou"];
        if (indexPath.row == 0 && indexPath.section == 0) {


            if ([self.tupian isEqualToString:@"1"] || self.tupian == nil) {
                imageView.image = [UIImage imageNamed:@"tx"];
            }else{
                
                NSString * uu = [[NSString alloc]init];
                if ([self.tupian rangeOfString:@"app"].location != NSNotFound) {
                    uu = BaseUrl;
                }else{
                    uu = TPXSURL;
                }
                NSString * str = [NSString stringWithFormat:@"%@%@",uu,self.tupian];
                NSURL * url = [NSURL URLWithString:str];
                [imageView sd_setImageWithURL:url];
                imageView.layer.cornerRadius = 40.0;
                imageView.layer.masksToBounds = YES;

            }
            
            
            if (self.name == nil) {
                title.text = @"登录/注册";
            }else{
                title.text = self.name;
            }
            
            jianTou.frame = CGRectMake(self.view.frame.size.width-30, 60, 25, 25);
            
        }else if (indexPath.section == 1){
            switch (indexPath.row) {
                case 0:
                    imageView1.image = [UIImage imageNamed:@"wddd"];
                    title1.text = @"我的订单";
                    break;
                case 1:
                    imageView1.image = [UIImage imageNamed:@"wdsc"];
                    title1.text = @"我的收藏";
                    break;
                case 2:
                    imageView1.image = [UIImage imageNamed:@"wdpl"];
                    title1.text = @"我的评论";
                default:
                    break;
            }
        }else if (indexPath.section == 2){
            switch (indexPath.row) {
                case 0:
                    imageView1.image = [UIImage imageNamed:@"fbhd"];
                    title1.text = @"发布活动";
                    title1.textColor = [UIColor redColor];
                    break;
                case 1:
                    imageView1.image = [UIImage imageNamed:@"wdfb.jpg"];
                    title1.text = @"我的发布";
                    break;
                    
                default:
                    break;
            }

        }
        
#pragma mark - 根据手机型号，，改变现实字体
        if (SCREEN_5S) {
            title.font = [UIFont systemFontOfSize:14];
            title1.font = [UIFont systemFontOfSize:14];
        }else if(SCREEN_6S){
            title.font = [UIFont systemFontOfSize:15];
            title1.font = [UIFont systemFontOfSize:15];
        }else{
            title.font = [UIFont systemFontOfSize:17];
            title1.font = [UIFont systemFontOfSize:17];
        }

        [cell addSubview:imageView];
        [cell addSubview:title];
        [cell addSubview:imageView1];
        [cell addSubview:title1];
        if (indexPath.section != 0) {
            [cell addSubview:jianTou];
        }
        
    }
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return 150;
    }else
    {
        return 50;
    }
}


//tableview脚试图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.1;
    }else{
    return 10;
    }
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //登录的跳转,或者设置个人信息
    if (indexPath.section == 0) {
        if (![self.pdLogin  isEqual: @"1"]) {
            LogInViewController * liv = [[LogInViewController alloc]init];
            [self.navigationController pushViewController:liv animated:YES];
        }else{
            NSLog(@"已登录");
            MYSZViewController * wsxq = [[MYSZViewController alloc]init];
            [self.navigationController pushViewController:wsxq animated:YES];
        }
    }
    //报名,收藏,评论的跳转
    else if (indexPath.section == 1){
        BaoMingViewController * bv = [[BaoMingViewController alloc]init];
        ShouCangViewController * sv = [[ShouCangViewController alloc]init];
        PingLunViewController * pv = [[PingLunViewController alloc]init];
#pragma mark - 判断是否登录以解决显示问题
        if (self.name == NULL) {
            [XHToast showCenterWithText:@"请登录后查看!"];
        }else{
        switch (indexPath.row) {
            case 0:
                //报名
                [self.navigationController pushViewController:bv animated:YES];
                break;
            case 1:
                //收藏
                [self.navigationController pushViewController:sv animated:YES];
                break;
            case 2:
                //评论
                [self.navigationController pushViewController:pv animated:YES];
                
            default:
                break;
        }
      }
    }
    
    //发布跳转
    else if (indexPath.section == 2){
        EditViewController * evc = [[EditViewController alloc]init];
        WDFBViewController * wdfb = [[WDFBViewController alloc]init];
        switch (indexPath.row) {
            case 0:
                [self.navigationController pushViewController:evc animated:YES];
                break;
            case 1:
                if (self.name == nil) {
                    [XHToast showCenterWithText:@"请登陆后查看"];
                }else{
                    [self.navigationController pushViewController:wdfb animated:YES];
                }
                break;
                
            default:
                break;
        }
        
    }

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigationxxx

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

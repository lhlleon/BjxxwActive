//
//  RightButtonViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/10.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "RightButtonViewController.h"
#import "WoDeViewController.h"
#import "RightView.h"
#import "XHToast.h"
#import "URL.h"
#import "LogInViewController.h"
#import "XHToast.h"
#import "WebViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface RightButtonViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * rightTable;
}

@end

@implementation RightButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.fd_prefersNavigationBarHidden = YES;

    [self CreateNavigaton];
    
    [self backButton];
    
    [self createList];
    
    [self createLogoOutButton];
    
}

-(void)createList
{
    rightTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYPMW, SYPMH - 64 ) style:UITableViewStyleGrouped];
    rightTable.delegate = self;
    rightTable.dataSource = self;
    
    [self.view addSubview:rightTable];
}


#pragma mark - 数据源


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (section == 0) {
        return 2;
    }
    else
    {
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //所有文字，图片
        UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(30, 13, 25, 25)];
        
        UILabel * title1 = [[UILabel alloc]initWithFrame:CGRectMake(75 , 15, 100, 20)];
        
        UIImageView * jianTou = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 30, 10, 25,25)];
        jianTou.image = [UIImage imageNamed:@"jiantou"];
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    imageView1.image = [UIImage imageNamed:@"qlhc"];
                    title1.text = @"清理缓存";
                    break;
                case 1:
                    imageView1.image = [UIImage imageNamed:@"pf"];
                    title1.text = @"去评分！";
                    break;
                case 2:
                    imageView1.image = [UIImage imageNamed:@"yjfk"];
                    title1.text = @"意见反馈";
                    break;
                default:
                    break;
            }
        }else
        {
            switch (indexPath.row) {
                case 0:
                    imageView1.image = [UIImage imageNamed:@"gywm"];
                    title1.text = @"关于我们";
                    break;
                case 1:
                    imageView1.image = [UIImage imageNamed:@"kfdh"];
                    title1.text = @"客服电话";
                    break;
                    
                default:
                    break;
            }
        }
        if (SCREEN_5S) {
            title1.font = [UIFont systemFontOfSize:14];
        }else if (SCREEN_6S){
            title1.font = [UIFont systemFontOfSize:15];
        }else{
            title1.font = [UIFont systemFontOfSize:17];
        }
        
        [cell addSubview:imageView1];
        [cell addSubview:title1];
        [cell addSubview:jianTou];
    }
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //评分地址
    NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/bei-jing-xin-xi-wang-huo-dong/id1097486612?mt=8"];

    WebViewController * wb = [[WebViewController alloc]init];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"01058312880"];//打电话
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [XHToast showCenterWithText:@"清理成功~"];
                break;
            case 1:
                //评分
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];

                
                break;
            case 2:
                NSLog(@"3");
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                /**
                 *  传入名字.并跳转显示
                 */
                wb.titles = @"关于我们";
                wb.url = @"http://bjxxw.com/foot/guanyuwomen/about_us.html";
                [self.navigationController pushViewController:wb animated:YES];
                break;
            case 1:
                //打电话
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
                break;
            default:
                break;
        }
    }
}


#pragma mark - 创建返回按钮
-(void)createLogoOutButton
{
    UIButton * logoOutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64)];
    logoOutButton.backgroundColor = [UIColor orangeColor];
    [logoOutButton addTarget:self action:@selector(logoOut:) forControlEvents:UIControlEventTouchUpInside];
    
    logoOutButton.titleLabel.text = @"1111";
    logoOutButton.titleLabel.textColor = [UIColor blackColor];
    UILabel * logoOutLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64)];
    logoOutLabel.text = @"退出账号";
    logoOutLabel.textColor = [UIColor whiteColor];
    logoOutLabel.textAlignment = NSTextAlignmentCenter;
    if (SCREEN_5S) {
        logoOutLabel.font = [UIFont systemFontOfSize:14];
    }else if (SCREEN_6S){
        logoOutLabel.font = [UIFont systemFontOfSize:15];
    }else{
        logoOutLabel.font = [UIFont systemFontOfSize:17];
    }
    
    [self.view addSubview:logoOutButton];
    [self.view addSubview:logoOutLabel];
}

-(void)logoOut:(UIButton *)logoOutButton
{
    NSLog(@"uid === %@",self.uid);
    if (self.uid == NULL) {
        NSLog(@"1");
        [XHToast showBottomWithText:@"您还没有登录账号!\n请先登录!"];
        LogInViewController * lg = [[LogInViewController alloc]init];
        [self.navigationController pushViewController:lg animated:YES];
    }else{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touxiang" object:nil];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"usernm"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tupian"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nickname"];

    [XHToast showCenterWithText:@"退出成功"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    }
}




#pragma mark - 创建导航控制器
-(void)CreateNavigaton
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor whiteColor];
    
    UILabel * my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"设置";
    my.textColor = [UIColor blackColor];
    if (SCREEN_5S) {
        my.font = [UIFont systemFontOfSize:14];
    }else if (SCREEN_6S){
        my.font = [UIFont systemFontOfSize:15];
    }else{
        my.font = [UIFont systemFontOfSize:17];
    }
    
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

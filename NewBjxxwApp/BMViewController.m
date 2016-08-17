//
//  BMViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/6/8.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "BMViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "XHToast.h"
#import "NiceAlertSheet.h"
#import "FuKuanViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "XHToast.h"


@interface BMViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * backButton;
    UIButton * BMButton;
    UITableView * bmTable;
    UILabel * sexT;
    UITextField * tureNameText;
    UITextField * shoujiText;
    UITextField * emmailText;
    UITextField * QQText;
    UITextField * dizhiText;
    UITextField * danweiText;
    UITextField * zhengjian;
    UITextView * beizhuText;
    NSString * ored_id;
    NSString * names;
}
@property (nonatomic,strong) NSString * panduan;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) NSString * uid;

@property (nonatomic,strong) NSString * fanhui;

@property (nonatomic,strong) UIActivityIndicatorView * activityIndicator;

@end

@implementation BMViewController

-(NSString *)panduan
{
    if (_panduan == nil) {
        _panduan = [[NSString alloc]init];
    }
    return _panduan;
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([self.fanhui isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.fanhui = @"1";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;

    // Do any additional setup after loading the view.
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    self->names =[defaults objectForKey:@"username"];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createNavigaton];
    [self createBackButton];
    [self createAF];
//    NSLog(@"%@,%@",self.hid,self.price);
    //点击空白地方收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.view endEditing:YES];
}
#pragma mark - 网络
-(void)createAF
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"hid":self.hid};
    
    [manager POST:HQSY parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [self.plDataSource removeAllObjects];
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                    NSLog(@"arr= = = = = = = =%@",arr);
        NSString * str = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"if_pay"]];
//        NSLog(@"%@",str);
        self.panduan = str;
        
#pragma mark - tableView创建(为了得到if _ pay的数值)
        bmTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYPMW, SYPMH-64) style:UITableViewStylePlain];
        bmTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
        bmTable.separatorStyle = NO;
        bmTable.dataSource = self;
        bmTable.delegate = self;
        [self.view addSubview:bmTable];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" = = =%@",error);
        
    }];
}

#pragma mark - tableView代理设置
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * iden = @"bale";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
#pragma mark - 报名用的各种东西
    

    
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, SYPMW, 1000);
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    //用户名
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 60, 40)];
    name.textAlignment = NSTextAlignmentCenter;
    name.text = @"用户:";
    
    name.backgroundColor = [UIColor whiteColor];
    [view addSubview:name];

    CGFloat _nameText = CGRectGetMaxX(name.frame);
    UILabel * nameText = [[UILabel alloc]initWithFrame:CGRectMake(_nameText, 20, SYPMW-_nameText, 40)];
    nameText.backgroundColor = [UIColor whiteColor];
    nameText.text = self->names;
    
    
    [view addSubview:nameText];
    
    UILabel * xian = [[UILabel alloc]initWithFrame:CGRectMake( 10, 59, SYPMW - 20, 2)];
    xian.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:xian];//线

    
    //姓名
    CGFloat _turenameY = CGRectGetMaxY(name.frame);
    UILabel * turename = [[UILabel alloc]initWithFrame:CGRectMake(0, _turenameY, 60, 40)];
    turename.textAlignment = NSTextAlignmentCenter;
    turename.text = @"姓名:";
    
    turename.backgroundColor = [UIColor whiteColor];
    [view addSubview:turename];
    
    CGFloat _tuerNameText = CGRectGetMaxX(name.frame);
    tureNameText = [[UITextField alloc]initWithFrame:CGRectMake(_tuerNameText, _turenameY, SYPMW-_tuerNameText, 40)];
    tureNameText.backgroundColor = [UIColor whiteColor];
    tureNameText.placeholder = @"请输入姓名...";
    [view addSubview:tureNameText];
    

    
    
    //手机
    CGFloat _shoujiY = CGRectGetMaxY(turename.frame);
    UILabel * shouji = [[UILabel alloc]initWithFrame:CGRectMake(0, _shoujiY, 60, 40)];
    shouji.text = @"手机:";
    shouji.textAlignment = NSTextAlignmentCenter;

    shouji.backgroundColor = [UIColor whiteColor];
    [view addSubview:shouji];

    CGFloat _shoujiTextX = CGRectGetMaxX(shouji.frame);
    shoujiText = [[UITextField alloc]initWithFrame:CGRectMake(_shoujiTextX, _shoujiY, SYPMW - _shoujiTextX, 40 )];
    shoujiText.backgroundColor = [UIColor whiteColor];
    shoujiText.placeholder = @"请输入手机号...";
    [view addSubview:shoujiText];
    
    
    UILabel * xian1 = [[UILabel alloc]initWithFrame:CGRectMake( 10, _shoujiY -1, SYPMW - 20, 2)];
    xian1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:xian1];//线
    //性别
    CGFloat _sexY = CGRectGetMaxY(shouji.frame);
    UILabel * sex = [[UILabel alloc]initWithFrame:CGRectMake(0, _sexY, 60, 40)];
    sex.text = @"性别:";
    sex.textAlignment = NSTextAlignmentCenter;
    sex.backgroundColor = [UIColor whiteColor];
    [view addSubview:sex];
    
    CGFloat _sexTX = CGRectGetMaxX(sex.frame);
    sexT = [[UILabel alloc]initWithFrame:CGRectMake(_sexTX, _sexY, SYPMW - _sexTX, 40)];
    sexT.text = @"请选择性别...";
    sexT.textColor = [UIColor lightGrayColor];
    sexT.backgroundColor = [UIColor whiteColor];
    [view addSubview:sexT];
    
    UILabel * xian2 = [[UILabel alloc]initWithFrame:CGRectMake( 10, _sexY - 1, SYPMW - 20, 2)];
    xian2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:xian2];//线
    
    //性别选择
    UIButton * sexB = [[UIButton alloc]initWithFrame:CGRectMake(_sexTX, _sexY, SYPMW - _sexTX, 40)];
    sexB.backgroundColor = [UIColor clearColor];
    [sexB addTarget:self action:@selector(xingbie:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sexB];
    

    //邮箱
    
    CGFloat _emailY = CGRectGetMaxY(sex.frame);
    UILabel * email = [[UILabel alloc]initWithFrame:CGRectMake(0, _emailY, 60, 40)];
    email.text = @"邮箱:";
    email.textAlignment = NSTextAlignmentCenter;
    email.backgroundColor = [UIColor whiteColor];
    [view addSubview:email];
    
    CGFloat _emailTextX = CGRectGetMaxX(shouji.frame);
    emmailText = [[UITextField alloc]initWithFrame:CGRectMake(_emailTextX, _emailY, SYPMW - _emailTextX, 40 )];
    emmailText.backgroundColor = [UIColor whiteColor];
    emmailText.placeholder = @"请输入邮箱...";
    [view addSubview:emmailText];
    
    
    UILabel * xian3 = [[UILabel alloc]initWithFrame:CGRectMake( 10, _emailY - 1, SYPMW - 20, 2)];
    xian3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:xian3];//线
    
    
    //QQ
    CGFloat _QQlY = CGRectGetMaxY(email.frame);
    UILabel * QQ = [[UILabel alloc]initWithFrame:CGRectMake(0, _QQlY, 60, 40)];
    QQ.text = @"QQ:";
    QQ.textAlignment = NSTextAlignmentCenter;
    QQ.backgroundColor = [UIColor whiteColor];
    [view addSubview:QQ];
    
    CGFloat _QQTextX = CGRectGetMaxX(QQ.frame);
    QQText = [[UITextField alloc]initWithFrame:CGRectMake(_QQTextX, _QQlY, SYPMW - _emailTextX, 40 )];
    QQText.backgroundColor = [UIColor whiteColor];
    QQText.placeholder = @"请输入QQ(选填)...";
    [view addSubview:QQText];
    
    UILabel * xian4 = [[UILabel alloc]initWithFrame:CGRectMake( 10, _QQlY - 1, SYPMW - 20, 2)];
    xian4.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:xian4];//线
    //地址
    CGFloat _dizhiY = CGRectGetMaxY(QQ.frame);
    UILabel * dizhi = [[UILabel alloc]initWithFrame:CGRectMake(0, _dizhiY, 60, 40)];
    dizhi.text = @"地址:";
    dizhi.textAlignment = NSTextAlignmentCenter;
    dizhi.backgroundColor = [UIColor whiteColor];
    [view addSubview:dizhi];
    
    CGFloat _dizhiTextX = CGRectGetMaxX(dizhi.frame);
    dizhiText = [[UITextField alloc]initWithFrame:CGRectMake(_dizhiTextX, _dizhiY, SYPMW - _dizhiTextX, 40 )];
    dizhiText.backgroundColor = [UIColor whiteColor];
    dizhiText.placeholder = @"请输入地址(选填)...";
    [view addSubview:dizhiText];
    
    UILabel * xian5 = [[UILabel alloc]initWithFrame:CGRectMake( 10, _dizhiY - 1, SYPMW - 20, 2)];
    xian5.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:xian5];//线
    //单位
    CGFloat _danweiY = CGRectGetMaxY(dizhi.frame);
    UILabel * danwei = [[UILabel alloc]initWithFrame:CGRectMake(0, _danweiY, 60, 40)];
    danwei.text = @"单位:";
    danwei.textAlignment = NSTextAlignmentCenter;
    danwei.backgroundColor = [UIColor whiteColor];
    [view addSubview:danwei];
    
    CGFloat _danweiTextX = CGRectGetMaxX(danwei.frame);
    danweiText = [[UITextField alloc]initWithFrame:CGRectMake(_danweiTextX, _danweiY, SYPMW - _danweiTextX, 40 )];
    danweiText.backgroundColor = [UIColor whiteColor];
    danweiText.placeholder = @"请输入单位(选填)...";
    [view addSubview:danweiText];
    
    
    
    UILabel * xian6 = [[UILabel alloc]initWithFrame:CGRectMake( 10, _danweiY - 1, SYPMW - 20, 2)];
    xian6.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:xian6];//线
    //身份证
    CGFloat _zhengjianY = CGRectGetMaxY(danwei.frame);
    UILabel * zhengjia = [[UILabel alloc]initWithFrame:CGRectMake(0, _zhengjianY, 60, 40)];
    zhengjia.text = @"证件:";
    zhengjia.textAlignment = NSTextAlignmentCenter;
    zhengjia.backgroundColor = [UIColor whiteColor];
    [view addSubview:zhengjia];
    
    CGFloat _zhengjianTextX = CGRectGetMaxX(zhengjia.frame);
    zhengjian = [[UITextField alloc]initWithFrame:CGRectMake(_zhengjianTextX, _zhengjianY, SYPMW - _zhengjianTextX, 40 )];
    zhengjian.backgroundColor = [UIColor whiteColor];
    zhengjian.placeholder = @"请输入身份证(选填)...";
    [view addSubview:zhengjian];
    
    
    UILabel * xian7 = [[UILabel alloc]initWithFrame:CGRectMake( 10, _zhengjianY - 1, SYPMW - 20, 2)];
    xian7.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:xian7];//线
    
    //备注
    CGFloat _beizhuY = CGRectGetMaxY(zhengjia.frame);
    UILabel * beizhu = [[UILabel alloc]initWithFrame:CGRectMake(0, _beizhuY, SYPMW, 40)];
    beizhu.text = @"备注:";
    beizhu.textAlignment = NSTextAlignmentCenter;
    beizhu.backgroundColor = [UIColor whiteColor];
    [view addSubview:beizhu];
    
    CGFloat _beizhuTextY = CGRectGetMaxY(beizhu.frame);
    beizhuText = [[UITextView alloc]initWithFrame:CGRectMake(0, _beizhuTextY, SYPMW , 100)];
    beizhuText.backgroundColor = [UIColor whiteColor];
    beizhuText.textAlignment = NSTextAlignmentLeft;
    beizhuText.layer.borderColor = [UIColor grayColor].CGColor;
    beizhuText.layer.borderWidth =1.0;
    beizhuText.layer.cornerRadius =5.0;
    [view addSubview:beizhuText];
    
    
    CGFloat _baomingY = CGRectGetMaxY(beizhuText.frame);
    UIButton * baoming = [UIButton buttonWithType:UIButtonTypeCustom];
    [baoming setImage:[UIImage imageNamed:@"baoming"] forState:UIControlStateNormal];
    baoming.layer.cornerRadius = 10.0;//切圆角
    baoming.layer.masksToBounds = YES;

    //判断是否显示价格,以及显示报名按钮
//    NSLog(@"%@",_panduan);

    if ([self.panduan isEqualToString:@"0"]) {//不需要支付
        baoming.frame = CGRectMake(20, _baomingY + 20, SYPMW-40, 40 );
    }else{
        UILabel * price = [[UILabel alloc]initWithFrame:CGRectMake(0, _baomingY, SYPMW, 40)];
        NSString * str = [NSString stringWithFormat:@"金额 : %@",self.price];
        
        price.text = str;
        price.backgroundColor = [UIColor whiteColor];
        price.textColor = [UIColor redColor];
        [view addSubview:price];
        
        CGFloat _baomingNewY = CGRectGetMaxY(price.frame);
        baoming.frame = CGRectMake(20, _baomingNewY + 20, SYPMW-40, 40 );
    }
    [baoming addTarget:self action:@selector(bmClick:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:baoming];


    [cell addSubview:view];
    _cellHeight = baoming.frame.origin.y + 60;
    return cell;
}


#pragma mark - 性别选项
-(void)xingbie:(UIButton *)sexB
{
    NiceAlertSheet *alertSheet = [[NiceAlertSheet alloc] initWithMessage:@"选择性别" choiceButtonTitles:@[@"男", @"女"]];
    [alertSheet show];
    alertSheet.choiceButtonClickedBlock = ^(NSInteger i) {
        switch (i) {
            case 0:
            {
                NSLog(@"我选择了男");
                sexT.text = @"男";
                sexT.textColor = [UIColor blackColor];
                sexT.backgroundColor = [UIColor whiteColor];
            }
                break;
            case 1:
            {
                NSLog(@"我选择了女");
                sexT.text = @"女";
                sexT.textColor = [UIColor blackColor];
                sexT.backgroundColor = [UIColor whiteColor];
            }
                break;
            default:
                break;
        }
    };

}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

#pragma mark - 导航里面的东西
-(void)createNavigaton
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor whiteColor];
    
    UILabel * my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"报名";
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

//报名按钮的点击事件
-(void)bmClick:(UIButton *)baoming
{
//    NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",tureNameText.text,shoujiText.text,emmailText.text,QQText.text,dizhiText.text,danweiText.text,zhengjian.text,beizhuText.text);
    
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
    
    
    
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //[formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
    [formatter setDateFormat:@"YYYYMMddhhmmssSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *  timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    //    NSLog(@"%@", timeNow);
    NSString * st = [timeNow stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString * time = [st stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSLog(@"%@",time);
    
    
    //订单随机数
    int i = arc4random()%100000;
    //    NSLog(@"!!!!!!!%d",i);
    
    ored_id = [NSString stringWithFormat:@"%@%d",time,i];
    
    NSLog(@"%@",ored_id);
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    self.uid =[defaults objectForKey:@"uid"];
    
    
    NSLog(@"%@",ored_id);
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"uid":self.uid,@"hid":self.hid,@"real_name":tureNameText.text,@"qq":QQText.text,@"sex":sexT.text,@"email"
                           :emmailText.text,@"tel":shoujiText.text,@"unit":danweiText.text,@"card":zhengjian.text,@"address"
                           :dizhiText.text,@"beizhu":beizhuText.text,@"order_code":ored_id,@"jiage":self.price};
    
    [manager POST:BaoMingQueRen parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
//        NSLog(@"arr= = = = = = = =%@",arr);
        NSString * tishi = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"tishi"]];
        NSLog(@"%@",tishi);
        
        if (![tishi  isEqual: @"1"]) {
            UIView * view = (UIView *)[self.view viewWithTag:100];
            [view removeFromSuperview];
            [_activityIndicator stopAnimating];
            [XHToast showCenterWithText:tishi];

        }else if ([tishi isEqualToString:@"1"]) {

            [XHToast showCenterWithText:@"报名成功"];
            if ([_panduan isEqualToString:@"1"]) {
                NSLog(@"1");
                FuKuanViewController * fkv = [[FuKuanViewController alloc]init];
                fkv.titles = self.titles;//标题
                fkv.price = self.price;//价格
                fkv.oreder = ored_id;//订单号
                fkv.hid = self.hid;
                [self.navigationController pushViewController:fkv animated:YES];
            }else{
                UIView * view = (UIView *)[self.view viewWithTag:100];
                [view removeFromSuperview];
                [_activityIndicator stopAnimating];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" = = =%@",error);
        
    }];
    
    
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

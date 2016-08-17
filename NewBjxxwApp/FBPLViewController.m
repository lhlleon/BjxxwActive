//
//  FBPLViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/26.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "FBPLViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "LXAlertView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


@interface FBPLViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    UIButton * backButton;
    UITextView * plField;
}
@property (nonatomic,strong) NSString * uid;
@end

@implementation FBPLViewController


-(NSString *)uid{
    if (_uid == nil) {
        _uid = [[NSString alloc]init];
    }
    return _uid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1 ];
    
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    self.uid =[defaults objectForKey:@"uid"];
    
    [self createNavigaton];
    [self createBackButton];
    [self createView];
    
    
    NSLog(@"is ture :  ?  %@",self.isTrue);
}

#pragma mark - 界面设置
-(void)createView
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 90, SYPMW, 30)];
    label.text = @"评论内容:";
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    
    plField = [[UITextView alloc]initWithFrame:CGRectMake(10 , 124, SYPMW - 20, 200)];
    plField.backgroundColor = [UIColor whiteColor];
    plField.secureTextEntry = NO; //是否以密码形式显示
    plField.returnKeyType = UIReturnKeyDone; //键盘返回类型
    plField.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    plField.textAlignment = NSTextAlignmentLeft;//输入字体左对齐
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    plField.font = [UIFont systemFontOfSize:17];
    /**
     设置圆角
     */
    [plField.layer setCornerRadius:8.0];
    [plField.layer setMasksToBounds:YES];
    plField.clipsToBounds = YES;
    
    plField.delegate =self;
    [self.view addSubview:plField];
    
    UIButton * fb = [[UIButton alloc]initWithFrame:CGRectMake(SYPMW/2-75 , 344 , 150, 50)];
//    fb.titleLabel.text = @"发送评论";
    [fb setTitle:@"发送评论" forState:UIControlStateNormal];
    fb.backgroundColor = [UIColor orangeColor];
    fb.titleLabel.textColor = [UIColor whiteColor];
    
    [fb.layer setMasksToBounds:YES];
    [fb.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    
    /**
     添加button点击时间
     */
    
    [fb addTarget:self action:@selector(fbClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:fb];
    
}


#pragma mark - 点击Button 进行发布评论  点击事件
-(void)fbClick:(UIButton *)fb
{
    NSLog(@"%@",plField.text);

    NSLog(@"%@    %@",_uid,_hid);
    
    
    NSString * strUrl = [NSString string];
    
    if ([self.isTrue isEqualToString:@"1"]) {
        strUrl = YHHDFBPLUrl;
    }else{
        strUrl = TJPLUrl;
    }
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary * dic = @{@"hid":self.hid,@"uid":self.uid,@"content":plField.text};
    
    [manager POST:strUrl parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"arr==%@",arr);
        
        /**
         添加成功返回 评论添加成功..
         */
        NSString * str = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"tishi"]];
        
        
        /**
         弹出提示框    并且返回活动页面
         */
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:str cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
            /**
             *    如果字段有返回成功二字,则直接跳转回到之前的 页面,,并且刷新评论内容!
             */
            
            if([str rangeOfString:@"成功"].location !=NSNotFound)//_roaldSearchText
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"请重新评论,或返回活动" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                    
                    
                }];
                alert.animationStyle=LXASAnimationLeftShake;
                [alert showLXAlertView];

            }
            
        }];
        alert.animationStyle=LXASAnimationTopShake;
        [alert showLXAlertView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    

    
}

#pragma mark - 取消键盘的第一响应机制
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - 导航里面的东西
-(void)createNavigaton
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor whiteColor];
    
    UILabel * my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"发布评论";
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

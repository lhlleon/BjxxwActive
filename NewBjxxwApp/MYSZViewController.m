//
//  MYSZViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/24.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "MYSZViewController.h"
#import "MHDatePicker.h"
#import "URL.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "NiceAlertSheet.h"
#import "XHToast.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface MYSZViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    UIImageView * navigation;
    UILabel * my;
    NSTimer * nowTime;
    NSString * saveFullPath;
    UIImage * savedImage;

}
@property (strong, nonatomic) MHDatePicker *selectDatePicker;

@property (nonatomic,strong) NSString * birthday;//生日

@property (nonatomic,strong) NSString * face;//头像

@property (nonatomic,strong) NSString * nickname;//昵称

@property (nonatomic,strong) NSString * sex1;//性别

@property (nonatomic,strong) NSString * st;//创建时间

@property (nonatomic,strong) NSString * uid;//用户id

@property (nonatomic,strong) NSString * username;//用户名

@property (nonatomic,strong) NSString * txFiles;//上传的图片地址

@property (nonatomic,strong) NSString * xbPd;//存储1.0 == (1.男   0.女)

@end

@implementation MYSZViewController
-(NSString *)txFiles
{
    if (_txFiles != nil ) {
        _txFiles = [[NSString alloc]init];
    }
    return _txFiles;
}

-(NSString *)xbPd
{
    if (_xbPd == nil) {
        _xbPd = [[NSString alloc]init];
    }
    return _xbPd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#pragma mark - 获取当前状态下内部保存的用户信息
    self.fd_prefersNavigationBarHidden = YES;
    
    //1.获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    self.nickname =[defaults objectForKey:@"nickname"];
    self.face =[defaults objectForKey:@"tupian"];
    self.uid = [defaults objectForKey:@"uid"];
    self.birthday = [defaults objectForKey:@"birthday"];
    self.sex1 = [defaults objectForKey:@"sex"];
    self.xbPd = [defaults objectForKey:@"sex"];
    self.username = [defaults objectForKey:@"username"];
    
    
    _txImage.clipsToBounds = YES;
    
    _txImage.layer.cornerRadius = 45.f;//设置圆角
    
    NSString * uu = [[NSString alloc]init];
    if ([self.face rangeOfString:@"app"].location != NSNotFound) {
        uu = BaseUrl;
    }else{
        uu = TPXSURL;
    }
    
    NSString * url = [NSString stringWithFormat:@"%@%@",uu,self.face];
    NSURL * urll = [NSURL URLWithString:url];
    NSLog(@"%@",url);
    [_txImage sd_setImageWithURL:urll];
    //打印数据
    if ([self.sex1  isEqual: @"1"]) {
        self.sex1 = @"男";
    }else{
        self.sex1 = @"女";
    }
    
//    self.xbPd = self.sex1;
    self.xbLabel.text = self.sex1;
    self.mylabel.text = self.birthday;
    self.ncLabel.text = self.username;
    self.ncText.text = self.nickname;
    _xbLabel.text = self.sex1;
    _txFiles = self.face;

    
    [self createNavigation];
    [self backButton];
    
}

//点击选择性别的时候的操作
- (IBAction)sexClick:(id)sender {
    NiceAlertSheet *alertSheet = [[NiceAlertSheet alloc] initWithMessage:@"选择性别" choiceButtonTitles:@[@"男", @"女"]];
    [alertSheet show];
    alertSheet.choiceButtonClickedBlock = ^(NSInteger i) {
        switch (i) {
            case 0:
            {
//                NSLog(@"我选择了男");
                _xbLabel.text = @"男";
                self.xbPd = @"1";
            }
                break;
            case 1:
            {
//                NSLog(@"我选择了女");
                _xbLabel.text = @"女";
                self.xbPd = @"0";
            }
                break;
            default:
                break;
        }
    };
}


- (IBAction)txButton:(id)sender {
    //ios8.3 UIAlertView的替换
    //** UIAlertCont /**  UIAlertControllerStyleActionSheet和  和 UIAlertControllerStyleAlert 两种表现形式 */
    if (IOS8_OR_LATER ) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            // UIImagePickerController
            UIImagePickerController  * imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.delegate =self;
            imagePickerController.allowsEditing =YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            //
            if([[[UIDevice
                  currentDevice] systemVersion] floatValue]>=8.0) {
                
                self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                
            }
            [self presentViewController:imagePickerController animated:YES completion:nil];
            
        }];
        
        UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            //   [self presentModalViewController:pickerImage animated:YES];
            [self presentViewController:pickerImage animated:YES completion:nil];
        }];
        
        UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        }];
        [alert addAction:act1];
        [alert addAction:act2];
        [alert addAction:act3];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma mark iOS 7 和iOS8调用取消的方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 拍照的图片保存到相册
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    // NSLog(@"保存");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData * imageData = UIImageJPEGRepresentation(currentImage, 1);//不缩放保存
    // NSLog(@"%@",currentImage);
    // NSLog(@"%@",imageData);
    /** 获取沙盒目录 */
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:imageName];
    NSLog(@"路径%@",fullPath);
    
    /** 将图片写入文件 */
    
    if ([imageData writeToFile:fullPath atomically:YES]) {
        NSLog(@"OK");
    }else{
        NSLog(@"NO");
    }
}


#pragma  mark iOS7 iOS8 都要调用此方法 选择完成后调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSString * image1 = info[UIImagePickerControllerReferenceURL];
    NSLog(@"%@",image1);
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /** 保存图片到本地 上传图片到服务器需要使用 */
    [self saveImage:image withName:@"avatar.png"];
    
    saveFullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"avatar.png"];
    
    savedImage  = [[UIImage alloc]initWithContentsOfFile:saveFullPath];
    [self PickRequest];
    
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        NSLog(@"调用保存图片的方法");
    }
    
}
#pragma mark  图片上传数据
-(void)PickRequest
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [XHToast showCenterWithText:@"上传中"];//上传提示

//    NSDictionary * feedback = @{@"uid":@"1"};
    [manager POST:TXSC parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * imageData = UIImageJPEGRepresentation(savedImage, 0.5);
        [formData appendPartWithFileData:imageData name:@"upload" fileName:@"avatar.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"进度%f",uploadProgress.fractionCompleted);
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",arr);
        
        NSString * message = [NSString stringWithFormat:@"%@",[arr objectForKey:@"message"]];
        self.txFiles = [NSString stringWithFormat:@"%@",[arr objectForKey:@"files"]];
        
        //用于判断字段内包含不包含app
        NSString * tx = [[NSString alloc]init];
        
        if ([message isEqualToString:@"1"]) {
            [XHToast showCenterWithText:@"上传成功"];
            if ([_txFiles rangeOfString:@"app"].location != NSNotFound) {
                tx = [NSString stringWithFormat:@"%@%@",BaseUrl,_txFiles];
            }else{
                tx = [NSString stringWithFormat:@"%@%@",TPXSURL,_txFiles];
            }
            NSLog(@"%@",tx);
            
            NSURL * url = [NSURL URLWithString:tx];
            [_txImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"tx"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"NO%@",error);
    }];
}



#pragma mark - 选择时间
- (IBAction)myBtn:(id)sender {
    
    NSLog(@"111");
    _selectDatePicker = [[MHDatePicker alloc] init];
    _selectDatePicker.isBeforeTime = YES;
    _selectDatePicker.datePickerMode = UIDatePickerModeDate;
    
    __weak typeof(self) weakSelf = self;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectDataTime) {
        weakSelf.mylabel.text = [weakSelf dateStringWithDate:selectDataTime DateFormat:@"yyyy-MM-dd"];
    }];
    
    
}
- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{//选择时间
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

#pragma mark - 创建导航控制器
-(void)createNavigation
{
    navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 64)];
    navigation.backgroundColor = [UIColor whiteColor];
    
    my = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"个人资料";
    my.textColor = [UIColor blackColor];
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
    
    
}
-(void)backButton
{
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"fh"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
#pragma mark - 保存按钮
    UIButton * baocunButton = [[UIButton alloc]initWithFrame:CGRectMake(SYPMW - 55, 28, 40, 25)];
    [baocunButton setTitle:@"保存" forState:UIControlStateNormal];
    baocunButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [baocunButton setTitleColor:[UIColor colorWithRed:255/255.0 green:84/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
    [baocunButton addTarget: self action:@selector(bcClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:baocunButton];
}
-(void)bcClick:(UIButton *)baocunButton
{
//    NSLog(@"111");
//    NSLog(@"%@  %@  %@  %@  %@  %@",self.uid,self.ncText.text,self.ncLabel.text,self.xbLabel.text,self.mylabel.text,_txFiles);
    
//    NSLog(@"%@",self.xbLabel.text);
    NSLog(@"存储型别是   ::::::    %@",_xbPd);

    NSDictionary * dic = @{@"uid":self.uid,@"nickname":self.ncText.text,@"username":self.ncLabel.text,@"sex":_xbPd  ,@"birthday":self.mylabel.text,@"face":_txFiles};
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:XiuGaiXX parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        NSString * tishi = [NSString stringWithFormat:@"%@",[dic[0] objectForKey:@"tishi"]];
        if ([tishi isEqualToString:@"1"]) {
            [XHToast showCenterWithText:@"保存成功"];

            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            
            //2保存数据(如果设置数据之后没有同步, 会在将来某一时间点自动将数据保存到Preferences文件夹下面)
            [defaults setObject:_txFiles forKey:@"tupian"];
            [defaults setObject:self.ncText.text forKey:@"nickname"];
            [defaults setObject:_xbPd forKey:@"sex"];
            [defaults setObject:self.mylabel.text forKey:@"birthday"];
            [defaults synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"touxiang" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [XHToast showCenterWithText:@"保存失败"];
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error == %@",error);
    }];
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

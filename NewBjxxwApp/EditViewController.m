//
//  EditViewController.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/11.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "EditViewController.h"
#import "URL.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "XHToast.h"
#import "LTPickerView.h"
#import "MHDatePicker.h"
#import "UIImageView+WebCache.h"
#import "LXAlertView.h"
#import "LogInViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


@interface EditViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    UIButton * backButton;
    UIButton * fbButton;
    NSString * saveFullPath;
    UIImage * savedImage;
}

@property (nonatomic,strong) NSString * uid;

@property (strong, nonatomic) MHDatePicker *selectDatePicker;

@property (nonatomic,strong) UITableView * fbTableView;

@property (nonatomic,strong) NSMutableArray * fbHid;//分类id

@property (nonatomic,strong) UITextField * titles;//文章标题

@property (nonatomic,strong) UILabel * xzfenlei; //分类的选择

@property (nonatomic,strong) UITextField * place;//活动地点

@property (nonatomic,strong) UITextField * phone;//电话

@property (nonatomic,strong) UITextField * QQ;//qq号

@property (nonatomic,strong) UITextView * concent;//发布活动的内容

@property (nonatomic,strong) UILabel * startTime;//开始时间

@property (nonatomic,strong) UILabel * stopTime;//结束时间

@property (nonatomic,strong) NSMutableArray * titlesArr;//标题的数组

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,strong) NSString * txFiles;//头像文件

@property (nonatomic,strong) UIImageView * txImage;

@property (nonatomic,strong) NSString * cid;//活动id

@end

@implementation EditViewController
-(UITextField *)titles
{
    if (!_titles) {
        _titles = [[UITextField alloc]init];
    }
    return _titles;
}
-(UILabel *)xzfenlei
{
    if (_xzfenlei == nil) {
        _xzfenlei = [[UILabel alloc]init];
    }
    return _xzfenlei;
}
-(UITextField *)place
{
    if (_place == nil) {
        _place = [[UITextField alloc]init];
    }
    return _place;
}
-(UITextField *)phone
{
    if (_phone == nil) {
        _phone =[[UITextField alloc]init];
    }
    return _phone;
}
-(UITextField *)QQ
{
    if (_QQ == nil) {
        _QQ = [[UITextField alloc]init];
    }
    return _QQ;
}
-(UITextView *)concent
{
    if (_concent == nil) {
        _concent = [[UITextView alloc]init];
    }
    return _concent;
}
-(UILabel *)startTime
{
    if (_startTime == nil) {
        _startTime = [[UILabel alloc]init];
    }
    return _startTime;
}
-(UILabel *)stopTime
{
    if (_stopTime == nil) {
        _stopTime = [[UILabel alloc]init];
    }
    return _stopTime;
}
-(NSString *)txFiles
{
    if (_txFiles == nil) {
        _txFiles = [[NSString alloc]init];
    }
    return _txFiles;
}
-(UIImageView *)txImage
{
    if (_txImage == nil) {
        _txImage = [[UIImageView alloc]init];
    }
    return _txImage;
}
-(NSString *)cid
{
    if (_cid == nil) {
        _cid = [[NSString alloc]init];
    }
    return _cid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    //获取Documents目录
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:@"FBListHeard.plist"];
    NSString *filePath1 = [docPath stringByAppendingPathComponent:@"FBListId.plist"];
    
    //使用一个数组来接受数据
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:filePath];
    NSMutableArray *array1 = [NSMutableArray arrayWithContentsOfFile:filePath1];
//    NSLog(@"%@",array);
    self.titlesArr = array;
    self.fbHid = array1;
    
    //隐藏官方导航栏
    
    self.fd_prefersNavigationBarHidden = YES;

    
    [self createNavigaton];
    [self createBackButton];
    [self createTableView];
}


-(void)createTableView
{
    _fbTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYPMW, SYPMH - 64) style:UITableViewStylePlain];
    _fbTableView.delegate = self;
    _fbTableView.dataSource = self;
    _fbTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_fbTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//点击不变色
    //添加上传图片的按钮   ---> 上传图片
    UIButton * scImage = [UIButton buttonWithType:UIButtonTypeCustom];
    scImage.frame = CGRectMake(0, 0, SYPMW, SYPMW - 85);
    [scImage setBackgroundImage:[UIImage imageNamed:@"fbpztp"] forState:UIControlStateNormal];
    [scImage addTarget:self action:@selector(SCZP:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:scImage];
    
    self.txImage = [[UIImageView alloc]init];
    _txImage.frame = CGRectMake(SYPMW/4, 0, SYPMW/2, SYPMW - 85);
    [cell addSubview:_txImage];
    
    
    //标线
    UILabel * line1 = [[UILabel alloc]init];
    CGFloat _line1Y = CGRectGetMaxY(scImage.frame);
    line1.frame = CGRectMake(0, _line1Y, SYPMW, 8);
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:line1];
    
    //文章标题
    UILabel * title = [[UILabel alloc]init];
    CGFloat _titleY = CGRectGetMaxY(line1.frame);
    title.frame = CGRectMake(0, _titleY, SYPMW/5, 40);
    title.text = @"文章标题:";
    title.textColor = [UIColor lightGrayColor];
    title.textAlignment = NSTextAlignmentRight;//文字显示靠右
    [cell addSubview:title];
    
    //文章标题内容
    self.titles = [[UITextField alloc]init];
    CGFloat _titlesX = CGRectGetMaxX(title.frame);
    _titles.frame = CGRectMake(_titlesX + 20, _titleY, SYPMW - _titlesX + 20, 40);
    _titles.placeholder = @"请输入标题..";
    [cell addSubview:_titles];
    
    //分割线1
    UILabel * line2 = [[UILabel alloc]init];
    CGFloat _line2Y = CGRectGetMaxY(title.frame);
    line2.frame = CGRectMake(10, _line2Y, SYPMW, 2);
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:line2];
    
    //分类
    UILabel * fenlei = [[UILabel alloc]init];
    CGFloat _fenleiY = CGRectGetMaxY(line2.frame);
    fenlei.frame = CGRectMake(0, _fenleiY , SYPMW/5, 40);
    fenlei.text = @"所属分类:";
    fenlei.textColor = [UIColor lightGrayColor];
    fenlei.textAlignment = NSTextAlignmentRight;
    [cell addSubview:fenlei];
    
    //分类选择的显示器
    self.xzfenlei = [[UILabel alloc]init];
    CGFloat _xzFenleiX = CGRectGetMaxX(fenlei.frame);
    _xzfenlei.frame = CGRectMake(_xzFenleiX + 20 , _fenleiY, SYPMW - _xzFenleiX +20, 40);
    _xzfenlei.text = @"请选择分类";
    _xzfenlei.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:_xzfenlei];
    
    UIButton * xzfl = [[UIButton alloc]initWithFrame:CGRectMake(_xzFenleiX + 20 , _fenleiY, SYPMW - _xzFenleiX +20, 40)];
    [xzfl addTarget:self  action:@selector(xuanze:) forControlEvents:UIControlEventTouchUpInside];
    xzfl.backgroundColor = [UIColor clearColor];
    [cell addSubview:xzfl];
    
    //分割线2
    UILabel * line3 = [[UILabel alloc]init];
    CGFloat _line3Y = CGRectGetMaxY(fenlei.frame);
    line3.frame = CGRectMake(0, _line3Y, SYPMW, 2);
    line3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:line3];
    
    //活动时间
    UILabel * hdsj = [[UILabel alloc]init];
    CGFloat _hdsjY = CGRectGetMaxY(line3.frame);
    hdsj.frame = CGRectMake(0, _hdsjY , SYPMW/5, 40);
    hdsj.text = @"活动时间:";
    hdsj.textColor = [UIColor lightGrayColor];
    hdsj.textAlignment = NSTextAlignmentRight;
    [cell addSubview:hdsj];
    
    //开始时间
    self.startTime = [[UILabel alloc]init];
    CGFloat _satimeX = CGRectGetMaxX(hdsj.frame);
    _startTime.frame = CGRectMake(_satimeX + 20, _hdsjY+10, SYPMW/5 + 10, 20);
    _startTime.text = @"开始日期";
    _startTime.font = [UIFont systemFontOfSize:13];
    _startTime.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框的一些设置
    [_startTime.layer setBorderWidth:0.5f];

    _startTime.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:_startTime];
    
    //结束时间
    self.stopTime = [[UILabel alloc]init];
    CGFloat _endtimeX = CGRectGetMaxX(_startTime.frame);
    _stopTime.frame = CGRectMake(_endtimeX+20, _hdsjY+10, SYPMW/5 + 10, 20);
    _stopTime.text = @"结束日期";
    _stopTime.font = [UIFont systemFontOfSize:13];
    _stopTime.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框的一些设置
    [_stopTime.layer setBorderWidth:0.5f];
    _stopTime.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:_stopTime];
    
    //开始时间的button
    UIButton * saButton = [[UIButton alloc]initWithFrame:CGRectMake(_satimeX + 20, _hdsjY+10, SYPMW/5 + 10, 20)];
    [saButton addTarget:self action:@selector(kstime:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:saButton];
    
    //结束时间的button
    UIButton * endButton = [[UIButton alloc]initWithFrame:CGRectMake(_endtimeX+20, _hdsjY+10, SYPMW/5 + 10, 20)];
    [endButton addTarget:self action:@selector(jstime:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:endButton];
    
    //分割线3
    UILabel * line4 = [[UILabel alloc]init];
    CGFloat _lin4Y = CGRectGetMaxY(hdsj.frame);
    line4.frame = CGRectMake(10, _lin4Y, SYPMH - 10, 2);
    line4.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:line4];
    
    //活动地点
    UILabel * hddd = [[UILabel alloc]init];
    CGFloat _hdddY = CGRectGetMaxY(line4.frame);
    hddd.frame = CGRectMake(0, _hdddY, SYPMW/5, 40);
    hddd.text = @"活动地点:";
    hddd.textAlignment = NSTextAlignmentRight;
    hddd.textColor = [UIColor lightGrayColor];
    [cell addSubview:hddd];
    
    self.place = [[UITextField alloc]init];
    CGFloat _placeX = CGRectGetMaxX(hddd.frame);
    _place.frame = CGRectMake(_placeX + 20, _hdddY, SYPMW - _placeX + 20, 40);
    _place.placeholder = @"请输入地点..";
    [cell addSubview:_place];
    
    //分割线4
    UILabel * line5 = [[UILabel alloc]init];
    CGFloat _lin5Y = CGRectGetMaxY(_place.frame);
    line5.frame = CGRectMake(10, _lin5Y, SYPMW - 10 , 2);
    line5.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:line5];
    
    //手机号
    UILabel * phone = [[UILabel alloc]init];
    CGFloat _phoneY = CGRectGetMaxY(line5.frame);
    phone.frame = CGRectMake(0, _phoneY, SYPMW/5, 40);
    phone.text = @"手机号码:";
    phone.textColor = [UIColor lightGrayColor];
    phone.textAlignment = NSTextAlignmentRight;
    [cell addSubview:phone];
    
    self.phone = [[UITextField alloc]init];
    CGFloat _phoneX = CGRectGetMaxX(phone.frame);
    _phone.frame = CGRectMake(_phoneX + 20, _phoneY, SYPMW - _phoneX +20, 40);
    _phone.placeholder = @"请输入手机号..";
    [cell addSubview:_phone];
    
    //分割线5
    UILabel * line6 = [[UILabel alloc]init];
    CGFloat _linr6Y = CGRectGetMaxY(phone.frame);
    line6.frame = CGRectMake(10, _linr6Y, SYPMW, 2);
    line6.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:line6];
    
    //QQ
    UILabel * QQ = [[UILabel alloc]init];
    CGFloat _qqY = CGRectGetMaxY(line6.frame);
    QQ.frame = CGRectMake(0, _qqY, SYPMW/5, 40);
    QQ.text = @"Q        Q:";
    QQ.textAlignment = NSTextAlignmentRight;
    QQ.textColor = [UIColor lightGrayColor];
    [cell addSubview:QQ];
    
    self.QQ = [[UITextField alloc]init];
    _QQ.frame = CGRectMake(_phoneX + 20, _qqY, SYPMW-_phoneX + 20, 40);
    _QQ.placeholder = @"请输入QQ号..";
    [cell addSubview:_QQ];
    
    //分割线6
    UILabel * line7 = [[UILabel alloc]init];
    CGFloat _line7Y = CGRectGetMaxY(QQ.frame);
    line7.frame = CGRectMake(10, _line7Y, SYPMW, 2);
    line7.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell addSubview:line7];
    
    //发布内容
    UILabel * neirong = [[UILabel alloc]init];
    CGFloat _nrY = CGRectGetMaxY(line7.frame);
    neirong.frame = CGRectMake(0, _nrY, SYPMW/5, 40);
    neirong.textColor = [UIColor lightGrayColor];
    neirong.textAlignment = NSTextAlignmentRight;
    neirong.text = @"发布内容:";
    [cell addSubview:neirong];
    
    self.concent = [[UITextView alloc]init];
    CGFloat _concentY = CGRectGetMaxY(neirong.frame);
    _concent.frame = CGRectMake(10, _concentY, SYPMW -20, SYPMW/2);
    _concent.layer.borderColor = [UIColor blackColor].CGColor;
    _concent.layer.borderWidth = 0.5f;
    [cell addSubview:_concent];
    
#pragma mark - 返回的cell高度
    _cellHeight = CGRectGetMaxY(_concent.frame) + 20;
    
    /**
     *  关于字体的一些设置
     */
    
    if (SCREEN_5S) {
        title.font =[UIFont systemFontOfSize:13];
        fenlei.font = [UIFont systemFontOfSize:13];
        hdsj.font = [UIFont systemFontOfSize:13];
        hddd.font = [UIFont systemFontOfSize:13];
        phone.font = [UIFont systemFontOfSize:13];
        QQ.font = [UIFont systemFontOfSize:13];
        neirong.font = [UIFont systemFontOfSize:13];
        _xzfenlei.font = [UIFont systemFontOfSize:13];
        _titles.font = [UIFont systemFontOfSize:13];
        _startTime.font = [UIFont systemFontOfSize:13];
        _stopTime.font = [UIFont systemFontOfSize:13];
        _place.font = [UIFont systemFontOfSize:13];
        _phone.font = [UIFont systemFontOfSize:13];
        _QQ.font = [UIFont systemFontOfSize:13];
        _concent.font = [UIFont systemFontOfSize:14];
    }else
    {
        title.font =[UIFont systemFontOfSize:17];
        fenlei.font = [UIFont systemFontOfSize:17];
        hdsj.font = [UIFont systemFontOfSize:17];
        hddd.font = [UIFont systemFontOfSize:17];
        phone.font = [UIFont systemFontOfSize:17];
        QQ.font = [UIFont systemFontOfSize:17];
        neirong.font = [UIFont systemFontOfSize:17];
        _xzfenlei.font = [UIFont systemFontOfSize:17];
        _titles.font = [UIFont systemFontOfSize:17];
        _startTime.font = [UIFont systemFontOfSize:15];
        _stopTime.font = [UIFont systemFontOfSize:15];
        _place.font = [UIFont systemFontOfSize:17];
        _phone.font = [UIFont systemFontOfSize:17];
        _QQ.font = [UIFont systemFontOfSize:17];
        _concent.font = [UIFont systemFontOfSize:17];
    }
    
    
    return cell;
}

#pragma mark - 选择时间
-(void)jstime:(UIButton *)endButton
{
//    NSLog(@"111");
    _selectDatePicker = [[MHDatePicker alloc] init];
    _selectDatePicker.isBeforeTime = YES;
    _selectDatePicker.datePickerMode = UIDatePickerModeDate;
    
    __weak typeof(self) weakSelf = self;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectDataTime) {
        _stopTime.text = [weakSelf dateStringWithDate:selectDataTime DateFormat:@"yyyy-MM-dd"];
    }];
}

-(void)kstime:(UIButton *)saButton
{
//    NSLog(@"111");
    _selectDatePicker = [[MHDatePicker alloc] init];
    _selectDatePicker.isBeforeTime = YES;
    _selectDatePicker.datePickerMode = UIDatePickerModeDate;
    
    __weak typeof(self) weakSelf = self;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectDataTime) {
       _startTime.text = [weakSelf dateStringWithDate:selectDataTime DateFormat:@"yyyy-MM-dd"];
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



#pragma mark - 选择分类的点击时间
-(void)xuanze:(UIButton *)xzfl
{
    LTPickerView* pickerView = [LTPickerView new];
    pickerView.dataSource = self.titlesArr;//设置要显示的数据
    pickerView.defaultStr = @"2";//默认选择的数据
    [pickerView show];//显示
    //回调block
    pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
        //obj:LTPickerView对象
        //str:选中的字符串
        //num:选中了第几行
        NSLog(@"选择了第%d行的%@",num,str);
        self.cid = [NSString stringWithFormat:@"%@",self.fbHid[num]];
        
        [XHToast showCenterWithText:str];
        self.xzfenlei.text = str;
    };
}


#pragma mark - 照片上传x
-(void)SCZP:(UIButton *)scImage
{
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
    [self saveImage:image withName:@"avatar1.png"];
    
    saveFullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"avatar1.png"];
    
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
    [manager POST:YHHDTP parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * imageData = UIImageJPEGRepresentation(savedImage, 0.5);
        [formData appendPartWithFileData:imageData name:@"upload" fileName:@"fbtp.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"进度%f",uploadProgress.fractionCompleted);
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",arr);
        
        NSString * message = [NSString stringWithFormat:@"%@",[arr objectForKey:@"message"]];
        self.txFiles = [NSString stringWithFormat:@"%@",[arr objectForKey:@"files"]];
        if ([message isEqualToString:@"1"]) {
            [XHToast showCenterWithText:@"上传成功"];
            NSString * tx = [NSString stringWithFormat:@"%@%@",TPXSURL,_txFiles];
            NSURL * url = [NSURL URLWithString:tx];
            [_txImage sd_setImageWithURL:url];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"NO%@",error);
    }];
}


#pragma mark - 返回cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}


#pragma mark - 没必要看的东西!!!!!一般不怎么修改
-(void)createBackButton
{
    backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 25, 25)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"fh"] forState:UIControlStateNormal];
    [backButton addTarget: self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
    fbButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 65, 28, 45, 25)];
    [fbButton setBackgroundImage:[UIImage imageNamed:@"fbde"] forState:UIControlStateNormal];
    [fbButton addTarget:self action:@selector(fbClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:backButton];
    [self.view addSubview:fbButton];
}

#pragma mark - 发布的按钮
-(void)fbClick:(UIButton *)fbButton
{
    
//    @property (nonatomic,strong) UITextField * titles;//文章标题
//    
//    @property (nonatomic,strong) UILabel * xzfenlei; //分类的选择
//    
//    @property (nonatomic,strong) UITextField * place;//活动地点
//    
//    @property (nonatomic,strong) UITextField * phone;//电话
//    
//    @property (nonatomic,strong) UITextField * QQ;//qq号
//    
//    @property (nonatomic,strong) UITextView * concent;//发布活动的内容
//    
//    @property (nonatomic,strong) UILabel * startTime;//开始时间
//    
//    @property (nonatomic,strong) UILabel * stopTime;//结束时间

    [_titles resignFirstResponder];
    [_place resignFirstResponder];
    [_phone resignFirstResponder];
    [_QQ resignFirstResponder];
    [_concent resignFirstResponder];
    
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    self.uid =[defaults objectForKey:@"uid"];
    
    if (self.uid == nil) {
        
#pragma mark - 如果程序为登录跳转到登录界面....无返回操作强制执!!!!!!
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"请先登录账号后,在进行发布活动~" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            LogInViewController * lo = [[LogInViewController alloc]init];
            [self.navigationController pushViewController:lo animated:YES];
            
        }];
        
        
        [alert showLXAlertView];

    
    }else{
    
    
    if (_txFiles != nil && _cid != nil ) {
        NSDictionary * dic = @{@"uid":self.uid,@"title":_titles.text,@"cid":_cid,@"sta":_startTime.text,@"stp":_stopTime.text,@"url":_txFiles,@"place":_place.text,@"tel":_phone.text,@"qq":_QQ.text,@"content":_concent.text};
        
        [manager POST:FBHD parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",arr);
            
            NSString * st = [NSString stringWithFormat:@"%@",[arr[0] objectForKey:@"tishi"]];
            if ([st isEqualToString:@"1"]) {
                LXAlertView * alert = [[LXAlertView alloc]initWithTitle:@"提示" message:@"发布成功" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                alert.animationStyle = LXASAnimationTopShake;

                [alert showLXAlertView];
                
            }else{
            [XHToast showBottomWithText:st];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else{
        [XHToast showCenterWithText:@"请检查是不是没有全部填写~\n要求全部填写哦~"];
    }
    
    }
    
}



-(void)backClick:(UIButton *)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createNavigaton
{
    UIImageView * navigation = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = [UIColor whiteColor];
    
    UILabel * my = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50  , 10, 100, 64)];
    
    my.textAlignment = NSTextAlignmentCenter;
    my.text = @"发布活动";
    my.textColor = [UIColor blackColor];
    
    [self.view addSubview:navigation];
    [self.view addSubview:my];
    
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

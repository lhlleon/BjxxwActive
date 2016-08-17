//
//  SYTableView.m
//  NewBjxxwApp
//
//  Created by LiHanlun on 16/5/11.
//  Copyright © 2016年 LiHanlun. All rights reserved.
//

#import "SYTableView.h"
#import "EightButton.h"
#import "ScrollView.h"
#import "FourPictureView.h"
#import "HotTableViewCell.h"
#import "AFNetworking.h"
#import "MJExtension.h"
    

#import "HotModel.h"

#import "URL.h"

@interface SYTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * syTable;
}


@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation SYTableView


-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}




-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self NetWork];
        [self createTable];
   
    }
    return self;
}

#pragma mark - 创建tableview
-(void)createTable
{
    syTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    syTable.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    syTable.delegate = self;
    syTable.dataSource = self;
    [self addSubview:syTable];
}


#pragma mark - 网络请求
-(void)NetWork
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:HotUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"lalalalalala%@",responseObject);
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",arr);
        
        NSArray * arr2 = [HotModel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.dataSource addObjectsFromArray:arr2];
        
//        NSLog(@"%@",_dataSource);
        
        [syTable reloadData];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    
    }];
}


#pragma mark - tableview代理方法


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (section == 2) {
        return self.dataSource.count;
    }
    else
    {
        return 1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * identifier = @"cellIdentifier";
//    static NSString * identifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0 && indexPath.row == 0 ) {
            
            ScrollView * sv = [[ScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/2)];
            [cell addSubview:sv];
            
            EightButton * eb = [[EightButton alloc]initWithFrame:CGRectMake(0, self.frame.size.width/2, self.frame.size.width, self.frame.size.width/2)];
            
            [cell addSubview:eb];
            
            [cell setSelected:NO animated:YES];
            
            
        }else if (indexPath.section == 1)
        {
            
            FourPictureView * fv = [[FourPictureView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/2)];
            [cell addSubview:fv];
        }
        else if(indexPath.section == 2){
            
            NSString * iden = @"hello";
            
            HotTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:iden];

            
            cell1 = [[[NSBundle mainBundle]loadNibNamed:@"HotTableViewCell" owner:self options:nil]lastObject];
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            HotModel * model = (HotModel *)[_dataSource objectAtIndex:indexPath.row];
            [cell1 loadViewsWithModel:model];
     
            cell = cell1;
//            NSLog(@"%f",cell.frame.size.height);
            
        }
    
    
    }
    
    
    

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.frame.size.width;
    }else if (indexPath.section == 1){
        return self.frame.size.width/2;
    }
    else if(indexPath.section == 2){
        return self.frame.size.width/2 - 20;
    }else{
        return 1;
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.01f;
}

//头试图的大小
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 50;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView * viwe = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SYPMW, 30)];
        viwe.backgroundColor = [UIColor clearColor];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(8, 16, 3, 27)];
        label.backgroundColor = [UIColor redColor];
        
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(18, 16, 100, 27)];
        title.text = @"热门推荐";
        title.font = [UIFont systemFontOfSize:14];
        
        [viwe addSubview:label];
        [viwe addSubview:title];
        return viwe;
    }else{
        return nil;
    }
 
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 2) {
        NSLog(@"%ld",(long)indexPath.row);
        
        //发送给controller通知 进行table电机的跳转  并将id值传送给下一个页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tiaole" object:[_dataSource [indexPath.row] hid]];

    }
}



@end

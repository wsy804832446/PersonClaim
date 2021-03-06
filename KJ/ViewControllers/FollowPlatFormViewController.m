//
//  FollowPlatFormViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/10/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "FollowPlatFormViewController.h"
#import "FollowPlatFormViewCell.h"
#import "AllViewController.h"
#import "FollowDetaiViewController.h"
#import "ClaimModel.h"
#import "HomeShaiXuanCollectionViewCell.h"
#import "AllViewController.h"
@interface FollowPlatFormViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
//选时间按钮数组
@property (nonatomic,strong)NSMutableArray *btnArr;
@property (nonatomic,strong)NSCalendar *calendar;
@property (nonatomic,strong)NSDateComponents *theComponents;
//当前几号
@property (nonatomic,assign)NSInteger dateNum;
@property (nonatomic,strong)UIImageView *imgView;
//筛选view
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation FollowPlatFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getTask];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(screenClick) name:@"select" object:nil];
    [self.view addSubview:self.imgView];
    [self.view sendSubviewToBack:self.imgView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBtnTime];
    self.tableView.top =39+10;
    self.tableView.height = DeviceSize.height-self.tableView.top-49-64;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.isOpenHeaderRefresh = YES;
    // Do any additional setup after loading the view.
}
-(void)getTask{
    NSArray *localClaimArray = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"cliam%@",@"000111"]];
//    if (localClaimArray.count>0) {
//        [self.dataArray removeAllObjects];
//        [self.dataArray addObjectsFromArray:localClaimArray];
//    }
    WeakSelf(FollowPlatFormViewController);
    [self showHudWaitingView:WaitPrompt];
    [[NetWorkManager shareNetWork]getTaskWithUserId:[CommUtil readDataWithFileName:@"account"] andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if ([response.responseCode isEqual:@"1"]) {
            if (weakSelf.pageNO == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray *claimArray = response.dataDic[@"claimList"];
            for (NSDictionary *claimDic in claimArray) {
                ClaimModel *model = [MTLJSONAdapter modelOfClass:[ClaimModel class] fromJSONDictionary:claimDic error:NULL];
                [weakSelf.dataArray addObject:model];
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [CommUtil saveData:[NSArray arrayWithArray:weakSelf.dataArray] andSaveFileName:[NSString stringWithFormat:@"cliam%@",@"000111"]];
            });
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf showHudAuto:response.message];
        }
        [weakSelf.tableView.header endRefreshing];
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf removeMBProgressHudInManaual];
        [weakSelf showHudAuto:InternetFailerPrompt];
        [weakSelf.tableView.header endRefreshing];
    }];
}
-(void)screenClick{
    UIView *view = [self.view viewWithTag:6666];
    if (view) {
        [view removeFromSuperview];
    }
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.backgroundColor = [UIColor colorWithHexString:Colorblack alpha:0.5];
    backView.tag = 6666;
    /*添加手势事件,移除View*/
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView)];
    [backView addGestureRecognizer:tapGesture];
    [self.view addSubview:backView];
    [backView addSubview:self.collectionView];
    [UIView animateWithDuration:0.5 animations:^{
        self.collectionView.frame = CGRectMake(0, 0, DeviceSize.width, 312);
    }];
}
-(void)dismissContactView{
    UIView *view = [self.view viewWithTag:6666];
    [UIView animateWithDuration:0.5 animations:^{
        [view removeFromSuperview];
    }];
}
-(void)addBtnTime{
    //获取今天日期
    NSCalendarUnit calendarUnit = NSCalendarUnitDay;
    //前后三天日期数组
    for (int i=0; i<7; i++) {
        self.theComponents = [self.calendar components:calendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:(i-3)*24*3600]];
        self.dateNum = self.theComponents.day;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(DeviceSize.width/7*i,0, DeviceSize.width/7, 39);
        btn.tag = 1000+i;
        btn.backgroundColor = [UIColor clearColor];

        //日期label
        UILabel *lbldate = [[UILabel alloc]initWithFrame:CGRectMake((btn.width-29)/2,0, 29, 29)];
        lbldate.textColor = [UIColor colorWithHexString:Colorgray];
        lbldate.font = [UIFont systemFontOfSize:17];
        lbldate.textAlignment = NSTextAlignmentCenter;
        lbldate.text = [NSString stringWithFormat:@"%ld",self.dateNum];
        if (i==3) {
            lbldate.text = @"今";
            lbldate.layer.borderColor = [UIColor colorWithHexString:@"#ffc106"].CGColor;
        }else{
            lbldate.layer.borderColor = [UIColor clearColor].CGColor;
        }
        lbldate.layer.masksToBounds = YES;
        lbldate.layer.cornerRadius = 29/2;
        lbldate.layer.borderWidth = 1;
        lbldate.tag = 2000+i;
        if (i == 3) {
            lbldate.textColor = [UIColor colorWithHexString:@"#ffc106"];
        }
        [btn addTarget:self action:@selector(timeChange:) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:lbldate];
        [self.view addSubview:btn];
        //添加日期label进数组
        [self.btnArr addObject:lbldate];
    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, DeviceSize.width, 10)];
    line.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
    [self.view addSubview:line];
}
-(void)timeChange:(UIButton *)btn{
    for (UILabel *label in self.btnArr) {
        if (label.tag == btn.tag+1000) {
            label.backgroundColor = [UIColor colorWithHexString:@"#ffc106"];
            label.textColor = [UIColor colorWithHexString:Colorwhite];
        }else{
            if (label.tag-2000 == 3) {
                label.textColor = [UIColor colorWithHexString:@"#ffc106"];
                label.layer.borderColor = [UIColor colorWithHexString:@"#ffc106"].CGColor;
            }else{
                label.textColor = [UIColor colorWithHexString:Colorgray];
            }
            label.backgroundColor = [UIColor clearColor];
        }
    }
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setDay:(btn.tag-1000)-3];
    NSDate *newDate = [self.calendar dateByAddingComponents:components toDate: [NSDate date] options:0];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday|NSCalendarUnitMonth|NSCalendarUnitDay;
    components = [self.calendar components:calendarUnit fromDate:newDate];
    NSString *weekStr = [self weekStrWithNum:components.weekday];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld.%ld 星期%@",components.month,components.day,weekStr];
}
-(NSString *)weekStrWithNum:(NSInteger)num{
    NSString *weekStr;
    switch (num) {
        case 1:
            weekStr = @"日";
            break;
        case 2:
            weekStr = @"一";
            break;
        case 3:
            weekStr = @"二";
            break;
        case 4:
            weekStr = @"三";
            break;
        case 5:
            weekStr = @"四";
            break;
        case 6:
            weekStr = @"五";
            break;
        case 7:
            weekStr = @"六";
            break;
        default:
            break;
    }
    return weekStr;
}
-(NSString *)nowDate:(NSDate *)date{
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components = [self.calendar components:calendarUnit fromDate:date];
    NSString *weekStr = [self weekStrWithNum:components.weekday];
    NSString *dateStr = [NSString stringWithFormat:@"%ld.%ld 星期%@",components.month,components.day,weekStr];
    return dateStr;
}
-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ClaimModel *model = [self.dataArray objectAtIndex:section];
    return model.taskList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClaimModel *claimModel =self.dataArray[indexPath.section];
    TaskModel *taskModel= [MTLJSONAdapter modelOfClass:[TaskModel class] fromJSONDictionary:claimModel.taskList[indexPath.row] error:NULL];
    FollowPlatFormViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlatFormCELL"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"FollowPlatFormViewCell" owner:nil options:nil];
        if (nib.count>0) {
            cell = nib.firstObject;
        }
    }
    if (indexPath.section ==0 && indexPath.row ==0) {
        cell.line.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    }else{
        cell.line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    }
    cell.lblName.text = claimModel.insuredName;
    cell.lblTime.text = taskModel.dispatchDate;
    cell.lblTime.textColor = [UIColor colorWithHexString:Colorgray];
    cell.lblNum.text =claimModel.reportNo;
    cell.lblNum.textColor = [UIColor colorWithHexString:Colorgray];
    cell.lblState.layer.masksToBounds = YES;
    cell.lblState.layer.borderWidth =1;
    cell.lblState.layer.cornerRadius =4;
    cell.lblState.font = [UIFont systemFontOfSize:12];
    cell.lblTaskType.layer.masksToBounds = YES;
    cell.lblTaskType.layer.cornerRadius = 16;
    cell.lblTaskType.backgroundColor = [UIColor colorWithHexString:@"#9DC5F9"];
    cell.lblTaskType.textColor = [UIColor colorWithHexString:Colorwhite];
    if ([taskModel.taskType isEqualToString:@"01"]) {cell.lblTaskType.text = @"医";
    }else if ([taskModel.taskType isEqualToString:@"02"]) {cell.lblTaskType.text = @"薪";
    }else if ([taskModel.taskType isEqualToString:@"03"]) {cell.lblTaskType.text = @"误";
    }else if ([taskModel.taskType isEqualToString:@"04"]) {cell.lblTaskType.text = @"籍";
    }else if ([taskModel.taskType isEqualToString:@"05"]) {cell.lblTaskType.text = @"扶";
    }else if ([taskModel.taskType isEqualToString:@"06"]) {cell.lblTaskType.text = @"死";
    }else if ([taskModel.taskType isEqualToString:@"08"]) {cell.lblTaskType.text = @"伤";
    }else if ([taskModel.taskType isEqualToString:@"09"]) {cell.lblTaskType.text = @"基";
    }else if ([taskModel.taskType isEqualToString:@"10"]) {cell.lblTaskType.text = @"处";
    }
    switch (indexPath.section) {
        case 3:
            cell.lblState.text =@" 完成 ";
            cell.lblState.textColor = [UIColor colorWithHexString:@"#00c632"];
            cell.lblState.layer.borderColor = [UIColor colorWithHexString:@"#00c632"].CGColor;
            break;
        case 1:
            cell.lblState.text =@" 超时 ";
            cell.lblState.textColor = [UIColor colorWithHexString:@"#ff0000"];
            cell.lblState.layer.borderColor = [UIColor colorWithHexString:@"#ff0000"].CGColor;
            break;
        case 2:
            cell.lblState.text =@" 进行中 ";
            cell.lblState.textColor = [UIColor colorWithHexString:@"#ffc106"];
            cell.lblState.layer.borderColor = [UIColor colorWithHexString:@"#ffc106"].CGColor;
            break;
        case 0:
            cell.lblState.text =@" 待办 ";
            cell.lblState.textColor = [UIColor colorWithHexString:@"#3282f0"];
            cell.lblState.layer.borderColor = [UIColor colorWithHexString:@"#3282f0"].CGColor;
            break;
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.parentViewController setHidesBottomBarWhenPushed:YES];
    FollowPlatFormViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    FollowDetaiViewController *vc = [[FollowDetaiViewController alloc]init];
    vc.taskTypeName = cell.lblTaskType.text;
    vc.claimModel = self.dataArray[indexPath.section];
    vc.taskModel = [MTLJSONAdapter modelOfClass:[TaskModel class] fromJSONDictionary:vc.claimModel.taskList[indexPath.row] error:NULL];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
    [self.parentViewController setHidesBottomBarWhenPushed:NO];
}
-(NSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [_calendar setTimeZone:[[NSTimeZone alloc] initWithName:@"Asia/Shanghai"]];
    }
    return _calendar;
}
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -64, DeviceSize.width, 306*DeviceSize.width/375)];
        [_imgView setImage:[UIImage imageNamed:@"home img"]];
    }
    return _imgView;
}
-(void)headerRequestWithData{
    [self getTask];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeShaiXuanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeShaiXuanCell" forIndexPath:indexPath];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HomeCollectionViewCell" owner:nil options:nil];
        if (nib.count>0) {
            cell = [nib firstObject];
        }
    }
    [cell configCellWithRow:indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AllViewController *vc = [[AllViewController alloc]init];
    if (indexPath.row>0) {
        vc.claimType = indexPath.row-1;
    }else{
        vc.claimType = 10;
    }
    UIView *backView = [self.view viewWithTag:6666];
    self.collectionView.frame = CGRectMake(0, -312, DeviceSize.width, 312);
    [backView removeFromSuperview];
    UIButton *btn = [self.navigationItem.rightBarButtonItem.customView viewWithTag:1001];
    btn.enabled = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeShaiXuanCollectionViewCell *cell =(HomeShaiXuanCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeShaiXuanCollectionViewCell *cell =(HomeShaiXuanCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:Colorwhite];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        // 设置间距
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(DeviceSize.width/4,312/3);
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, -312, DeviceSize.width,312)collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.contentSize = CGSizeMake(DeviceSize.width, 312);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor =[UIColor colorWithHexString:Colorwhite];
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeShaiXuanCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeShaiXuanCell"];
    }
    return _collectionView;
    
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

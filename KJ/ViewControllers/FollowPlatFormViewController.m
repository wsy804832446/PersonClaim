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
@interface FollowPlatFormViewController ()
//选时间按钮数组
@property (nonatomic,strong)NSMutableArray *btnArr;
@property (nonatomic,strong)NSCalendar *calendar;
@property (nonatomic,strong)NSDateComponents *theComponents;
//当前几号
@property (nonatomic,assign)NSInteger dateNum;
@end

@implementation FollowPlatFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTask];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.VCstyle = UITableViewStyleGrouped;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    UIButton *barbtn = self.navigationItem.leftBarButtonItem.customView;
    [barbtn setBackgroundImage:[UIImage imageNamed:@"e"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction:) andTarget:self andTitleName:@"全部"];
    self.navigationItem.title = [self nowDate:[NSDate date]];
    [self addBtnTime];
    self.tableView.top =65;
    self.tableView.height = DeviceSize.height-self.tableView.top-49;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15,0, 15)];
    }
    // Do any additional setup after loading the view.
}
-(void)getTask{
    NSArray *localClaimArray = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"cliam%@",@"000111"]];
    if (localClaimArray.count>0) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:localClaimArray];
    }else{
        WeakSelf(FollowPlatFormViewController);
        [self showHudWaitingView:WaitPrompt];
        [[NetWorkManager shareNetWork]getTaskWithUserId:@"000111" andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
            [weakSelf removeMBProgressHudInManaual];
            if ([response.responseCode isEqual:@"1"]) {
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
        } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
            [weakSelf removeMBProgressHudInManaual];
            [weakSelf showHudAuto:InternetFailerPrompt];
        }];
    }
}
-(void)leftAction{
}
-(void)rightAction:(UIButton *)btn{
    [self setHidesBottomBarWhenPushed:YES];
    AllViewController *vc = [[AllViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}
-(void)addBtnTime{
    //获取今天日期
    NSCalendarUnit calendarUnit = NSCalendarUnitDay;
    //前后三天日期数组
    for (int i=0; i<7; i++) {
        self.theComponents = [self.calendar components:calendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:(i-3)*24*3600]];
        self.dateNum = self.theComponents.day;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(DeviceSize.width/7*i,0, DeviceSize.width/7, 55);
        btn.tag = 1000+i;
        btn.backgroundColor = [UIColor colorWithHexString:Colorwhite];

        //日期label
        UILabel *lbldate = [[UILabel alloc]initWithFrame:CGRectMake((btn.width-29)/2,13, 29, 29)];
        lbldate.textColor = [UIColor colorWithHexString:Colorgray];
        lbldate.font = [UIFont systemFontOfSize:17];
        lbldate.textAlignment = NSTextAlignmentCenter;
        lbldate.text = [NSString stringWithFormat:@"%ld",self.dateNum];
        if (i==3) {
            lbldate.text = @"今";
        }
        lbldate.layer.masksToBounds = YES;
        lbldate.layer.cornerRadius = 29/2;
        lbldate.layer.borderWidth = 1;
        lbldate.tag = 2000+i;
        if (i == 3) {
            lbldate.layer.borderColor = [UIColor colorWithHexString:@"#ffc106"].CGColor;
            lbldate.textColor = [UIColor colorWithHexString:@"#ffc106"];
        }else{
            lbldate.layer.borderColor = [UIColor colorWithHexString:Colorwhite].CGColor;
        }
        [btn addTarget:self action:@selector(timeChange:) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:lbldate];
        [self.view addSubview:btn];
        //添加日期label进数组
        [self.btnArr addObject:lbldate];
    }
}
-(void)timeChange:(UIButton *)btn{
    for (UILabel *label in self.btnArr) {
        if (label.tag == btn.tag+1000) {
            label.backgroundColor = [UIColor colorWithHexString:@"#ffc106"];
            label.layer.borderColor = [UIColor colorWithHexString:@"#ffc106"].CGColor;
            label.textColor = [UIColor colorWithHexString:Colorwhite];
        }else{
            if (label.tag-2000 == 3) {
                label.layer.borderColor = [UIColor colorWithHexString:@"#ffc106"].CGColor;
                label.textColor = [UIColor colorWithHexString:@"#ffc106"];
            }else{
                label.layer.borderColor = [UIColor colorWithHexString:Colorwhite].CGColor;
                label.textColor = [UIColor colorWithHexString:Colorgray];
            }
            label.backgroundColor = [UIColor colorWithHexString:Colorwhite];
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
    cell.lblName.text = claimModel.insuredName;
    cell.lblTime.text = taskModel.dispatchDate;
    cell.lblTime.textColor = [UIColor colorWithHexString:Colorgray];
    cell.lblNum.text = [NSString stringWithFormat:@"报案号:%@",claimModel.reportNo];
    cell.lblNum.textColor = [UIColor colorWithHexString:Colorgray];
    cell.lblState.layer.masksToBounds = YES;
    cell.lblState.layer.borderWidth =1;
    cell.lblState.layer.cornerRadius =4;
    cell.lblState.font = [UIFont systemFontOfSize:12];
    cell.lblTaskType.layer.masksToBounds = YES;
    cell.lblTaskType.layer.cornerRadius = 10;
    cell.lblTaskType.backgroundColor = [UIColor colorWithHexString:@"#9DC5F9"];
    cell.lblTaskType.textColor = [UIColor colorWithHexString:Colorwhite];
    if ([taskModel.taskType isEqualToString:@"01"]) {cell.lblTaskType.text = @"医";
    }if ([taskModel.taskType isEqualToString:@"09"]) {cell.lblTaskType.text = @"基";
    }if ([taskModel.taskType isEqualToString:@"10"]) {cell.lblTaskType.text = @"处";
    }
    switch (indexPath.row%4) {
        case 0:
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
        case 3:
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
    [self setHidesBottomBarWhenPushed:YES];
    FollowDetaiViewController *vc = [[FollowDetaiViewController alloc]init];
    vc.claimModel = self.dataArray[indexPath.section];
    vc.taskModel = [MTLJSONAdapter modelOfClass:[TaskModel class] fromJSONDictionary:vc.claimModel.taskList[indexPath.row] error:NULL];
    [self.navigationController pushViewController:vc animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}
-(NSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [_calendar setTimeZone:[[NSTimeZone alloc] initWithName:@"Asia/Shanghai"]];
    }
    return _calendar;
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

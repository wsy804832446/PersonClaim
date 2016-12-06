//
//  CompensationViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/10/9.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "CompensationViewController.h"
#import "SelectCityViewController.h"
#import "CityModel.h"
#import "ComStandardModel.h"
@interface CompensationViewController ()<UIScrollViewDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong)CLLocationManager * locationManger;
@property (nonatomic,strong)CityModel *currentCity;
@property (nonatomic,strong)UISegmentedControl *seg;
@property (nonatomic,strong)UIBarButtonItem *barButtonItem;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)NSArray *denizenIncomeNormArr;
@property (nonatomic,strong)NSArray *compensateStandardArr;
@property (nonatomic,strong)NSArray *otherArr;
//农村标准
@property (nonatomic,strong)CompensatStandard *comStand;
//城镇标准
@property (nonatomic,strong)DenizenIncomeNorm *denizenStand;
@end

@implementation CompensationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentCity = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"CompenCity%@",[CommUtil readDataWithFileName:@"account"]]];
    [self.view addSubview:self.seg];
    [self OpenLocation];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.top = self.seg.bottom+10;
    self.tableView.height = DeviceSize.height-self.tableView.top-64;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = self.barButtonItem;
    self.denizenIncomeNormArr = @[@"城镇人均可支配收入",@"城镇消费性支出",@"在岗职工收入标准"];
    self.compensateStandardArr = @[@"农村人均纯收入",@"农村生活支出",@"农村工资性收入"];
    self.otherArr = @[@"误工费",@"护理费",@"住院伙食补助费",@"营养费",@"交通费",@"住宿费"];
    // Do any additional setup after loading the view.
}
-(void)getData{
    NSInteger year = [[self.seg titleForSegmentAtIndex:self.seg.selectedSegmentIndex]integerValue];
    WeakSelf(CompensationViewController);
    [weakSelf showHudWaitingView:WaitPrompt];
    [[NetWorkManager shareNetWork]getStandardWithRegionId:self.currentCity.Id andStandardYear:year andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if ([response.responseCode isEqual:@"1"]) {
            ComStandardModel *model = [MTLJSONAdapter modelOfClass:[ComStandardModel class] fromJSONDictionary:response.dataDic error:NULL];
            self.comStand = [MTLJSONAdapter modelOfClass:[CompensatStandard class] fromJSONDictionary:model.compensateStandardDTO error:NULL];
            self.denizenStand = [MTLJSONAdapter modelOfClass:[DenizenIncomeNorm class] fromJSONDictionary:model.spDenizenIncomeNormDTO error:NULL];
            [self.tableView reloadData];
        }else{
            [weakSelf showHudAuto:response.message];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf removeMBProgressHudInManaual];
        [weakSelf showHudAuto:InternetFailerPrompt];
    }];
}
-(void)OpenLocation{
    if (self.currentCity) {
        [self getData];
    }else{
        if ([CLLocationManager locationServicesEnabled]) {
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"打开定位服务来允许人伤跟踪系统确定您的位置" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    SelectCityViewController *vc = [[SelectCityViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                UIAlertAction *call = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                [alert addAction:cancel];
                [alert addAction:call];
                [self presentViewController:alert animated:YES completion:nil];
            }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"允许人伤跟踪系统在您使用该应用时，访问您的位置吗?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    SelectCityViewController *vc = [[SelectCityViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                UIAlertAction *call = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //定位功能可用，开始定位
                    [self.locationManger startUpdatingLocation];
                }];
                [alert addAction:cancel];
                [alert addAction:call];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self.locationManger startUpdatingLocation];
            }
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"打开定位服务来允许人伤跟踪系统确定您的位置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SelectCityViewController *vc = [[SelectCityViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            UIAlertAction *call = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alert addAction:cancel];
            [alert addAction:call];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

//自定义rightBarButtonItem
-(UIBarButtonItem *)barButtonItem{
    if (!_barButtonItem) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
        [rightButton setTitle:self.currentCity.name forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        rightButton.frame = CGRectMake(0, 0,18*rightButton.titleLabel.text.length+13,20);
        [rightButton setImage:[UIImage imageNamed:@"地区下拉箭头"] forState:UIControlStateNormal];
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(10,18*rightButton.titleLabel.text.length+3,5,0);
        rightButton.titleEdgeInsets =UIEdgeInsetsMake(0,-10,0,0);
        _barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    }
    return _barButtonItem;
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction:(UIButton *)btn{
    self.hidesBottomBarWhenPushed = YES;
    SelectCityViewController *vc = [[SelectCityViewController alloc]init];
    vc.city = self.currentCity;
    [vc setSelectCityBlock:^(CityModel * city) {
        [btn setTitle:city.name forState:UIControlStateNormal];
        [CommUtil saveData:city andSaveFileName:[NSString stringWithFormat:@"CompenCity%@",[CommUtil readDataWithFileName:@"account"]]];
        [self getData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UISegmentedControl *)seg{
    if (!_seg) {
        //获取当前年份
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
        NSUInteger year = [dateComponent year];
        _seg =[[UISegmentedControl alloc]initWithItems:@[[NSString stringWithFormat:@"%lu",year],[NSString stringWithFormat:@"%lu",year-1],[NSString stringWithFormat:@"%lu",year-2]]];
        _seg.frame = CGRectMake(15, 10, self.view.width-30, 38);
        _seg.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        _seg.selectedSegmentIndex = 0;
        [_seg addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
    }
    return _seg;
}
-(void)changeSeg:(UISegmentedControl *)seg{
    [self getData];
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 6;
    }else{
        return 3;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = self.denizenIncomeNormArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.denizenStand.urbanDisposableIncome] ;
        }else if (indexPath.row ==1){
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.denizenStand.urbanAverageOutlay];
        }else{
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.denizenStand.urbanSalary];
        }
    }else if (indexPath.section == 1){
        cell.textLabel.text = self.compensateStandardArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.denizenStand.ruralNetIncome];
        }else if (indexPath.row ==1){
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.denizenStand.ruralAverageOutlay];
        }else{
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.denizenStand.ruralSalary];
        }
    }else{
        cell.textLabel.text = self.otherArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.comStand.lostIncome];
        }else if (indexPath.row ==1){
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.comStand.standardNurseFee];
        }else if (indexPath.row ==2){
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.comStand.hospitalFoodSubsidies];
        }else if (indexPath.row ==3) {
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.comStand.thesePayments];
        }else if (indexPath.row ==4){
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.comStand.transportationFee];
        }else{
            cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",self.comStand.accommodationFee];
        }
    }
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:Colorblack];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,36)];
    view.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15,9, 3, 18)];
    [line setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
    [view addSubview:line];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(line.right+5, line.top, 0, line.height)];
    if (section == 0) {
        label.text = @"城镇标准";
    }else if (section == 1){
        label.text = @"农村标准";
    }else{
        label.text = @"各项费用标准";
    }
    label.frame = CGRectMake(line.right+5, line.top, 17.5*label.text.length, line.height);
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *viewCut = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,10)];
    viewCut.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
    return viewCut;
}
-(NSString *)title{
    return @"赔偿标准";
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

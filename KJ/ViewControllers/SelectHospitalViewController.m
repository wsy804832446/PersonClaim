//
//  SelectHospitalViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/8.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "SelectHospitalViewController.h"
#import "SelectCityTableViewCell.h"
#import "MyTextField.h"
#import "SelectDefiniteCityViewController.h"
#import "HospitalModel.h"
#import "SelectDepartmentViewController.h"
#import "DepartmentsModel.h"
@interface SelectHospitalViewController ()<UITextFieldDelegate,CLLocationManagerDelegate>
//搜索框
@property (nonatomic,strong)MyTextField *txtSearch;
//RightBarButton
@property (nonatomic,strong)UIBarButtonItem *barButtonItem;
//当前城市
@property (nonatomic,strong)CityModel *currentCity;

@property (nonatomic,strong)CLLocationManager * locationManger;
//下一页科室array
@property (nonatomic,strong)NSMutableArray *departmentsArray;
@end

@implementation SelectHospitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self OpenLocation];
    self.tableView.top = self.txtSearch.bottom+10;
    self.tableView.height = DeviceSize.height-self.tableView.top-64;
    [self setIsOpenFooterRefresh:YES];
    [self setIsOpenHeaderRefresh:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = self.barButtonItem;
    self.tableView.sectionIndexColor = [UIColor colorWithHexString:Colorblue];
    [self.view addSubview:self.txtSearch];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}
//医院数据
-(void)siftDataWithCityCode{
    WeakSelf(SelectHospitalViewController);
    [weakSelf showHudWaitingView:WaitPrompt];
    [[NetWorkManager shareNetWork]getHospitalListWithDealLocalCode:self.currentCity.Id andHospitalName:self.txtSearch.text andPageNo:self.pageNO andPageSize:self.pageSize andFlag:@"1" andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response){
        [weakSelf removeMBProgressHudInManaual];
        if ([response.responseCode isEqual:@"1"]) {
            if (weakSelf.pageNO == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            [self.departmentsArray removeAllObjects];
            for (NSDictionary *dic in response.dataDic[@"dictList"]) {
                DepartmentsModel *model = [MTLJSONAdapter modelOfClass:[DepartmentsModel class] fromJSONDictionary:dic error:NULL];
                [self.departmentsArray addObject:model];
            }
            for (NSDictionary *dic in response.dataDic[@"hosptialList"]) {
                HospitalModel *model = [MTLJSONAdapter modelOfClass:[HospitalModel class] fromJSONDictionary:dic error:NULL];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf showHudAuto:response.message];
            weakSelf.pageNO-=1;
        }
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf removeMBProgressHudInManaual];
        [weakSelf showHudAuto:InternetFailerPrompt];
        weakSelf.pageNO-=1;
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //选择城市cell复用
    SelectCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCityTableViewCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SelectCityTableViewCell" owner:nil options:nil];
        if (nib.count>0) {
            cell = [nib firstObject];
        }
    }
    HospitalModel *model = self.dataArray[indexPath.row];
    cell.cityLabel.text = model.hospitalName;
    cell.cityId = model.hospitalId;
    cell.cityLabel.textColor = [UIColor colorWithHexString:Colorblack];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SelectDepartmentViewController *vc = [[SelectDepartmentViewController alloc]init];
    vc.dataArray = self.departmentsArray;
    vc.hospitalModel = self.dataArray[indexPath.row];
    [vc setSelectBlock:^(HospitalModel *model, NSMutableArray *array) {
        if (self.selectBlock) {
            self.selectBlock(model,array);
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction:(UIButton *)btn{
    SelectDefiniteCityViewController *vc = [[SelectDefiniteCityViewController alloc]init];
    [vc setSelectCityBlock:^(CityModel *cityModel) {
        self.currentCity = cityModel;
        [btn setTitle:cityModel.name forState:UIControlStateNormal];
        [self siftDataWithCityCode];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)txtChange:(MyTextField *)txt{
}
-(void)OpenLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"打开定位服务来允许人伤跟踪系统确定您的位置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SelectDefiniteCityViewController *vc = [[SelectDefiniteCityViewController alloc]init];
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
                SelectDefiniteCityViewController *vc = [[SelectDefiniteCityViewController alloc]init];
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
            SelectDefiniteCityViewController *vc = [[SelectDefiniteCityViewController alloc]init];
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
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
             NSArray *cityArray =[CommUtil readDataWithFileName:@"disorderCityList"];
             for (CityModel *model in cityArray) {
                 if ([model.name isEqual:city]) {
                     self.currentCity =model;
                     [self siftDataWithCityCode];
                 }
             }
         }else if (error == nil && [array count] == 0)
         {
         }else if (error != nil)
         {
             NSLog(@"%@",error);
         }
     }];
}
//监控用户会否授权
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways ||status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
-(void)headerRequestWithData{
    [self siftDataWithCityCode];
}
-(void)footerRequestWithData{
    [self siftDataWithCityCode];
}
-(MyTextField *)txtSearch{
    if (!_txtSearch) {
        _txtSearch = [[MyTextField alloc]initWithFrame:CGRectMake(15, 10, DeviceSize.width-30, 29)];
        _txtSearch.placeholder= @"搜索医院";
        _txtSearch.delegate = self;
        _txtSearch.layer.masksToBounds = YES;
        _txtSearch.layer.cornerRadius = 29*0.16;
        _txtSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
        icon.frame = CGRectMake(6,4.5, 20, 20);
        [_txtSearch addSubview:icon];
        _txtSearch.inset = 31;
        _txtSearch.textColor = [UIColor colorWithHexString:Colorwhite];
        [_txtSearch setValue:[UIColor colorWithHexString:placeHoldColor] forKeyPath:@"_placeholderLabel.textColor"];
        _txtSearch.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        [_txtSearch addTarget:self action:@selector(txtChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _txtSearch;
}
-(UIBarButtonItem *)barButtonItem{
    if (!_barButtonItem) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
        [rightButton setTitle:@"北 京" forState:UIControlStateNormal];
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
-(CLLocationManager *)locationManger{
    if (!_locationManger) {
        _locationManger = [[CLLocationManager alloc]init];
        _locationManger.delegate = self;
        [_locationManger requestAlwaysAuthorization];
    }
    return _locationManger;
}
-(NSMutableArray *)departmentsArray{
    if (!_departmentsArray) {
        _departmentsArray = [NSMutableArray array];
    }
    return _departmentsArray;
}
-(NSString *)title{
    return @"选择医院";
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

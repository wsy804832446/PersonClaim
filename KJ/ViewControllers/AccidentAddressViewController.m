//
//  AccidentAddressViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/10/21.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "AccidentAddressViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "SearchViewController.h"
@interface AccidentAddressViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource>
//顶部搜索框
@property (nonatomic,strong)UIButton *btnSearch;
@property (nonatomic,strong)BMKMapView *mapView;
@property (nonatomic,strong)BMKLocationService *locService;
@property (nonatomic,strong)BMKPoiSearch *searcher;
//定位显示label
@property (nonatomic,strong)UILabel *label;
//底部定位view
@property (nonatomic,strong)UITableView *tableView;
//附近建筑数组
@property (nonatomic,strong)NSMutableArray *dataArray;
//当前地址（展示）
@property (nonatomic,copy)NSString *currentAddress;
//底部是否展开附近
@property(nonatomic,assign)BOOL isSelect;
//锁定位置
@property(nonatomic,assign)BOOL isLockAddress;
//大头针数组
@property (nonatomic,strong)NSMutableArray *AnnotationArray;
//地理编码对象
@property (nonatomic,strong)BMKGeoCodeSearch *GeoCodesearch;
@end

@implementation AccidentAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelect = NO;
    self.isLockAddress = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"确定"];
    self.navigationItem.titleView = self.btnSearch;
    UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 29)];
    vc.backgroundColor = [UIColor colorWithHexString:Colorblue];
    self.navigationItem.titleView = self.btnSearch;
    [self addMapVc];
    [self.view addSubview:self.tableView];
}
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
    // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    if (self.selectAddressBlock) {
        self.selectAddressBlock(self.label.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)search{
    SearchViewController *vc = [[SearchViewController alloc]init];
    [self.locService stopUserLocationService];
    [vc setSearchBlock:^(NSString *key) {
        BMKGeoCodeSearchOption *option = [[BMKGeoCodeSearchOption alloc]init];
        option.address = key;
        [self.GeoCodesearch geoCode:option];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addMapVc{
    self.view =self.mapView;
}

-(void)locClick{
    self.isLockAddress = NO;
    [self.locService stopUserLocationService];
    [self.locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}
-(void)arrowClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [UIView animateWithDuration:0.5 animations:^{
             self.tableView.frame = CGRectMake(15,DeviceSize.height-365-15-64, DeviceSize.width-30, 365);
        }];
    }else{
        [self closeNear];
    }
    self.isSelect = btn.selected;
}

//更新位置
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = userLocation.location.coordinate;
    [self.GeoCodesearch reverseGeoCode:rever];
}
//更新方向
-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [_mapView updateLocationData:userLocation];
}
//地理编码
-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = result.location;
    [self.GeoCodesearch reverseGeoCode:rever];
}
//反地理编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (!self.isLockAddress) {
        [_mapView removeAnnotations:self.AnnotationArray];
        self.currentAddress = result.address;
        self.isLockAddress = YES;
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = result.location;
        annotation.title = result.address;
        [_mapView addAnnotation:annotation];
        _mapView.centerCoordinate = result.location;
        [self.AnnotationArray addObject:annotation];
    }
    self.dataArray =[NSMutableArray arrayWithArray:result.poiList];
    [self.tableView reloadData];
}
// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(15, self.view.bottom-70-64, DeviceSize.width-30, 55)];
    vc.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    vc.layer.masksToBounds = YES;
    vc.layer.cornerRadius = 55*0.16;
    UIButton *btnLoc = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLoc.frame = CGRectMake(0, 0, 37, 55);
    [btnLoc setImage:[UIImage imageNamed:@"32"] forState:UIControlStateNormal];
    [btnLoc setImageEdgeInsets:UIEdgeInsetsMake(17, 15, 17, 6)];
    [btnLoc addTarget:self action:@selector(locClick) forControlEvents:UIControlEventTouchUpInside];
    [vc addSubview:btnLoc];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(btnLoc.right, 0, vc.width-37-15-37, vc.height)];
    _label.textColor = [UIColor colorWithHexString:Colorblack];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.text = self.currentAddress;
    [vc addSubview:_label];
    UIButton *btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    btnArrow.frame = CGRectMake(_label.right, 0, 52, 55);
    [btnArrow setImage:[UIImage imageNamed:@"31-1"] forState:UIControlStateNormal];
    [btnArrow setImage:[UIImage imageNamed:@"31"] forState:UIControlStateSelected];
    [btnArrow setImageEdgeInsets:UIEdgeInsetsMake(33/2, 0, 33/2, 15)];
    [btnArrow addTarget:self action:@selector(arrowClick:) forControlEvents:UIControlEventTouchUpInside];
    btnArrow.selected = self.isSelect;
    [vc addSubview:btnArrow];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, btnArrow.bottom, vc.width-30, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [vc addSubview:line];
    return vc;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
    }
    BMKPoiInfo *info = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text =info.name;
    cell.textLabel.textColor = [UIColor colorWithHexString:Colorblack];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = info.address;
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:Colorgray];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BMKPoiInfo *info = [self.dataArray objectAtIndex:indexPath.row];
    self.currentAddress = info.name;
    [self closeNear];
    [_mapView removeAnnotations:self.AnnotationArray];
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor =info.pt;
    annotation.coordinate = coor;
    annotation.title = info.name;
    [_mapView addAnnotation:annotation];
    _mapView.centerCoordinate = coor;
    [self.AnnotationArray addObject:annotation];
}

//收起底部附近列表
-(void)closeNear{
    self.isSelect = NO;
    [self.tableView reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.frame = CGRectMake(15, self.view.bottom-70-64, DeviceSize.width-30, 55);
        self.tableView.contentOffset = CGPointMake(0, 0);
    }];
    
}
-(BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, self.view.height)];
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView.zoomLevel = 19;
    }
    return _mapView;
}
-(BMKLocationService *)locService{
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate =self;
    }
    return _locService;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, self.view.bottom-70-64, DeviceSize.width-30, 55)style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 55*0.16;
    }
    return _tableView;
}
-(UIButton *)btnSearch{
    if (!_btnSearch) {
        _btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSearch.frame = CGRectMake(0, 0, 200, 29);
        [_btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
        [_btnSearch setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
        _btnSearch.layer.masksToBounds = YES;
        _btnSearch.layer.cornerRadius =29*0.16;
        [_btnSearch setImage:[UIImage imageNamed:@"8-搜索"] forState:UIControlStateNormal];
        [_btnSearch setImage:[UIImage imageNamed:@"8-搜索-1"] forState:UIControlStateHighlighted];
        [_btnSearch setImageEdgeInsets:UIEdgeInsetsMake(3.5, 78, 3.5, 100)];
        _btnSearch.backgroundColor = [UIColor colorWithHexString:Colorwhite alpha:0.18];
        [_btnSearch addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSearch;
}
-(NSMutableArray *)AnnotationArray{
    if (!_AnnotationArray) {
        _AnnotationArray = [NSMutableArray array];
    }
    return _AnnotationArray;
}
-(BMKGeoCodeSearch *)GeoCodesearch{
    if (!_GeoCodesearch) {
        _GeoCodesearch = [[BMKGeoCodeSearch alloc]init];
        _GeoCodesearch.delegate = self;
    }
    return _GeoCodesearch;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _searcher.delegate = self;
    _locService.delegate = self;
    _GeoCodesearch.delegate = self;
    self.isLockAddress =NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;
    _locService.delegate = nil;
    _GeoCodesearch.delegate = nil;
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

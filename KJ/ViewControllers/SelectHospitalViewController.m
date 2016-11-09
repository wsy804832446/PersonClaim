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
@interface SelectHospitalViewController ()<UITextFieldDelegate>
//搜索框
@property (nonatomic,strong)MyTextField *txtSearch;
//索引字母数组
@property (nonatomic,strong)NSMutableArray *sectionIndexArr;
//索引字母下医院
@property (nonatomic,strong)NSMutableDictionary *sectionIndexDic;
//选中cell的Index
@property (nonatomic,strong)NSIndexPath *CellIndex;
//RightBarButton
@property (nonatomic,strong)UIBarButtonItem *barButtonItem;
@end

@implementation SelectHospitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VCstyle = UITableViewStylePlain;
    self.tableView.top = self.txtSearch.bottom;
    self.tableView.height = DeviceSize.height-self.tableView.top-64;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = self.barButtonItem;
    [self siftDataWithCityCode:@""];
    self.tableView.sectionIndexColor = [UIColor colorWithHexString:Colorblue];
    [self.view addSubview:self.txtSearch];
    // Do any additional setup after loading the view.
}
//医院数据
-(void)siftDataWithCityCode:(NSString *)cityId{
    WeakSelf(SelectHospitalViewController);
    [weakSelf showHudWaitingView:WaitPrompt];
    [[NetWorkManager shareNetWork]getCityListWithSearchCode:cityId andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if ([response.responseCode isEqual:@"1"]) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.sectionIndexArr removeAllObjects];
            [weakSelf.sectionIndexDic removeAllObjects];
            for (NSDictionary *dic in response.dataArray){
                CityModel *model = [MTLJSONAdapter modelOfClass:[CityModel class] fromJSONDictionary:dic error:NULL];
                [weakSelf.dataArray addObject:model];
            }
            for (CityModel *model in self.dataArray){
                NSString *character = [self firstCharactor:model.name];
                //之后往字母索引字典里放
                if (![_sectionIndexDic objectForKey:character]) {
                    [_sectionIndexDic setObject:[NSMutableArray array] forKey:character];
                }
                if (![_sectionIndexArr containsObject:character]) {
                    [_sectionIndexArr addObject:character];
                }
                [_sectionIndexDic[character] addObject:model];
            }
            [_sectionIndexArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return obj1>obj2;
            }];
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf showHudAuto:response.message];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf removeMBProgressHudInManaual];
        [weakSelf showHudAuto:InternetFailerPrompt];
    }];
    
}
//汉子转拼音首字母
- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionIndexArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    for (NSString *str in _sectionIndexDic.allKeys) {
        if ([_sectionIndexArr[section] isEqual:str]) {
            return [_sectionIndexDic[str] count];
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCityTableViewCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SelectCityTableViewCell" owner:nil options:nil];
        if (nib.count>0) {
            cell = [nib firstObject];
        }
    }
    if (indexPath.section<_sectionIndexArr.count) {
        NSString *key = _sectionIndexArr[indexPath.section];
        NSArray *cityArray = [_sectionIndexDic objectForKey:key];
        if (indexPath.row<cityArray.count) {
            CityModel *model = cityArray[indexPath.row];
            cell.cityLabel.text = model.name;
            cell.cityId = model.Id;
        }
        cell.cityLabel.textColor = [UIColor colorWithHexString:Colorblack];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SelectCityTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.SelectCityBlock) {
        self.SelectCityBlock(cell.cityLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 36)];
    view.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 0, 36)];
    label.text = _sectionIndexArr[section];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:Colorgray];
    label.frame = CGRectMake(15, 0, label.text.length*15, 36);
    [view addSubview:label];
    return view;
}
-(NSArray<NSString *>*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [_sectionIndexArr subarrayWithRange:NSMakeRange(1, _sectionIndexArr.count-1)];
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    [tableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index+1]
     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index+1;
}
-(NSMutableArray *)sectionIndexArr{
    if (!_sectionIndexArr) {
        _sectionIndexArr = [NSMutableArray array];
    }
    return _sectionIndexArr;
}
-(NSMutableDictionary *)sectionIndexDic{
    if (!_sectionIndexDic) {
        _sectionIndexDic = [NSMutableDictionary dictionary];
    }
    return _sectionIndexDic;
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    SelectDefiniteCityViewController *vc = [[SelectDefiniteCityViewController alloc]init];
    vc.cityLevel = 2;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)txtChange:(MyTextField *)txt{
    //11111111111111
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
        [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
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

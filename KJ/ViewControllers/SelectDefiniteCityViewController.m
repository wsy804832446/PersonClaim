//
//  SelectDefiniteCityViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/8.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "SelectDefiniteCityViewController.h"
#import "OnlyLabelTableViewCell.h"
@interface SelectDefiniteCityViewController ()
//市级tableview
@property (nonatomic,strong)UITableView *tableViewTown;
@property (nonatomic,strong)NSMutableArray *townDataArray;
//县级tableview
@property (nonatomic,strong)UITableView *tableViewCounty;
@property (nonatomic,strong)NSMutableArray *countyDataArray;
//选中cell的Index
@property (nonatomic,strong)NSIndexPath *CellIndex;
@end

@implementation SelectDefiniteCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 0, 120, DeviceSize.height-64);
    self.tableView.tag = 1000;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    [self siftDataWithCityCode:@""andLevel:1];
    // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//城市数据
-(void)siftDataWithCityCode:(NSString *)cityId andLevel:(NSInteger)level{
    CityModel *model =[CommUtil readDataWithFileName:@"cityList"];
    if (model) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:model.array];
        [self.tableView reloadData];
    }
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1000) {
        return self.dataArray.count;
    }else if (tableView.tag == 1001){
        return self.townDataArray.count;
    }else if (tableView.tag == 1002){
        return self.countyDataArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1000) {
        OnlyLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnlyLabelCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"OnlyLabelTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
        CityModel *model = self.dataArray[indexPath.row];
        cell.lblTitle.text = model.name;
        cell.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        return cell;
    }else if (tableView.tag == 1001){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        CityModel *model = self.townDataArray[indexPath.row];
        cell.textLabel.text = model.name;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithHexString:Colorblack];
        return cell;
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1000) {
        for (int i=0; i<self.dataArray.count; i++) {
            OnlyLabelTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (i == indexPath.row) {
                cell.backgroundColor = [UIColor colorWithHexString:Colorwhite];
                cell.lblTitle.textColor = [UIColor colorWithHexString:Colorblack];
            }else{
                cell.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
                cell.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
            }
        }
        CityModel *model = self.dataArray[indexPath.row];
        [self.townDataArray removeAllObjects];
        [self.townDataArray addObjectsFromArray:model.array];
        [self.view addSubview:self.tableViewTown];
        [self.tableViewTown reloadData];
    }else if(tableView.tag == 1001){
        CityModel *model = self.townDataArray[indexPath.row];
        if (self.SelectCityBlock) {
            self.SelectCityBlock(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
    }
}
- (UITableView *)tableViewTown
{
    if (!_tableViewTown) {
        _tableViewTown = [[UITableView alloc] initWithFrame:CGRectMake(self.tableView.right, 0, DeviceSize.width-self.tableView.width, self.tableView.height) style:UITableViewStylePlain];
        _tableViewTown.tag = 1001;
        [_tableViewTown setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        _tableViewTown.showsVerticalScrollIndicator =NO;
        _tableViewTown.delegate = self;
        _tableViewTown.dataSource = self;
        _tableViewTown.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        //  去掉空白多余的行
        _tableViewTown.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableViewTown;
}
- (UITableView *)tableViewCounty
{
    if (!_tableViewCounty) {
        _tableViewCounty = [[UITableView alloc] initWithFrame:CGRectMake(self.tableView.right, 0, DeviceSize.width-self.tableView.width, self.tableView.height) style:UITableViewStylePlain];
        _tableViewCounty.tag = 1002;
        _tableViewCounty.showsVerticalScrollIndicator =NO;
        _tableViewCounty.delegate = self;
        _tableViewCounty.dataSource = self;
        _tableViewCounty.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        //  去掉空白多余的行
        _tableViewCounty.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableViewCounty;
}
-(NSMutableArray *)townDataArray{
    if (!_townDataArray) {
        _townDataArray = [NSMutableArray array];
    }
    return _townDataArray;
}
-(NSMutableArray *)countyDataArray{
    if (!_countyDataArray) {
        _countyDataArray = [NSMutableArray array];
    }
    return _countyDataArray;
}
-(NSString *)title{
    return @"选择区域";
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

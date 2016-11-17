//
//  SelectCityViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/10/9.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "SelectCityViewController.h"
#import "SelectCityTableViewCell.h"

@interface SelectCityViewController ()
//索引字母数组
@property (nonatomic,strong)NSMutableArray *sectionIndexArr;
//索引字母下城市
@property (nonatomic,strong)NSMutableDictionary *sectionIndexDic;
//选中cell的Index
@property (nonatomic,strong)NSIndexPath *CellIndex;
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    [self siftDataWithCityCode:@""];
    self.tableView.sectionIndexColor = [UIColor colorWithHexString:Colorblue];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}
//城市数据
-(void)siftDataWithCityCode:(NSString *)cityId{
    CityModel *model = [CommUtil readDataWithFileName:@"cityList"];
    if (model) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:model.array];
        [self disposalData];
    }
}
//整理数据
-(void)disposalData{
    //当前位置空索引
    [self.sectionIndexArr addObject:@""];
    [self.sectionIndexDic setObject:@"empty" forKey:@[]];
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
    if (section == 0) {
        return 1;
    }
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
    if (indexPath.section == 0) {
        cell.cityLabel.text = self.city;
        cell.imgView.image = [UIImage imageNamed:@"切图-全_r21_c17"];
    }else{
        if (indexPath.section<_sectionIndexArr.count) {
            NSString *key = _sectionIndexArr[indexPath.section];
            NSArray *cityArray = [_sectionIndexDic objectForKey:key];
            if (indexPath.row<cityArray.count) {
                CityModel *model = cityArray[indexPath.row];
                cell.cityLabel.text = model.name;
                cell.cityId = model.Id;
            }
        }
    }
    cell.cityLabel.textColor = [UIColor colorWithHexString:Colorblack];
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
    return 29;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 29)];
    view.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 0, 29)];
    if (section == 0) {
        label.text = @"当前位置";
        label.font = [UIFont systemFontOfSize:12];
    }else{
        label.text = _sectionIndexArr[section];
        label.font = [UIFont systemFontOfSize:15];
    }
    label.textColor = [UIColor colorWithHexString:Colorgray];
    label.frame = CGRectMake(15, 0, label.text.length*15, 29);
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

-(NSString *)title{
    return @"地区选择";
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

//
//  SearchDiagnoseViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/17.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "SearchDiagnoseViewController.h"
#import "MyTextField.h"
#import "AddDiagnoseDetailTableViewCell.h"
#import "DiagnoseDetailModel.h"
#import "SelectWayViewController.h"
@interface SearchDiagnoseViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)MyTextField *txtSearch;
//搜索框是否为空
@property(nonatomic,assign)BOOL isEmpty;
@property (nonatomic,strong)NSMutableArray *searchHistoryArray;
//占位图
@property (nonatomic,strong)UIView *emptyVc;
//数据类型 是否为历史记录
@property (nonatomic,assign)BOOL isDataKindHistory;
@end

@implementation SearchDiagnoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets =NO;
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"取消"];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = self.txtSearch;
    self.tableView.top =10;
    self.tableView.height =DeviceSize.height-74;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    self.isEmpty = YES;
    self.dataArray =[NSMutableArray arrayWithArray: [CommUtil readDataWithKey:@"DiagnoseHistory"]];
    if (self.dataArray.count ==0) {
        [self.tableView addSubview:self.emptyVc];
    }
    self.isDataKindHistory = YES;
}
-(void)getDataWithSearch:(NSString *)search{
    WeakSelf(SearchDiagnoseViewController);
    [weakSelf showHudWaitingView:WaitPrompt];
    [[NetWorkManager shareNetWork]getDiagnoseDeatilListWithKindCode:self.body.Id andSearchCode:search                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    andPageNo:self.pageNO andPageSize:self.pageSize andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if ([response.responseCode isEqual:@"1"]) {
            if (weakSelf.pageNO == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in response.dataDic[@"disabList"]) {
                DiagnoseDetailModel *model = [MTLJSONAdapter modelOfClass:[DiagnoseDetailModel class]  fromJSONDictionary:dic error:NULL];
                [weakSelf.dataArray addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf removeMBProgressHudInManaual];
    }];

}
-(void)rightAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)txtChange:(MyTextField *)txt{
    if (txt.text.length>0) {
        self.isDataKindHistory = NO;
        self.isEmpty = NO;
        [self getDataWithSearch:txt.text];
    }else{
        self.isEmpty = YES;
        self.isDataKindHistory = YES;
        self.dataArray = [NSMutableArray arrayWithArray: [CommUtil readDataWithKey:@"DiagnoseHistory"]];
        [self.tableView reloadData];
        if (self.dataArray.count ==0) {
            [self addEmptyView];
        }
    }
}
//添加占位图
-(void)addEmptyView{
    for (UIView *vc in self.tableView.subviews) {
        if (vc.tag == 666) {
            return;
        }
    }
    [self.tableView addSubview:self.emptyVc];
}
-(void)delete{
    [CommUtil deleteDateWithFileName:@"DiagnoseHistory"];
    self.dataArray =[NSMutableArray array];
    [self.tableView reloadData];
    [self addEmptyView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isEmpty &&self.dataArray.count>10) {
        return 10;
    }
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isDataKindHistory) {
        return 44;
    }else{
        return 55;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isDataKindHistory) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYCELL"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MYCELL"];
        }
        cell.textLabel.text = self.dataArray[indexPath.row];
        return cell;
    }else{
        AddDiagnoseDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiagnoseDetail"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AddDiagnoseDetailTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = nib.firstObject;
            }
        }
        DiagnoseDetailModel *model = self.dataArray[indexPath.row];
        cell.lblCode.text = model.itemCode;
        cell.lblName.text = model.itemCnName;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isEmpty && self.dataArray.count>0) {
        return 44;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 45)];
    vc.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 44)];
    lbl.textColor = [UIColor colorWithHexString:placeHoldColor];
    lbl.text = @"历史记录";
    lbl.font = [UIFont systemFontOfSize:15];
    [vc addSubview:lbl];
    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.frame = CGRectMake(DeviceSize.width-15-50, 0, 50, 44);
    [btnDelete addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [btnDelete setImage:[UIImage imageNamed:@"14-地图_r2_c2(2)"] forState:UIControlStateNormal];
    [btnDelete setImageEdgeInsets:UIEdgeInsetsMake(33/2, 39, 33/2, 0)];
    [vc addSubview:btnDelete];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 44, DeviceSize.width-30, 1)];
    line.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
    [vc addSubview:line];
    return vc;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DiagnoseDetailModel *model =self.dataArray[indexPath.row];
    //筛选历史记录是否重复
    BOOL isExist = NO;
    for (DiagnoseDetailModel *diagnoseDetailModel in self.searchHistoryArray) {
        if ([diagnoseDetailModel.itemCnName isEqualToString:model.itemCnName]) {
            isExist =YES;
        }
    }
    if (!isExist) {
        [self.searchHistoryArray addObject:model];
        [CommUtil saveUserDefaultsWithObject:[NSArray arrayWithArray:self.searchHistoryArray] andUserDefaultsWithName:@"DiagnoseHistory"];
    }
    SelectWayViewController *vc = [[SelectWayViewController alloc]init];
    vc.diagnoseDetailModel =model;
    [self.navigationController pushViewController:vc animated:YES];
}
-(MyTextField *)txtSearch{
    if (!_txtSearch) {
        _txtSearch = [[MyTextField alloc]initWithFrame:CGRectMake(0, 0, 300, 29)];
        _txtSearch.placeholder= @"搜索诊断名称";
        _txtSearch.delegate = self;
        _txtSearch.layer.masksToBounds = YES;
        _txtSearch.layer.cornerRadius = 29*0.16;
        _txtSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"8-搜索"]];
        icon.frame = CGRectMake(7,3.5, 22, 22);
        [_txtSearch addSubview:icon];
        _txtSearch.inset = 34;
        _txtSearch.textColor = [UIColor colorWithHexString:Colorwhite];
        [_txtSearch setValue:[UIColor colorWithHexString:Colorwhite] forKeyPath:@"_placeholderLabel.textColor"];
        _txtSearch.backgroundColor = [UIColor colorWithHexString:Colorwhite alpha:0.18];
        [_txtSearch addTarget:self action:@selector(txtChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _txtSearch;
}
-(NSMutableArray *)searchHistoryArray{
    if (!_searchHistoryArray) {
        _searchHistoryArray = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistory"]];
    }
    return _searchHistoryArray;
}
-(UIView *)emptyVc{
    if (!_emptyVc) {
        _emptyVc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, DeviceSize.height)];
        _emptyVc.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        UIImageView *imgVc = [[UIImageView alloc]initWithFrame:CGRectMake((DeviceSize.width-267)/2, 70, 267, 267)];
        imgVc.image = [UIImage imageNamed:@"2-搜索空白页"];
        [_emptyVc addSubview:imgVc];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(imgVc.left, imgVc.bottom+19, imgVc.width, 16)];
        lbl.text = @"主人，未搜索到相关内容哦";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor colorWithHexString:@"#666666"];
        [_emptyVc addSubview:lbl];
        _emptyVc.tag = 666;
    }
    return _emptyVc;
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

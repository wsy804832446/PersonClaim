//
//  SelectDisabilityTypeViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/23.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "SelectDisabilityTypeViewController.h"
#import "DisabilityModel.h"
#import "DisabilityTableViewCell.h"
@interface SelectDisabilityTypeViewController ()
@property (nonatomic,strong)UIScrollView *searchScrollView;
@property (nonatomic,strong)UIButton *btnSearch;
//标题名称数组
@property (nonatomic,strong)NSArray *itemsArr;
//选中index
@property (nonatomic,assign)NSInteger selectIndex;
//segment条
@property (nonatomic,strong)UIView *buttonDown;
//标题按钮数组
@property (nonatomic,strong)NSMutableArray *ButtonArray;
//选中项目数组
@property (nonatomic,strong)NSMutableArray *selectArray;
@end

@implementation SelectDisabilityTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"确定"];
    self.itemsArr =  @[@"一级",@"二级",@"三级",@"四级",@"五级",@"六级",@"七级",@"八级",@"九级",@"十级"];
    self.tableView.top = self.btnSearch.bottom+10;
    self.tableView.height = DeviceSize.height-self.tableView.top-64;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setIsOpenFooterRefresh:YES];
    [self setIsOpenHeaderRefresh:YES];
    self.selectIndex = 0;
    [self.view addSubview:self.searchScrollView];
    [self.view addSubview:self.btnSearch];
    [self AddSegumentArray:_itemsArr];
    [self getDisabilityData];
    // Do any additional setup after loading the view.
}
-(void)getDisabilityData{
    NSString *gadeCode;
    switch (self.selectIndex) {
        case 0:
            gadeCode = @"01";
            break;
        case 1:
            gadeCode = @"02";
            break;
        case 2:
            gadeCode = @"03";
            break;
        case 3:
            gadeCode = @"04";
            break;
        case 4:
            gadeCode = @"05";
            break;
        case 5:
            gadeCode = @"06";
            break;
        case 6:
            gadeCode = @"07";
            break;
        case 7:
            gadeCode = @"08";
            break;
        case 8:
            gadeCode = @"09";
            break;
        case 9:
            gadeCode = @"10";
            break;
        default:
            break;
    }
    WeakSelf(SelectDisabilityTypeViewController);
    [[NetWorkManager shareNetWork]getDisabilityListWithGadeCode:gadeCode andSearchCode:@"" andPageNo:weakSelf.pageNO andPageSize:weakSelf.pageSize CompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response){
        if ([response.responseCode isEqual:@"1"]) {
            if (weakSelf.pageNO == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in response.dataDic[@"disabList"]) {
                DisabilityModel *model = [MTLJSONAdapter modelOfClass:[DisabilityModel class] fromJSONDictionary:dic error:NULL];
                model.disabilityName =weakSelf.itemsArr[weakSelf.selectIndex];
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
-(void)AddSegumentArray:(NSArray *)SegumentArray
{
    CGFloat witdFloat=(DeviceSize.width-50)/6;
    for (int i=0; i<SegumentArray.count; i++) {
        UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(i*witdFloat, 0, witdFloat,35)];
        [button setTitle:SegumentArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:Colorblue]  forState:UIControlStateSelected];
        [button setTag:1000+i];
        [button addTarget:self action:@selector(changeTheSegument:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            self.buttonDown=[[UIView alloc]initWithFrame:CGRectMake(i*witdFloat,button.bottom, witdFloat, 3)];
            [_buttonDown setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
            [_searchScrollView addSubview:_buttonDown];
        }
        [_searchScrollView addSubview:button];
        [self.ButtonArray addObject:button];
    }
    [[self.ButtonArray firstObject] setSelected:YES];
}
-(void)changeTheSegument:(UIButton*)button
{
    [self selectTheSegument:button.tag-1000];
}
-(void)selectTheSegument:(NSInteger)segument
{
    if (self.selectIndex!=segument) {
        [self.ButtonArray[_selectIndex] setSelected:NO];
        UIButton *btn = self.ButtonArray[segument] ;
        [btn setSelected:YES];
        [UIView animateWithDuration:0.5 animations:^{
            [_buttonDown setFrame:CGRectMake(btn.left,btn.bottom,btn.width, 3)];
        }];
        _selectIndex=segument;
    }
    [self getDisabilityData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DisabilityTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DisabilityCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DisabilityTableViewCell" owner:self options:nil];
        if (nib.count > 0) {
            cell = nib.firstObject;
        }
    }
    if (indexPath.row == 0) {
        cell.line.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    }else{
        cell.line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    }
    cell.btnSelect.tag = 1000+indexPath.row;
    [cell.btnSelect addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell configCellWithModel:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)btnClick:(UIButton *)btn{
    DisabilityModel *model = self.dataArray[btn.tag-1000];
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.selectArray addObject:model];
    }else{
        [self.dataArray removeObject:model];
    }
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    if (self.selectBlock) {
        self.selectBlock(self.selectArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)title{
    return @"选择伤残类型";
}
-(NSMutableArray *)ButtonArray{
    if (!_ButtonArray) {
        _ButtonArray = [NSMutableArray array];
    }
    return _ButtonArray;
}
- (UIScrollView *)searchScrollView{
    if (!_searchScrollView) {
        _searchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceSize.width, 38)];
        _searchScrollView.delegate = self;
        _searchScrollView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        _searchScrollView.contentSize = CGSizeMake(DeviceSize.width/4*_itemsArr.count, 38);
        _searchScrollView.showsHorizontalScrollIndicator = NO;
        _searchScrollView.showsVerticalScrollIndicator = NO;
        _searchScrollView.pagingEnabled = NO;
        _searchScrollView.bouncesZoom = NO;
    }
    return _searchScrollView;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UIButton *btn = [self.view viewWithTag:scrollView.contentOffset.x/DeviceSize.width+1000];
    [self selectTheSegument:btn.tag-1000];
    self.searchScrollView.contentOffset = CGPointMake(btn.left, 0);
}
-(UIButton *)btnSearch{
    if (!_btnSearch) {
        _btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSearch.frame = CGRectMake(30, self.searchScrollView.bottom+10, DeviceSize.width-60, 29);
        [_btnSearch setTitle:@"搜索伤残类型" forState:UIControlStateNormal];
        [_btnSearch setTitleColor:[UIColor colorWithHexString:placeHoldColor] forState:UIControlStateNormal];
        _btnSearch.layer.masksToBounds = YES;
        _btnSearch.layer.cornerRadius =29*0.16;
        [_btnSearch setImage:[UIImage imageNamed:@"8-搜索"] forState:UIControlStateNormal];
        [_btnSearch setImage:[UIImage imageNamed:@"8-搜索-1"] forState:UIControlStateHighlighted];
        [_btnSearch setImageEdgeInsets:UIEdgeInsetsMake(3.5, 78, 3.5, 100)];
        _btnSearch.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        [_btnSearch addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSearch;
}
-(void)search{
    
}
-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
-(void)headerRequestWithData{
    [self getDisabilityData];
}
-(void)footerRequestWithData{
    [self getDisabilityData];
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

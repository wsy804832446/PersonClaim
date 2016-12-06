//
//  LayViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/12/7.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "LayViewController.h"
#import "SelectCityViewController.h"
#import "ToolTableViewCell.h"
#import "DetailViewController.h"
#import "LayModel.h"
@interface LayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIBarButtonItem *barButtonItem;
@property (nonatomic,strong)UIScrollView *searchScrollView;
//标题名称数组
@property (nonatomic,strong)NSArray *itemsArr;
//选中index
@property (nonatomic,assign)NSInteger selectIndex;
//segment条
@property (nonatomic,strong)UIView *buttonDown;
//标题按钮数组
@property (nonatomic,strong)NSMutableArray *ButtonArray;
@end

@implementation LayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = self.barButtonItem;
    self.itemsArr =  @[@"临床鉴定",@"精神损害",@"道路交通",@"民事诉讼",@"xxxx",@"xxxx",@"临床鉴定",@"精神损害"];
    self.selectIndex = 0;
    [self.view addSubview:self.searchScrollView];
    [self AddSegumentArray:_itemsArr];
    self.tableView.top = self.searchScrollView.bottom+10;
    self.tableView.height = DeviceSize.height-64-self.tableView.top;
    self.isOpenFooterRefresh = YES;
    self.isOpenHeaderRefresh = YES;
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    WeakSelf(LayViewController);
    [weakSelf showHudWaitingView:WaitPrompt];
    [[NetWorkManager shareNetWork]getLayWithPageNo:self.pageNO andPageSize:self.pageSize andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if ([response.responseCode isEqual:@"1"]) {
            if (weakSelf.pageNO == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in response.dataDic[@"lawsList"]) {
                LayModel *model = [MTLJSONAdapter modelOfClass:[LayModel class] fromJSONDictionary:dic error:NULL];
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
    CGFloat witdFloat=(DeviceSize.width)/4;
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
-(void)changeTheSegument:(UIButton*)button{
    [self selectTheSegument:button.tag-1000];
}
-(void)selectTheSegument:(NSInteger)segument{
    if (self.selectIndex!=segument) {
        [self.ButtonArray[_selectIndex] setSelected:NO];
        UIButton *btn = self.ButtonArray[segument] ;
        [btn setSelected:YES];
        [UIView animateWithDuration:0.5 animations:^{
            [_buttonDown setFrame:CGRectMake(btn.left,btn.bottom,btn.width, 3)];
        }];
        _selectIndex=segument;
    }
}
 //自定义rightBarButtonItem
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
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction:(UIButton *)btn{
    self.hidesBottomBarWhenPushed = YES;
    SelectCityViewController *vc = [[SelectCityViewController alloc]init];
    [vc setSelectCityBlock:^(CityModel * city) {
         [btn setTitle:city.name forState:UIControlStateNormal];
     }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ToolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToolTableViewCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ToolTableViewCell" owner:nil options:nil];
        if (nib.count>0) {
        cell = nib.lastObject;
        }
    }
    LayModel *model = self.dataArray[indexPath.row];
    cell.Detail.text = model.lawShortName;
    cell.Detail.numberOfLines = 2;
    cell.kind.text = model.createUserId;
    cell.kind.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.time.text = model.createDate;
    cell.time.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.labelConstrains.constant = -12;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setHidesBottomBarWhenPushed:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *vc = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSMutableArray *)ButtonArray{
    if (!_ButtonArray) {
     _ButtonArray = [NSMutableArray array];
    }
    return _ButtonArray;
}
-(void)headerRequestWithData{
    [self getData];
}
-(void)footerRequestWithData{
    [self getData];
}
-(NSString *)title{
    return @"法律法规";
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

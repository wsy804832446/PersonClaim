//
//  BaseTableViewController.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MJRefresh.h"
@interface BaseTableViewController ()
@property (nonatomic, assign)   UITableViewStyle tableViewStyle;
@property (nonatomic, strong)   UITableView *tableView;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNO = 1;
    _pageSize = 20;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:Colorblue]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:Colorwhite],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
    [self.view addSubview:self.tableView];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    // Do any additional setup after loading the view.
}
#pragma mark - UITableViewDelegate

- (void)setIsOpenHeaderRefresh:(BOOL)isOpenHeaderRefresh
{
    if (_isOpenHeaderRefresh != isOpenHeaderRefresh) {
        _isOpenHeaderRefresh = isOpenHeaderRefresh;
        WeakSelf(BaseTableViewController);
        if (isOpenHeaderRefresh) {
            //  设置头部刷新
            self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                weakSelf.pageNO = 1;
                [weakSelf headerRequestWithData];
            }];
        }
    }
}

- (void)setIsOpenFooterRefresh:(BOOL)isOpenFooterRefresh
{
    if (_isOpenFooterRefresh != isOpenFooterRefresh) {
        _isOpenFooterRefresh = isOpenFooterRefresh;
        WeakSelf(BaseTableViewController);
        if (isOpenFooterRefresh) {
            //  设置脚部刷新
            self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                weakSelf.pageNO++;
                [weakSelf footerRequestWithData];
            }];
        }
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.top = self.viewTop;
        _tableView.height -= self.frameTopHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
        
        //  去掉空白多余的行
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (id)initWithTableViewStyle:(UITableViewStyle)tableViewStyle
{
    self = [super init];
    if (self) {
        _tableViewStyle = tableViewStyle;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark -- UITableViewDelegate 分割线定格
/*
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
 [cell setLayoutMargins:UIEdgeInsetsZero];
 }
 }
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 0.1)];
    label.backgroundColor = [UIColor colorWithHEX:0xd9d9d9];
    return label;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (void)headerRequestWithData
{
    //  空操作
}


- (void)footerRequestWithData
{
    //  空操作
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

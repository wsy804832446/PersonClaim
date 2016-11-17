//
//  CompensationViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/10/9.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "CompensationViewController.h"
#import "SelectCityViewController.h"
@interface CompensationViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UISegmentedControl *seg;
@property (nonatomic,strong)UIBarButtonItem *barButtonItem;
@property (nonatomic,strong)UIScrollView *scrollView;
@end

@implementation CompensationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.seg];
    [self.view addSubview:self.scrollView];
    [self.tableView removeFromSuperview];
    [self addTableView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = self.barButtonItem;
    // Do any additional setup after loading the view.
}
-(void)addTableView{
    for (int i =0; i<3; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(DeviceSize.width*i, 0, DeviceSize.width, DeviceSize.height-self.seg.bottom) style:UITableViewStyleGrouped];
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        tableView.showsVerticalScrollIndicator =NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
        tableView.tag = i;
        [self.scrollView addSubview:tableView];
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
    vc.city = btn.titleLabel.text;
    [vc setSelectCityBlock:^(NSString *city) {
        [btn setTitle:city forState:UIControlStateNormal];
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
    self.scrollView.contentOffset = CGPointMake(seg.selectedSegmentIndex*DeviceSize.width, 0);
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return tableView.tag+2;
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
    cell.textLabel.text = @"xxx收入";
    cell.textLabel.textColor = [UIColor colorWithHexString:Colorgray];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = @"￥666";
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
    label.text = @"XX标准";
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
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.seg.bottom+10, DeviceSize.width, DeviceSize.height-(self.seg.bottom+10))];
        _scrollView.contentSize = CGSizeMake(3*DeviceSize.width, _scrollView.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.seg.selectedSegmentIndex = scrollView.contentOffset.x/DeviceSize.width;
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

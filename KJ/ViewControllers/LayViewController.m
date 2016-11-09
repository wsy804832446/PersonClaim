//
//  LayViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/9/30.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "LayViewController.h"
#import "SelectCityViewController.h"
#import "ToolTableViewCell.h"
#import "DetailViewController.h"
@interface LayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIBarButtonItem *barButtonItem;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIScrollView *searchScrollView;
//标题名称数组
@property (nonatomic,strong)NSArray *itemsArr;
//选中index
@property (nonatomic,assign)NSInteger selectIndex;
//segment条
@property (nonatomic,strong)UIView *buttonDown;
//标题按钮数组
@property (nonatomic,strong)NSMutableArray *ButtonArray;
//数据数组
@property (nonatomic,strong)NSMutableArray *dataArray;
//展示区
@property (nonatomic,strong)UIScrollView *scrollView;
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
    [self.view addSubview:self.scrollView];
    [self addTableView];
    [self AddSegumentArray:_itemsArr];
    // Do any additional setup after loading the view.
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
-(void)changeTheSegument:(UIButton*)button
{
    [self selectTheSegument:button.tag-1000];
    self.scrollView.contentOffset = CGPointMake((button.tag-1000)*DeviceSize.width, 0);
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
-(void)addTableView{
    for (int i=0; i<self.itemsArr.count; i++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(i*DeviceSize.width,0, self.view.width, DeviceSize.height-_searchScrollView.bottom-10) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.dataSource = self;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsMake(0, 15,0, 15)];
        }
        [self.scrollView addSubview:tableView];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"由于图片宽度是固定的这样就可以计算每行文字缩短的字数。只要文本的总体高度低于图像总高度则文字长度都是缩短的。用CTTypesetterSuggestLineBreak函数动态的计算每一行里的字数，因为每一行里面的中文字、标点符号、数字、字母都不一样所以可以显示的字数肯定也是不同的，所以需要作这样的计算。这样循环直至文本结束，就可以知道有多少行字了。再根据字体高度和行间距得出总的文本高度，如果文本高度大于图片总高度那么显示区域的Frame高度就是文本的高度，反之"];
    cell.Detail.text = str;
    cell.Detail.numberOfLines = 2;
    cell.kind.text = @"xxx法院";
    cell.kind.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.time.text = @"2016-09-18";
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
-(NSString *)title{
    return @"法律法规";
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.searchScrollView.bottom+10, DeviceSize.width, DeviceSize.height-(self.searchScrollView.bottom+10))];
        _scrollView.contentSize = CGSizeMake(self.itemsArr.count*DeviceSize.width, _scrollView.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UIButton *btn = [self.view viewWithTag:scrollView.contentOffset.x/DeviceSize.width+1000];
    [self selectTheSegument:btn.tag-1000];
    self.searchScrollView.contentOffset = CGPointMake(btn.left, 0);
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

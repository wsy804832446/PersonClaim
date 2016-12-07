//
//  ToolViewController.m
//  PersonClaim
//
//  Created by 王晟宇 on 16/9/27.
//  Copyright © 2016年 jingyoutimes. All rights reserved.
//

#import "ToolViewController.h"
#import "ToolCollectionViewCell.h"
#import "ToolTableViewCell.h"
#import "LayViewController.h"
#import "CompensationViewController.h"
#import "DetailViewController.h"
#import "CountViewController.h"
@interface ToolViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UITableView *tableVew;
@end

@implementation ToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableVew];
    // Do any additional setup after loading the view.
}
#pragma collectionView
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = (self.view.width-115*3)/4;
        layout.sectionInset = UIEdgeInsetsMake(15, layout.minimumInteritemSpacing,16, layout.minimumInteritemSpacing);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,10, self.view.width, 115) collectionViewLayout:layout];
        _collectionView.contentSize = CGSizeMake(self.view.width, 115);
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate =self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor =[UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"ToolCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ToolCell"];
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ToolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ToolCell" forIndexPath:indexPath];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ToolCollectionViewCell" owner:nil options:nil];
        if (nib.count>0) {
            cell = nib.lastObject;
        }
    }
    switch (indexPath.row) {
        case 0:
            cell.imgView.image = [UIImage imageNamed:@"切图-全_r1_c1"];
            cell.label.text = @"法律法规";
            break;
        case 1:
            cell.imgView.image = [UIImage imageNamed:@"切图-全_r1_c3"];
            cell.label.text = @"赔偿标准";
            break;
        case 2:
            cell.imgView.image = [UIImage imageNamed:@"切图-全_r1_c5"];
            cell.label.text = @"人伤赔偿预算";
            break;
        default:
            break;
    }
    cell.label.textColor = [UIColor colorWithHexString:@"#666666"];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(115, 84);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.row == 0) {
        LayViewController *vc = [[LayViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 1){
        CompensationViewController *vc = [[CompensationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        CountViewController *vc = [[CountViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
}
#pragma tableVew
-(UITableView *)tableVew{
    if (!_tableVew) {
        _tableVew = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49) style:UITableViewStyleGrouped];
        _tableVew.dataSource =self;
        _tableVew.delegate =self;
        _tableVew.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
        _tableVew.showsVerticalScrollIndicator = NO;
        if ([_tableVew respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableVew setSeparatorInset:UIEdgeInsetsMake(0, 15,0, 15)];
        }
    }
    return _tableVew;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ToolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToolTableViewCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ToolTableViewCell" owner:nil options:nil];
        if (nib.count>0) {
            cell = nib.lastObject;
        }
    }
    [cell.city setTitle:@"北京" forState:UIControlStateNormal];
    [cell.city setTitleColor:[UIColor colorWithHexString:Colorblue]forState:UIControlStateNormal];
    NSMutableString *str = [NSMutableString string];
    for (int i=0; i<4; i++) {
        [str appendFormat:@"  "];
    }
    [str appendFormat:@"由于图片宽度是固定的这样就可以计算每行文字缩短的字数。只要文本的总体高度低于图像总高度则文字长度都是缩短的。用CTTypesetterSuggestLineBreak函数动态的计算每一行里的字数，因为每一行里面的中文字、标点符号、数字、字母都不一样所以可以显示的字数肯定也是不同的，所以需要作这样的计算。这样循环直至文本结束，就可以知道有多少行字了。再根据字体高度和行间距得出总的文本高度，如果文本高度大于图片总高度那么显示区域的Frame高度就是文本的高度，反之"];
    cell.imgView.image = [UIImage imageNamed:@"标签"];
    cell.Detail.text = str;
    cell.Detail.numberOfLines = 2;
    cell.kind.text = @"临床鉴定";
    cell.kind.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.city.layer.masksToBounds =YES;
    cell.city.layer.borderColor =[UIColor colorWithHexString:Colorblue].CGColor;
    cell.city.layer.borderWidth = 1;
    cell.time.text = @"2016-09-18";
    cell.time.textColor = [UIColor colorWithHexString:@"#666666"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 125;
    }else{
        return 39;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setHidesBottomBarWhenPushed:YES];
    DetailViewController *vc = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 125)];
        vc.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
        [vc addSubview:self.collectionView];
        return vc;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,39)];
        view.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 19.5/2, 3, 19.5)];
        [line setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
        [view addSubview:line];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(line.right+5, line.top, 0, line.height)];
        label.text = @"最新推荐";
        label.frame = CGRectMake(line.right+5, line.top, 17.5*label.text.length, line.height);
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        return view;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==0) {
        return 10;
    }else{
        return 0.1;
    }
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

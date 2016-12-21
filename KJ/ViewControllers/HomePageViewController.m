//
//  HomePageViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/28.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "HomePageViewController.h"
#import "FollowPlatFormViewController.h"
#import "HomeCollectionViewCell.h"
#import "ClaimModel.h"
#import "AllViewController.h"
@interface HomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation HomePageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTask];
    [self.view addSubview:self.imgView];
    [self.view sendSubviewToBack:self.imgView];
    [self drawView];
    [self.view addSubview:self.collectionView];
    // Do any additional setup after loading the view.
}
-(void)getTask{
//    NSArray *localClaimArray = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"cliam%@",@"000111"]];
    //    if (localClaimArray.count>0) {
    //        [self.dataArray removeAllObjects];
    //        [self.dataArray addObjectsFromArray:localClaimArray];
    //    }
    WeakSelf(HomePageViewController);
    [self showHudWaitingView:WaitPrompt];
    [[NetWorkManager shareNetWork]getTaskWithUserId:[CommUtil readDataWithFileName:@"account"] andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if ([response.responseCode isEqual:@"1"]) {
            NSArray *claimArray = response.dataDic[@"claimList"];
            for (NSDictionary *claimDic in claimArray) {
                ClaimModel *model = [MTLJSONAdapter modelOfClass:[ClaimModel class] fromJSONDictionary:claimDic error:NULL];
                [weakSelf.dataArray addObject:model];
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [CommUtil saveData:[NSArray arrayWithArray:weakSelf.dataArray] andSaveFileName:[NSString stringWithFormat:@"cliam%@",[CommUtil readDataWithFileName:@"account"]]];
            });
        }else{
            [weakSelf showHudAuto:response.message];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf removeMBProgressHudInManaual];
        [weakSelf showHudAuto:InternetFailerPrompt];
    }];
}

-(void)drawView{
    UIBezierPath *bezier =[UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:80 startAngle:M_PI_2 endAngle: M_PI_2+M_PI*2 clockwise:YES];
    CAShapeLayer *shape = [[CAShapeLayer alloc]init];
    shape.fillColor = [UIColor clearColor].CGColor;;
    shape.position = CGPointMake(self.imgView.center.x, self.imgView.center.y+80);
    shape.strokeStart = 0.f;
    shape.strokeEnd = 0.5f;
    shape.lineWidth = 25;
    shape.strokeColor = [UIColor colorWithHexString:@"#00ffff"].CGColor;
    shape.path = bezier.CGPath;
    [self.imgView.layer addSublayer:shape];
    CAShapeLayer *shape2 = [[CAShapeLayer alloc]init];
    shape2.fillColor = [UIColor clearColor].CGColor;;
    shape2.position = CGPointMake(self.imgView.center.x+6, self.imgView.center.y+80) ;
    shape2.strokeStart = 0.5f;
    shape2.strokeEnd = 0.75f;
    shape2.lineWidth = 25;
    shape2.strokeColor = [UIColor colorWithHexString:@"#ff3e00"].CGColor;
    shape2.path = bezier.CGPath;
    [self.imgView.layer addSublayer:shape2];
    CAShapeLayer *shape3 = [[CAShapeLayer alloc]init];
    shape3.fillColor = [UIColor clearColor].CGColor;;
    shape3.position = CGPointMake(self.imgView.center.x+6, self.imgView.center.y+80);
    shape3.strokeStart = 0.75f;
    shape3.strokeEnd = 1;
    shape3.lineWidth = 25;
    shape3.strokeColor = [UIColor colorWithHexString:@"#f2f200"].CGColor;
    shape3.path = bezier.CGPath;
    [self.imgView.layer addSublayer:shape3];

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HomeCollectionViewCell" owner:nil options:nil];
        if (nib.count>0) {
            cell = [nib firstObject];
        }
    }
    [cell configCellWithRow:indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AllViewController *vc =[[AllViewController alloc]init];
    vc.claimType = indexPath.row;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell =(HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell =(HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:Colorwhite];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        NSInteger height =DeviceSize.height-49-self.imgView.height-20;
        // 设置间距
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(DeviceSize.width/3,height/3);
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, self.imgView.bottom+10, DeviceSize.width,height)collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.contentSize = CGSizeMake(DeviceSize.width, height);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor =[UIColor colorWithHexString:Colorwhite];
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCell"];
    }
    return _collectionView;
}
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -64, DeviceSize.width, 306*DeviceSize.width/375)];
        [_imgView setImage:[UIImage imageNamed:@"home img"]];
    }
    return _imgView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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

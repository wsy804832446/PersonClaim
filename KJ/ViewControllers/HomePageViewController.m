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
@interface HomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view addSubview:self.imgView];
    [self drawView];
    [self.view addSubview:self.collectionView];
    // Do any additional setup after loading the view.
}
-(void)drawView{
    UIBezierPath *bezier =[UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 0) radius:80 startAngle:M_PI_2 endAngle: M_PI_2+M_PI*2 clockwise:YES];
    CAShapeLayer *shape = [[CAShapeLayer alloc]init];
    shape.fillColor = [UIColor clearColor].CGColor;;
    shape.position = self.imgView.center;
    shape.strokeStart = 0.f;
    shape.strokeEnd = 0.5f;
    shape.lineWidth = 25;
    shape.strokeColor = [UIColor colorWithHexString:@"#00ffff"].CGColor;
    shape.path = bezier.CGPath;
    [self.imgView.layer addSublayer:shape];
    CAShapeLayer *shape2 = [[CAShapeLayer alloc]init];
    shape2.fillColor = [UIColor clearColor].CGColor;;
    shape2.position = CGPointMake(self.imgView.center.x+6, self.imgView.center.y) ;
    shape2.strokeStart = 0.5f;
    shape2.strokeEnd = 0.75f;
    shape2.lineWidth = 25;
    shape2.strokeColor = [UIColor colorWithHexString:@"#ff3e00"].CGColor;
    shape2.path = bezier.CGPath;
    [self.imgView.layer addSublayer:shape2];
    CAShapeLayer *shape3 = [[CAShapeLayer alloc]init];
    shape3.fillColor = [UIColor clearColor].CGColor;;
    shape3.position = CGPointMake(self.imgView.center.x+6, self.imgView.center.y);
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
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375, 306)];
        [_imgView setImage:[UIImage imageNamed:@"home img"]];
    }
    return _imgView;
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

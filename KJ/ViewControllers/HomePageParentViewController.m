//
//  HomePageParentViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/30.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "HomePageParentViewController.h"
#import "HomePageViewController.h"
#import "FollowPlatFormViewController.h"
#import "NewTsakViewController.h"
@interface HomePageParentViewController ()
@property (nonatomic,strong)UISegmentedControl *segMent;
@property (nonatomic,strong)HomePageViewController *firstvc;
@property (nonatomic,strong)FollowPlatFormViewController *secondVc;
@property (nonatomic,strong)UIViewController *currentVc;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIScrollView *scrollView;
@end

@implementation HomePageParentViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imgView];
    self.firstvc = [[HomePageViewController alloc]init];
    self.firstvc.view.frame = CGRectMake(0, 64, DeviceSize.width, DeviceSize.height);
    [self addChildViewController:self.firstvc];
    self.secondVc = [[FollowPlatFormViewController alloc]init];
    self.secondVc.view.frame = CGRectMake(0, 64, DeviceSize.width, DeviceSize.height);
    self.currentVc = self.firstvc;
    [self.scrollView addSubview:self.firstvc.view];
    [self.view addSubview:self.segMent];
    [self addBarbutton];
    // Do any additional setup after loading the view.
}

-(void)addBarbutton{
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(20, 30, 24, 22);
    [btnLeft setImage:[UIImage imageNamed:@"22-消息(1)"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"22-消息-1(1)"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    btnLeft.tag = 8888;
    [self.view addSubview:btnLeft];
}
-(void)addRightBtn{
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(self.view.right-20-24, 30, 24, 22);
    [btnRight setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
    btnRight.tag = 9999;
    [btnRight addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRight];
}
-(void)leftAction{
    NewTsakViewController *vc = [[NewTsakViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)rightAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"select" object:nil];
}
-(UISegmentedControl *)segMent{
    if (!_segMent) {
        _segMent = [[UISegmentedControl alloc]initWithItems:@[@"统计视图",@"周任务"]];
        _segMent.frame =CGRectMake((DeviceSize.width-220)/2, 25, 220, 29);
        _segMent.backgroundColor = [UIColor clearColor];
        _segMent.tintColor = [UIColor colorWithHexString:Colorwhite alpha:0.26];
        _segMent.selectedSegmentIndex = 0;
        [_segMent addTarget:self action:@selector(segChange:) forControlEvents:UIControlEventValueChanged];
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName: [UIColor colorWithHexString:Colorwhite]};
        [_segMent setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        [_segMent setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
    }
    return _segMent;
}
-(void)segChange:(UISegmentedControl*)seg{
    if (seg.selectedSegmentIndex ==0) {
        [self addChildViewController:self.firstvc];
        [self transitionFromViewController:self.currentVc toViewController:self.firstvc duration:0 options:0 animations:nil completion:^(BOOL finished) {
            if (finished) {
                UIButton *btnLeft = [self.view viewWithTag:8888];
                UIButton *btnRight = [self.view viewWithTag:9999];
                if (btnRight) {
                    [btnRight removeFromSuperview];
                }
                self.scrollView.scrollEnabled = YES;
                [self.view bringSubviewToFront:btnLeft];
                [self.view bringSubviewToFront:self.segMent];
                [self.firstvc didMoveToParentViewController:self];
                [self.currentVc willMoveToParentViewController:nil];
                [self.currentVc removeFromParentViewController];
                self.currentVc = self.firstvc;
            }
        }];
    }else{
        [self addChildViewController:self.secondVc];
        [self transitionFromViewController:self.currentVc toViewController:self.secondVc duration:0 options:0 animations:nil completion:^(BOOL finished) {
            if (finished) {
                UIButton *btnLeft = [self.view viewWithTag:8888];
                UIButton *btnRight = [self.view viewWithTag:9999];
                if (!btnRight) {
                    [self addRightBtn];
                }
                [self.view bringSubviewToFront:btnLeft];
                [self.view bringSubviewToFront:self.segMent];
                self.scrollView.scrollEnabled = NO;
                [self.secondVc didMoveToParentViewController:self];
                [self.currentVc willMoveToParentViewController:nil];
                [self.currentVc removeFromParentViewController];
                self.currentVc = self.secondVc;
            }
        }];
    }
}
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 306*DeviceSize.width/375)];
        [_imgView setImage:[UIImage imageNamed:@"home img"]];
    }
    return _imgView;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, DeviceSize.width, DeviceSize.height-49+20)];
        _scrollView.contentSize = CGSizeMake(DeviceSize.width, DeviceSize.height-49-64+20);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
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

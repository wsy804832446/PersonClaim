//
//  ShowPictureViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/4.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "ShowPictureViewController.h"

@interface ShowPictureViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView *scrollView;
@end

@implementation ShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"删除"];
    // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, DeviceSize.height)];
        _scrollView.contentSize = CGSizeMake(DeviceSize.width*self.pictureArray.count, DeviceSize.height);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor colorWithHexString:Colorblack];
        _scrollView.delegate =self;
        _scrollView.contentOffset = CGPointMake(DeviceSize.width *self.selectIndex,0);
        for (int i=0; i<self.pictureArray.count; i++) {
            UIImage *img = self.pictureArray[i];
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*DeviceSize.width,(DeviceSize.height-img.size.height*DeviceSize.width/img.size.width-64)/2, DeviceSize.width,img.size.height*DeviceSize.width/img.size.width)];
            imgView.image = img;
            imgView.tag = 1000+i;
            [_scrollView addSubview:imgView];
        }
    }
    return _scrollView;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.title = [NSString stringWithFormat:@"%.f/%ld",self.scrollView.contentOffset.x/DeviceSize.width+1,self.pictureArray.count];
}
-(NSMutableArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}
-(NSString *)title{
    return [NSString stringWithFormat:@"%ld/%ld",self.selectIndex+1,self.pictureArray.count];
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

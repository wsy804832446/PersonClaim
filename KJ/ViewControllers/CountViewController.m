//
//  CountViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/29.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "CountViewController.h"

@interface CountViewController ()

@end

@implementation CountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"10-空白页_r2_c2"]];
    img.frame = self.view.frame;
    [self.view addSubview:img];
    // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)title{
    return @"人伤赔偿预算";
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

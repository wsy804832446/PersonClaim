//
//  SelectWayViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/16.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "SelectWayViewController.h"
#import "MedicalVisitViewController.h"
@interface SelectWayViewController ()

@end

@implementation SelectWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.tableView.top = 10;
    self.tableView.height = DeviceSize.height-64-10;
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row ==0) {
        cell.textLabel.text = @"保守治疗";
    }else{
        cell.textLabel.text = @"手术治疗";
    }
    return cell;
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.diagnoseDetailModel.way = cell.textLabel.text;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Diagnose" object:nil userInfo:[MTLJSONAdapter JSONDictionaryFromModel:self.diagnoseDetailModel]];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MedicalVisitViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
-(NSString *)title{
    return @"选择治疗方式";
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

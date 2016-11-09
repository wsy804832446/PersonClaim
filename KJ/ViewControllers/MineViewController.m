//
//  MineViewController.m
//  PersonClaim
//
//  Created by 王晟宇 on 16/9/27.
//  Copyright © 2016年 jingyoutimes. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "MineTableViewCell2.h"
#import "PersonalInformationViewController.h"
#import "FeedbackViewController.h"
@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:Colorblue]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:Colorwhite],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName,nil]];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15,0, 15)];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else {
        return 3;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
        if (!cell) {
           NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MineTableViewCell" owner:self options:nil];
            if (nib.count>0) {
                cell = nib.firstObject;
            }
        }
        cell.name.text= @"张韶涵";
        cell.phone.text = @"15601136940";
        cell.name.textColor = [UIColor colorWithHexString:Colorblack];
        cell.phone.textColor = [UIColor colorWithHexString:Colorgray];
        [cell.imgLeft setImage:[UIImage imageNamed:@"3-医疗理赔系统APP端-我的_r3_c2"]];
        cell.imgRight.image = [UIImage imageNamed:@"箭头"];
        return cell;
    }else{
        MineTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell2"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MineTableViewCell2" owner:self options:nil];
            if (nib.count>0) {
                cell = nib.firstObject;
            }
        }
        cell.imgRight.image = [UIImage imageNamed:@"箭头"];
        cell.labelLeft.textColor = [UIColor colorWithHexString:Colorblack];
        cell.labelRight.textColor = [UIColor colorWithHexString:Colorgray];
        if (indexPath.row == 0 && indexPath.section == 1) {
            cell.labelLeft.text = @"收藏";
            cell.imgLeft.image = [UIImage imageNamed:@"未命名-1_r1_c1"];
        }else if (indexPath.row == 0 && indexPath.section == 2) {
            cell.labelLeft.text = @"清理缓存";
            cell.labelRight.text = @"13.9M";
            cell.imgLeft.image = [UIImage imageNamed:@"未命名-1_r1_c3"];
        }else if(indexPath.row == 1){
            cell.labelLeft.text = @"版本更新";
            cell.imgLeft.image = [UIImage imageNamed:@"未命名-1_r1_c5"];
            cell.labelRight.text = @"最新版本";
        }else{
            cell.labelLeft.text = @"意见反馈";
            cell.imgLeft.image = [UIImage imageNamed:@"未命名-1_r2_c7"];
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 65;
    }else{
        return 44;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.section == 0) {
        PersonalInformationViewController *vc = [[PersonalInformationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section == 2 && indexPath.row == 2){
        FeedbackViewController *vc = [[FeedbackViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    return view;
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

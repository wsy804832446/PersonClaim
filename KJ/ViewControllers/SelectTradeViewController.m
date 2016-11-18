//
//  SelectTradeViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/18.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "SelectTradeViewController.h"

@interface SelectTradeViewController ()

@end

@implementation SelectTradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.top = 10;
    self.tableView.height = DeviceSize.height-74;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    NSArray *seletListArray = [CommUtil readDataWithFileName:localSelectArry];
    if (seletListArray.count >0) {
        for (SelectList *model in seletListArray) {
            if ([model.typeCode isEqual:@"D110"]) {
                [self.dataArray addObject:model];
            }
        }
    }
    
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    SelectList *model = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text =model.value;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectList *model = self.dataArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.SelectIdentityBlock) {
        self.SelectIdentityBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)title{
    return @"选择行业";
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

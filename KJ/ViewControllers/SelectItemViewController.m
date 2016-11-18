//
//  SelectItemViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/18.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "SelectItemViewController.h"
#import "DefaultCellTableViewCell.h"
@interface SelectItemViewController ()

@end

@implementation SelectItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.top = 10;
    self.tableView.height = DeviceSize.height-74;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    // Do any additional setup after loading the view.
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DefaultCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCellTableViewCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DefaultCellTableViewCell" owner:nil options:nil];
        if (nib.count>0) {
            cell = nib.firstObject;
        }
    }
    if (indexPath.row == 0) {
        cell.line.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    }

    cell.textLabel.font = [UIFont systemFontOfSize:15];
    ItemTypeModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectItemBlock) {
        self.selectItemBlock(self.dataArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)title{
    return self.itemName;
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

//
//  SelectDepartmentViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/11.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "SelectDepartmentViewController.h"
#import "SelectCityTableViewCell.h"
#import "DepartmentsModel.h"
#import "MedicalVisitViewController.h"
@interface SelectDepartmentViewController ()
//选择的诊断array
@property (nonatomic,strong)NSMutableArray *selectArray;
@end

@implementation SelectDepartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem =[UIBarButtonItemExtension rightButtonItem:@selector(rightAction:) andTarget:self andTitleName:@"确定"];
    // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction:(UIButton *)btn{
    if (self.selectBlock) {
        self.selectBlock(self.hospitalModel,self.selectArray);
    }
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[MedicalVisitViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCityTableViewCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SelectCityTableViewCell" owner:nil options:nil];
        if (nib.count>0) {
            cell = [nib firstObject];
        }
    }
    DepartmentsModel *model = self.dataArray[indexPath.row];
    if (model.isSelected) {
        cell.imgView.image = [UIImage imageNamed:@"切图-全_r21_c17"];
    }else{
        cell.imgView.image =nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cityLabel.text =model.value;
    cell.cityLabel.textColor = [UIColor colorWithHexString:Colorblack];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectCityTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DepartmentsModel *model = self.dataArray[indexPath.row];
    if (cell.imgView.image) {
        cell.imgView.image = nil;
        model.isSelected = NO;
        [self.selectArray removeObject:model];
    }else{
        cell.imgView.image = [UIImage imageNamed:@"切图-全_r21_c17"];
        model.isSelected = YES;
        [self.selectArray addObject:model];
    }
    [self reloadRightButtonTitle];
}
-(void)reloadRightButtonTitle{
    if (self.selectArray.count>0) {
        self.navigationItem.rightBarButtonItem =[UIBarButtonItemExtension rightButtonItem:@selector(rightAction:) andTarget:self andTitleName:[NSString stringWithFormat:@"确定(%ld)",self.selectArray.count]];
    }else{
        self.navigationItem.rightBarButtonItem =[UIBarButtonItemExtension rightButtonItem:@selector(rightAction:) andTarget:self andTitleName:@"确定"];
    }
}
-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
-(NSString *)title{
    return @"选择科室";
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

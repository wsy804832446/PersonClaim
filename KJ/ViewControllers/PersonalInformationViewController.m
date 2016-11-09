//
//  PersonalInformationViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/9/28.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.


#import "PersonalInformationViewController.h"
#import "PersonalInformationTableViewCell.h"
#import "PersonalInformationTableViewCell2.h"
#import "PersonalInformationTableViewCell3.h"
#import "NameEditViewController.h"
#import "PhoneEditViewController.h"
@interface PersonalInformationViewController ()
@property (nonatomic,strong)UIButton *exitBtn;
//选择生日
@property (nonatomic,strong)UIView *containerView;
@property (nonatomic,strong)UIDatePicker *pickView;
@property (nonatomic,strong)NSDateFormatter *formatter;
@end

@implementation PersonalInformationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView addSubview:self.exitBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15,0, 15)];
    }
    // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return 4;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PersonalInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInformationCell"];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PersonalInformationTableViewCell" owner:self options:nil];
                if (nib.count > 0) {
                    cell = nib.firstObject;
                }
            }
            cell.label.text = @"头像";
            cell.label.textColor = [UIColor colorWithHexString:Colorblack];
            cell.imgLeft.image = [UIImage imageNamed:@"3-医疗理赔系统APP端-我的_r3_c2"];
            cell.imgRight.image = [UIImage imageNamed:@"箭头"];
            return cell;
        }else{
            PersonalInformationTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInformationCell2"];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PersonalInformationTableViewCell2" owner:self options:nil];
                if (nib.count > 0) {
                    cell = nib.firstObject;
                }
                
            }
            switch (indexPath.row) {
                case 1:
                    cell.labelLeft.text = @"姓名";
                    break;
                case 2:
                    cell.labelLeft.text = @"出生日期";
                    break;
                case 3:
                    cell.labelLeft.text = @"手机号";
                    break;
                case 4:
                    cell.labelLeft.text = @"密码";
                    break;
                default:
                    break;
            }
            cell.img.image = [UIImage imageNamed:@"箭头"];
            cell.labelLeft.textColor = [UIColor colorWithHexString:Colorblack];
            cell.labelRight.text = @"123456789";
            cell.labelRight.textColor = [UIColor colorWithHexString:Colorgray];
            return cell;
        }
  
    }else{
        PersonalInformationTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInformationCell3"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PersonalInformationTableViewCell3" owner:self options:nil];
            if (nib.count > 0) {
                cell = nib.firstObject;
            }
        }
        switch (indexPath.row) {
            case 0:
                cell.labelLeft.text = @"工号";
                break;
            case 1:
                cell.labelLeft.text = @"机构";
                break;
            case 2:
                cell.labelLeft.text = @"岗位";
                break;
            case 3:
                cell.labelLeft.text = @"等级";
                break;
            default:
                break;
        }
        cell.labelLeft.textColor = [UIColor colorWithHexString:Colorblack];
        cell.labelRight.text = @"%@%@%@%@%@%@%@";
        cell.labelRight.textColor = [UIColor colorWithHexString:Colorgray];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            NameEditViewController *vc = [[NameEditViewController alloc]init];
            vc.pageTitle = 0;
            [vc setBlock:^(NSString *name) {
                NSIndexPath *path =[NSIndexPath indexPathForRow:1 inSection:0];
                PersonalInformationTableViewCell2 *cell = [tableView cellForRowAtIndexPath:path];
                cell.labelRight.text = name;
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 2){
            self.tableView.userInteractionEnabled = NO;
            [self.view addSubview:self.containerView];
            [UIView animateWithDuration:0.5 animations:^{
                _containerView.frame = CGRectMake(0, self.view.bottom - 176-64, DeviceSize.width, 176);
            }];
        }else if(indexPath.row == 3){
            PhoneEditViewController *vc = [[PhoneEditViewController alloc]init];
            NSIndexPath *path =[NSIndexPath indexPathForRow:3 inSection:0];
            PersonalInformationTableViewCell2 *cell = [tableView cellForRowAtIndexPath:path];
            vc.phoneNum =cell.labelRight.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 4){
            NameEditViewController *vc = [[NameEditViewController alloc]init];
            vc.pageTitle = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    return view;
}
-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitBtn.frame = CGRectMake(25, self.view.bottom-80-44.5-64, self.view.width-50, 44.5);
        _exitBtn.layer.masksToBounds = YES;
        _exitBtn.layer.cornerRadius = 44*0.16;
        [_exitBtn setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
        [_exitBtn setTitleColor:[UIColor colorWithHexString:Colorwhite]forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(exit:)
      forControlEvents:UIControlEventTouchUpInside];
        [_exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    return _exitBtn;
}

-(void)exit:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIDatePicker *)pickView{
    if (!_pickView) {
        _pickView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, DeviceSize.width,132)];
        _pickView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [_pickView setDate:[NSDate date] animated:YES];
        [_pickView setMaximumDate:[NSDate date]];
        [_pickView setDatePickerMode:UIDatePickerModeDate];
        [_pickView setMinimumDate:[self.formatter dateFromString:@"1950-01-01日"]];
        _pickView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    }
    return _pickView;
}
- (void)doneAction:(UIButton *)btn {
    PersonalInformationTableViewCell2 *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.labelRight.text = [_formatter stringFromDate:_pickView.date];
    [self cancelAction:nil];
}
- (void)cancelAction:(UIButton *)btn {
    self.tableView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _containerView.frame = CGRectMake(0, self.view.bottom, DeviceSize.width, 176);
    }];
    [UIView setAnimationDidStopSelector:@selector(removePick)];
}
-(void)removePick{
    [_containerView removeFromSuperview];
}

#pragma mark - setter、getter
- (void)setSelectDate:(NSString *)selectDate {
    [_pickView setDate:[self.formatter dateFromString:selectDate] animated:YES];
}
-(NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter =[[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}
-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bottom, DeviceSize.width, 176)];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [_containerView addSubview:self.pickView];
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame =CGRectMake(20,12,40,20);
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor colorWithHexString:Colorblack] forState:UIControlStateNormal];
        [btnCancel setBackgroundColor:[UIColor colorWithHexString:@"#efefef"]];
        [btnCancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:btnCancel];
        UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDone.frame = CGRectMake(self.view.width-20-btnCancel.size.width, btnCancel.top,btnCancel.size.width, btnCancel.size.height);
        [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnDone setTitle:@"确定" forState:UIControlStateNormal];
        btnDone.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [btnDone addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:btnDone];
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(DeviceSize.width/2-40, 12, 80, 20)];
        lblTitle.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        lblTitle.textColor = [UIColor colorWithHexString:Colorblack];
        lblTitle.text = @"选择时间";
        lblTitle.font = [UIFont systemFontOfSize:17];
        [_containerView addSubview:lblTitle];
    }
    return _containerView;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelAction:nil];
}
-(NSString *)title{
    return @"个人资料";
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

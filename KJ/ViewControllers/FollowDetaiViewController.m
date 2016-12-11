//
//  FollowDetaiViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/10/17.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "FollowDetaiViewController.h"
#import "FollowDetailTableViewCell.h"
#import "EditInfoViewController.h"
#import "EditInfoModel.h"
#import "EditDealInfoViewController.h"
#import "MedicalVisitViewController.h"
#import "IncomeViewController.h"
#import "FamilyRegisterViewController.h"
#import "DeathInfoViewController.h"
#import "DelayViewController.h"
#import "UpbringViewController.h"
#import "DisabilityViewController.h"
#import "ShowDetailLabelTableViewCell.h"
@interface FollowDetaiViewController ()<UIScrollViewDelegate>
//编辑按钮
@property (nonatomic,strong)UIButton *btnEdit;
//提交按钮
@property (nonatomic,strong)UIButton *btnCommit;
//记录资料切换seg
@property (nonatomic,strong)UISegmentedControl *seg;
@property (nonatomic,strong) UIView *buttonDown;
@property (nonatomic,assign)NSInteger selectIndex;
//事故详情编辑后返回的信息
@property (nonatomic,strong)EditInfoModel *infoModel;
@end

@implementation FollowDetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoModel =[CommUtil readDataWithFileName:[NSString stringWithFormat:@"%@%@",self.taskModel.taskNo,self.taskModel.taskType]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tableView.height = DeviceSize.height - self.tableView.top-54-64;
    self.tableView.estimatedRowHeight = 102;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //初始化segment选项为0
    self.selectIndex = 0;
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.bottom, DeviceSize.width, 54)];
    bottomView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    //超时时间
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 54)];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d天后超时",3]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(0, attStr.length-4)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffc106"] range:NSMakeRange(0, attStr.length-4)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(attStr.length-4, 4)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:Colorgray] range:NSMakeRange(attStr.length-4, 4)];
    lblTime.attributedText =attStr;
    lblTime.frame = CGRectMake(25, 0, lblTime.text.length*22, bottomView.height);
    [bottomView addSubview:lblTime];
    [bottomView addSubview:self.btnCommit];
    [self.view addSubview:self.btnEdit];
    [self.view addSubview:bottomView];
       // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.selectIndex ==1) {
        return 2;
    }else{
        if ([self.taskModel.taskType isEqual:@"01"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"02"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"03"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"04"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"05"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"06"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"07"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"09"]) {
            return 2;
        }else if ([self.taskModel.taskType isEqual:@"10"]){
            return 1;
        }
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectIndex == 1) {
        if (section == 0) {
            return 1;
        }else{
            return 10;
        }
    }else{
        if ([self.taskModel.taskType isEqual:@"01"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"02"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"03"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"04"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"05"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"06"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"07"]){
            return 1;
        }else if ([self.taskModel.taskType isEqual:@"09"]) {
            if(section ==0){
                return 1;
            }else if (section ==1){
                return 3;
            }else if (section ==2){
                //            return self.infoModel.contactPersonArray.count;
            }else if (section ==3){
                //            return 1;
            }
        }else if ([self.taskModel.taskType isEqual:@"10"]){
            return 1;
        }
         return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0 && indexPath.row ==0) {
        FollowDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowDetailCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"FollowDetailTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        cell.lblType.text = self.taskTypeName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:self.claimModel];
        [cell setCallBlock:^{
            [self alertTell];
        }];
        cell.lblTime.text =self.taskModel.dispatchDate;
        return cell;
    }
    if (self.selectIndex == 0) {
        if ([self.taskModel.taskType isEqual:@"01"]){
            return nil;
        }else if ([self.taskModel.taskType isEqual:@"02"]){
            return nil;
        }else if ([self.taskModel.taskType isEqual:@"03"]){
            return nil;
        }else if ([self.taskModel.taskType isEqual:@"04"]){
            return nil;
        }else if ([self.taskModel.taskType isEqual:@"05"]){
            return nil;
        }else if ([self.taskModel.taskType isEqual:@"06"]){
            return nil;
        }else if ([self.taskModel.taskType isEqual:@"07"]){
            return nil;
        }else if ([self.taskModel.taskType isEqual:@"09"]) {
            if(indexPath.section ==1){
                ShowDetailLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShowLabelCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ShowDetailLabelTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lblShowDetail.textColor = [UIColor colorWithHexString:Colorblack];
                if (indexPath.row ==0) {
                    [cell configCellWithString:self.infoModel.address];
                    if (self.infoModel.address.length ==0) {
                        cell.hidden = YES;
                    }
                }else if (indexPath.row ==1){
                    [cell configCellWithString:[NSString stringWithFormat:@"事故时间:%@ ",self.infoModel.accidentDate]];
                    if (self.infoModel.accidentDate.length ==0) {
                        cell.hidden = YES;
                    }
                }else if (indexPath.row ==3){
                    [cell configCellWithString:self.infoModel.detailInfo];
                    if (self.infoModel.detailInfo.length ==0) {
                        cell.hidden = YES;
                    }
                }
                return cell;
            }
        }else if ([self.taskModel.taskType isEqual:@"10"]){
            return nil;
        }
        return nil;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        }
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:Colorblack];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row ==0) {
            cell.textLabel.text = @"损伤类型";
            cell.detailTextLabel.text = @"";
        }else if (indexPath.row ==1){
            cell.textLabel.text = @"报案号";
            cell.detailTextLabel.text = self.claimModel.reportNo;
        }else if (indexPath.row ==2){
            cell.textLabel.text = @"估损单号";
            cell.detailTextLabel.text = @"";
        }else if (indexPath.row ==3){
            cell.textLabel.text = @"车牌号";
            cell.detailTextLabel.text = self.claimModel.plateNo;
        }else if (indexPath.row ==4){
            cell.textLabel.text = @"出险时间";
            cell.detailTextLabel.text = self.claimModel.dangerDate;
        }else if (indexPath.row ==5){
            cell.textLabel.text = @"报案时间";
            cell.detailTextLabel.text = self.claimModel.reportDate;
        }else if (indexPath.row ==6){
            cell.textLabel.text = @"被保险人";
            cell.detailTextLabel.text = self.claimModel.insuredName;
        }else if (indexPath.row ==7){
            cell.textLabel.text = @"交强险保单号";
            cell.detailTextLabel.text = self.claimModel.fPolicyNo;
        }else if (indexPath.row ==8){
            cell.textLabel.text = @"商业保单号";
            cell.detailTextLabel.text = self.claimModel.bPolicyNo;
        }else {
            cell.textLabel.text = @"是否异地";
            cell.detailTextLabel.text = @"";
        }
        cell.userInteractionEnabled = NO;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 0, DeviceSize.width-30, 1)];
        line.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
        [cell.contentView addSubview:line];
        return cell;
    }
}
-(void)alertTell{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.claimModel.insuredName message:self.claimModel.mobilePhone preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *call = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.claimModel.mobilePhone]]];
    }];
    [alert addAction:cancel];
    [alert addAction:call];
    [self presentViewController:alert animated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0.5;
    }else{
        if (_seg.selectedSegmentIndex == 0) {
            return 39;
        }else{
            return 0.01;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view ;
    if (section == 0) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width,0.5)];
        view.backgroundColor = [UIColor colorWithHexString:Colorwhite alpha:0.26 ];
    }else{
        if(self.selectIndex ==1){
            return nil;
        }
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,39)];
        view.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 19.5/2, 3, 19.5)];
        [line setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
        [view addSubview:line];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(line.right+5, line.top, 0, line.height)];
        if ([self.taskModel.taskType isEqual:@"01"]){
            
        }else if ([self.taskModel.taskType isEqual:@"02"]){
            
        }else if ([self.taskModel.taskType isEqual:@"03"]){
            
        }else if ([self.taskModel.taskType isEqual:@"04"]){
            
        }else if ([self.taskModel.taskType isEqual:@"05"]){
            
        }else if ([self.taskModel.taskType isEqual:@"06"]){
            
        }else if ([self.taskModel.taskType isEqual:@"07"]){
            
        }else if ([self.taskModel.taskType isEqual:@"09"]) {
            if (section ==1) {
                label.text = @"事故地址信息";
            }else if (section ==2){
                label.text = @"联系人";
            }else if (section ==3){
                label.text = @"影像资料";
            }else if (section ==4){
                label.text = @"其他信息";
            }
        }else if ([self.taskModel.taskType isEqual:@"10"]){
            
        }
        label.frame = CGRectMake(line.right+5, line.top, 17.5*label.text.length, line.height);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHexString:Colorblue];
        [view addSubview:label];
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 49;
    }else{
        return 10;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 49)];
        vc.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
        //加入segment
        _seg = [[UISegmentedControl alloc]initWithItems:@[@"跟踪记录",@"详细资料"]];
        _seg.frame =CGRectMake(0,0, DeviceSize.width, 36);
        _seg.selectedSegmentIndex = self.selectIndex;
        _seg.tintColor = [UIColor clearColor];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,[UIColor colorWithHexString:Colorgray], NSForegroundColorAttributeName,nil];
        [_seg setTitleTextAttributes:attributes forState:UIControlStateNormal];
        NSDictionary *attributesSlect = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,[UIColor colorWithHexString:Colorblue], NSForegroundColorAttributeName,nil];
        [_seg setTitleTextAttributes:attributesSlect forState:UIControlStateSelected];
        [_seg addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
        _seg.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        [vc addSubview:self.buttonDown];
        [vc addSubview:_seg];
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, _buttonDown.bottom, DeviceSize.width, 10)];
        bottomLine.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
        [vc addSubview:bottomLine];
        return vc;
    }else{
        return nil;
    }
}
-(void)edit{
    [self setHidesBottomBarWhenPushed:YES];
    if ([self.taskModel.taskType isEqual:@"01"]){
        MedicalVisitViewController *vc = [[MedicalVisitViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [vc setSaveInfoBlock:^(EditInfoModel *model) {
            self.infoModel = model;
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"02"]){
        IncomeViewController *vc = [[IncomeViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"03"]){
        DelayViewController *vc = [[DelayViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"04"]){
        FamilyRegisterViewController *vc = [[FamilyRegisterViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"05"]){
        UpbringViewController *vc = [[UpbringViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"06"]){
        DeathInfoViewController *vc = [[DeathInfoViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"08"]){
        DisabilityViewController *vc = [[DisabilityViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [self.navigationController pushViewController:vc animated:YES];
    } if ([self.taskModel.taskType isEqual:@"09"]) {
        EditInfoViewController *vc = [[EditInfoViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [vc setSaveInfoBlock:^(EditInfoModel *infoModel) {
            self.infoModel = infoModel;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"10"]){
        EditDealInfoViewController *vc = [[EditDealInfoViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)changeSeg:(UISegmentedControl *)seg{
    self.selectIndex = seg.selectedSegmentIndex;
    [UIView animateWithDuration:0.5 animations:^{
        self.buttonDown.frame = CGRectMake(DeviceSize.width/2*self.selectIndex, self.seg.bottom, DeviceSize.width/2, 3) ;
    }];
    [self.tableView reloadData];
}
-(UIButton *)btnCommit{
    if (!_btnCommit) {
        _btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCommit.frame = CGRectMake(DeviceSize.width-29/2-165,7, 165, 40);
        [_btnCommit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        [_btnCommit setTitle:@"提交" forState:UIControlStateNormal];
        [_btnCommit setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
        [_btnCommit setTitleColor:[UIColor colorWithHexString:@"#6ca6f2"] forState:UIControlStateHighlighted];
        [_btnCommit setBackgroundColor:[UIColor colorWithHexString:@"#00c632"]];
        _btnCommit.layer.masksToBounds = YES;
        _btnCommit.layer.cornerRadius = 40*0.16;
    }
    return _btnCommit;
}
-(UIButton *)btnEdit{
    if (!_btnEdit) {
        _btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnEdit.frame = CGRectMake(DeviceSize.width-20-50,DeviceSize.height-54-50-21-64, 50, 50);
        [_btnEdit addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
        [_btnEdit setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
        [_btnEdit setImage:[UIImage imageNamed:@"editor"] forState:UIControlStateNormal];
        [_btnEdit setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
        _btnEdit.layer.masksToBounds = YES;
        _btnEdit.layer.cornerRadius = 25;
    }
    return _btnEdit;
}

-(void)commit{
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<0) {
        self.tableView.contentOffset=CGPointZero;
    }
}
-(UIView *)buttonDown{
    if (!_buttonDown) {
        _buttonDown =[[UIView alloc]initWithFrame:CGRectMake(0,_seg.bottom, DeviceSize.width/2, 3)];
        [_buttonDown setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
    }
    return _buttonDown;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)title{
    return @"跟踪详情";
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

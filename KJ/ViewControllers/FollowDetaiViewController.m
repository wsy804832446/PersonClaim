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
@interface FollowDetaiViewController ()<UIScrollViewDelegate>
//提交按钮
@property (nonatomic,strong)UIButton *btnCommit;
//记录资料切换seg
@property (nonatomic,strong)UISegmentedControl *seg;
//seg下的scrollView
@property (nonatomic,strong) UIScrollView *vc;
@property (nonatomic,assign)NSInteger selectIndex;
//信息list字典
@property (nonatomic,strong)NSMutableDictionary *infoDict;
//事故详情编辑后返回的信息
@property (nonatomic,strong)EditInfoModel *infoModel;
@end

@implementation FollowDetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoModel =[CommUtil readDataWithFileName:[NSString stringWithFormat:@"%@%@",self.taskModel.taskNo,self.taskModel.taskType]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tableView.height = DeviceSize.height - self.tableView.top-54-64;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 23,0, 23)];
    }
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
    [self.view addSubview:bottomView];
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
        return 1;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
            return DeviceSize.height-54-133;
        }else{
            return 10;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width,0.5)];
    view.backgroundColor = [UIColor colorWithHexString:Colorwhite alpha:0.26 ];
    if (section == 1) {
        // 增加事故基本信息view
         _vc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width,DeviceSize.height-54-133)];
        _vc.contentSize = CGSizeMake(DeviceSize.width*2, _vc.height);
        _vc.showsVerticalScrollIndicator = NO;
        _vc.showsHorizontalScrollIndicator = NO;
        _vc.pagingEnabled = YES;
        _vc.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
        _vc.delegate = self;
        _vc.tag = 10000;
        UIView *baseInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, DeviceSize.width, 122)];
        baseInfoView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        [_vc addSubview:baseInfoView];
        //蓝色竖条
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(8, 25.5/2,3, 14.5)];
        imgview.backgroundColor = [UIColor colorWithHexString:Colorblue];
        [baseInfoView addSubview:imgview];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imgview.right+4.5,imgview.top, 100, imgview.height)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:15];
        if ([self.taskModel.taskType isEqual:@"01"]){
            label.text = @"医疗探视";
        }else if ([self.taskModel.taskType isEqual:@"02"]){
            label.text = @"收入情况";
        }else if ([self.taskModel.taskType isEqual:@"03"]){
            label.text = @"误工情况";
        }else if ([self.taskModel.taskType isEqual:@"04"]){
            label.text = @"户籍情况";
        }else if ([self.taskModel.taskType isEqual:@"05"]){
            label.text = @"被扶养人信息";
        }else if ([self.taskModel.taskType isEqual:@"06"]){
            label.text = @"死亡信息";
        }else if ([self.taskModel.taskType isEqual:@"07"]){
            label.text = @"材料调取";
        }else if ([self.taskModel.taskType isEqual:@"09"]) {
            label.text = @"事故基本信息";
        }else if ([self.taskModel.taskType isEqual:@"10"]){
            label.text = @"事故处理情况";
        }
        label.frame = CGRectMake(imgview.right+4.5,imgview.top, label.text.length*16, imgview.height);
        [baseInfoView addSubview:label];
        //编辑按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(baseInfoView.width-8-22, 9, 22, 22);
        [btn setImage:[UIImage imageNamed:@"9"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"9-1"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
        [baseInfoView addSubview:btn];
        //headview和cell顶部分割线
        UIView *vc2 = [[UIView alloc]initWithFrame:CGRectMake(8, 39, baseInfoView.width-16, 1)];
        vc2.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
        [baseInfoView addSubview:vc2];
        //无信息占位label
        if (self.infoModel) {
            if ([self.taskModel.taskType isEqual:@"01"]) {
                [baseInfoView addSubview:[self showView]];
            }
        }else{
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, vc2.bottom, baseInfoView.width,82)];
        lbl.text = @"您还没有记录任何信息...";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.textColor = [UIColor colorWithHexString:@"#999999"];
            [baseInfoView addSubview:lbl];
        }
        //详细资料cell放入headview防止滑动冲突
        for (int i =0; i<10; i++) {
            UIView *cell = [[UIView alloc]initWithFrame:CGRectMake(DeviceSize.width, 10+i*45, DeviceSize.width, 45)];
            cell.backgroundColor = [UIColor colorWithHexString:Colorwhite];
            UILabel *lblLeft = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 0, 44)];
            lblLeft.font = [UIFont systemFontOfSize:15];
            lblLeft.textColor = [UIColor colorWithHexString:@"#666666"];
            lblLeft.text = self.infoDict.allKeys[i];
            lblLeft.frame = CGRectMake(8, 0, lblLeft.text.length*16, 44);
            lblLeft.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:lblLeft];
            UILabel *lblRight = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
            lblRight.font = [UIFont systemFontOfSize:15];
            lblRight.textColor = [UIColor colorWithHexString:Colorblack];
            lblRight.text = self.infoDict.allValues[i];
            lblRight.frame = CGRectMake(cell.width-8-lblRight.text.length*16, 0, lblRight.text.length*16, 44);
            lblRight.textAlignment = NSTextAlignmentRight;
            [cell addSubview:lblRight];
            //分割线
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(8, 44, cell.width-16, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            [cell addSubview:line];
            [_vc addSubview:cell];
        }
         return _vc;
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 39;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 39)];
        vc.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
        //加入segment
        _seg = [[UISegmentedControl alloc]initWithItems:@[@"跟踪记录",@"详细资料"]];
        _seg.frame =CGRectMake(0,0, DeviceSize.width, 39);
        _seg.selectedSegmentIndex = self.selectIndex;
        _seg.tintColor = [UIColor clearColor];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,[UIColor colorWithHexString:Colorgray], NSForegroundColorAttributeName,nil];
        [_seg setTitleTextAttributes:attributes forState:UIControlStateNormal];
        NSDictionary *attributesSlect = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,[UIColor colorWithHexString:Colorblue], NSForegroundColorAttributeName,nil];
        [_seg setTitleTextAttributes:attributesSlect forState:UIControlStateSelected];
        [_seg addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
        _seg.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        [vc addSubview:_seg];
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
    self.vc.contentOffset = CGPointMake(DeviceSize.width*_seg.selectedSegmentIndex,0);
    self.selectIndex = seg.selectedSegmentIndex;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView.tag == 10000){
        self.seg.selectedSegmentIndex =scrollView.contentOffset.x/DeviceSize.width;
        self.selectIndex =self.seg.selectedSegmentIndex;
        
    }
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
-(void)commit{
    
}
-(NSMutableDictionary *)infoDict{
    if (!_infoDict) {
        _infoDict = [NSMutableDictionary dictionary];
    }
    [_infoDict setObject:@"" forKey:@"损伤类型"];
    [_infoDict setObject:self.claimModel.reportNo forKey:@"报案号"];
    [_infoDict setObject:@"" forKey:@"估损单号"];
    [_infoDict setObject:self.claimModel.plateNo forKey:@"车牌号"];
    [_infoDict setObject:self.claimModel.dangerDate forKey:@"出险时间"];
    [_infoDict setObject:self.claimModel.reportDate forKey:@"报案时间"];
    [_infoDict setObject:self.claimModel.insuredName forKey:@"被保险人"];
    [_infoDict setObject:self.claimModel.fPolicyNo forKey:@"交强险保单号"];
    [_infoDict setObject:self.claimModel.bPolicyNo forKey:@"商业保单号"];
    [_infoDict setObject:@"" forKey:@"是否异地"];
    return _infoDict;
}
//展示区
//被扶养人
-(UIView *)showView{
    MedicalVisitViewController *vc = [[MedicalVisitViewController alloc]init];
    vc.isShow = YES;
    vc.claimModel = self.claimModel;
    vc.taskModel = self.taskModel;
    return vc.view;
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

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
#import "ImagePhotoTableViewCell.h"
#import "ShowPictureViewController.h"
#import "LXRTableViewCell.h"
#import "ContactPeopleModel.h"
#import "MedicalVisitTableViewCell.h"
#import "DepartmentsModel.h"
#import "CarePeopleModel.h"
#import "DiagnoseDetailModel.h"
#import "DisabilityModel.h"
#import "UpBringModel.h"
#import "CityModel.h"
@interface FollowDetaiViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
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
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;      // 手势有效设置为YES  无效为NO
    self.navigationController.interactivePopGestureRecognizer.delegate = self;    // 手势的代理设置为self
    self.infoModel =[CommUtil readDataWithFileName:[NSString stringWithFormat:@"%@%@",self.taskModel.taskNo,self.taskModel.taskType]];
    [self getData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tableView.height = DeviceSize.height - self.tableView.top-54-64;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //初始化segment选项为0
    self.selectIndex = 0;
    [self addBottomView];
       // Do any additional setup after loading the view.
}
-(void)getData{
    NSMutableArray *section1 =[NSMutableArray array];
    NSMutableArray *section2 = [NSMutableArray array];
    NSMutableArray *section3 = [NSMutableArray array];
    NSMutableArray *section4 = [NSMutableArray array];
    NSMutableArray *section5 = [NSMutableArray array];
    NSMutableArray *section6 = [NSMutableArray array];
    if ([self.taskModel.taskType isEqual:@"01"]){
       
    }else if ([self.taskModel.taskType isEqual:@"02"]||[self.taskModel.taskType isEqual:@"03"]){
        if (self.infoModel.jobState) {
            ItemTypeModel *model =self.infoModel.jobState;
            if (model.title.length>0) {
                [section1 addObject:@{@"就业情况:":model.title}];
            }
            if ([model.value isEqual:@"0"]) {
                if (self.infoModel.monthIncome.length>0) {
                    [section1 addObject:@{@"月收入:":self.infoModel.monthIncome}];
                }
                if (self.infoModel.socialSecurity) {
                    ItemTypeModel *model =self.infoModel.socialSecurity;
                    if (model.title.length>0) {
                        [section1 addObject:@{@"社会保险:":model.title}];
                    }
                }
                if (self.infoModel.labourContract) {
                    ItemTypeModel *model =self.infoModel.labourContract;
                    if (model.title.length>0) {
                        [section1 addObject:@{@"劳动合同:":model.title}];
                    }
                }
                if (self.infoModel.getMoney) {
                    ItemTypeModel *model =self.infoModel.getMoney;
                    if (model.title.length>0) {
                        [section1 addObject:@{@"薪资发放:":model.title}];
                    }
                }
                if (self.infoModel.tradeModel) {
                    SelectList *model =self.infoModel.tradeModel;
                    if (model.value.length>0) {
                        [section1 addObject:@{@"行业:":model.value}];
                    }
                }
                if (self.infoModel.UnitName.length>0) {
                    [section1 addObject:@{@"单位名称:":self.infoModel.UnitName}];
                }
                if (self.infoModel.UnitAddress.length>0) {
                    [section1 addObject:@{@"单位地址:":self.infoModel.UnitAddress}];
                }
                if (self.infoModel.takingWorkDate.length>0) {
                    [section1 addObject:@{@"入职时间:":self.infoModel.takingWorkDate}];
                }
            }else if ([model.value isEqual:@"1"]){
                if (self.infoModel.offWorkDate.length>0) {
                [section1 addObject:@{@"离职时间:":self.infoModel.offWorkDate}];
                }
            }
        }
        if([self.taskModel.taskType isEqual:@"03"]){
            if (self.infoModel.restDays.length>0) {
                [section2 addObject:@{@"误工天数":self.infoModel.restDays}];
            }
            if (self.infoModel.incomeDecreases.length>0) {
                [section2 addObject:@{@"误工费":self.infoModel.incomeDecreases}];
            }
            
        }
        
        for (ContactPeopleModel *model in self.infoModel.IncomeContactPersonArray) {
            if([self.taskModel.taskType isEqual:@"02"]){
                [section2 addObject:@{model.name:model.phone}];
            }else{
                [section3 addObject:@{model.name:model.phone}];
            }
        }
        
        if (self.infoModel.imageArray.count>0) {
            if([self.taskModel.taskType isEqual:@"02"]){
                [section3 addObject:@{@"img":self.infoModel.imageArray}];
            }else{
                [section4 addObject:@{@"img":self.infoModel.imageArray}];
            }
        }
        
        if (self.infoModel.finishFlag) {
            ItemTypeModel *modle = self.infoModel.finishFlag;
            if (modle.title.length>0) {
                if([self.taskModel.taskType isEqual:@"02"]){
                    [section4 addObject:@{@"完成情况:":modle.title}];
                }else{
                    [section5 addObject:@{@"完成情况:":modle.title}];
                }
            }
        }
        if (self.infoModel.remark.length>0) {
            if([self.taskModel.taskType isEqual:@"02"]){
                [section4 addObject:@{@"备注信息:":self.infoModel.remark}];
            }else{
                [section5 addObject:@{@"备注信息:":self.infoModel.remark}];
            }
        }
    }else if ([self.taskModel.taskType isEqual:@"04"]){
        if (self.infoModel.household) {
            CityModel *model = self.infoModel.household;
            if (model.name.length>0) {
                [section1 addObject:@{@"户籍地:":model.name}];
            }
        }
        
        if (self.infoModel.householdType) {
            SelectList *model = self.infoModel.householdType;
            if (model.value.length>0) {
                [section1 addObject:@{@"户籍类型:":model.value}];
            }
        }
        
        if (self.infoModel.fatherExt) {
            ItemTypeModel *model =self.infoModel.fatherExt;
            if (model.title.length>0) {
                [section2 addObject:@{@"父亲:":model.title}];
            }
        }
        if (self.infoModel.matherExt) {
            ItemTypeModel *model =self.infoModel.matherExt;
            if (model.title.length>0) {
                [section2 addObject:@{@"母亲:":model.title}];
            }
        }
        
        if (self.infoModel.sonCount.length>0) {
            [section2 addObject:@{@"子女:":[NSString stringWithFormat:@"%@人",self.infoModel.sonCount]}];
        }
        
        if (self.infoModel.bratherCount.length>0) {
            [section2 addObject:@{@"姊妹:":[NSString stringWithFormat:@"%@人",self.infoModel.bratherCount]}];
        }
        
        if (self.infoModel.addressBeTrue) {
            ItemTypeModel *model =self.infoModel.addressBeTrue;
            if ([model.value isEqual:@"0"]) {
                [section3 addObject:@{@"居住地:":@"户籍地"}];
            }else{
                [section3 addObject:@{@"居住地:":@"非户籍地"}];
            }
        }
        
        if (self.infoModel.houseAddress.length>0) {
            [section3 addObject:@{@"地址:":self.infoModel.houseAddress}];
        }
        
        
        if (self.infoModel.liveStay.length>0) {
            [section3 addObject:@{@"居住年限:":[NSString stringWithFormat:@"  %@年",self.infoModel.liveStay]}];
        }
        
        for (ContactPeopleModel *model in self.infoModel.insiderPersonArray) {
            [section4 addObject:@{model.name:model}];
        }
        
        if (self.infoModel.imageArray.count>0) {
            [section5 addObject:@{@"img":self.infoModel.imageArray}];
        }
        
        if (self.infoModel.finishFlag) {
            ItemTypeModel *modle = self.infoModel.finishFlag;
            if (modle.title.length>0) {
                [section6 addObject:@{@"完成情况:":modle.title}];
            }
        }
        if (self.infoModel.remark.length>0) {
            [section6 addObject:@{@"备注信息:":self.infoModel.remark}];
        }

    }else if ([self.taskModel.taskType isEqual:@"05"]){
        for (UpBringModel *model in self.infoModel.upBringArray) {
            [section1 addObject:@{model.name:model}];
        }
        
        if (self.infoModel.ratio.length>0) {
            [section2 addObject:@{@"赔偿系数:":[NSString stringWithFormat:@"%@%@",self.infoModel.ratio,@"%"]}];
        }
        if (self.infoModel.maintenance.length>0) {
            [section2 addObject:@{@"抚养费:":[NSString stringWithFormat:@"%@%@",@"￥",self.infoModel.maintenance]}];
        }
        if (self.infoModel.imageArray.count>0) {
            [section3 addObject:@{@"img":self.infoModel.imageArray}];
        }
        
        if (self.infoModel.finishFlag) {
            ItemTypeModel *modle = self.infoModel.finishFlag;
            if (modle.title.length>0) {
                [section4 addObject:@{@"完成情况:":modle.title}];
            }
        }
        if (self.infoModel.remark.length>0) {
            [section4 addObject:@{@"备注信息:":self.infoModel.remark}];
        }
    }else if ([self.taskModel.taskType isEqual:@"06"]){
        if (self.infoModel.deathAddress.length>0) {
            [section1 addObject:@{@"死亡地点:":self.infoModel.deathAddress}];
        }
        if (self.infoModel.deathDate.length>0) {
            [section1 addObject:@{@"死亡时间:":self.infoModel.deathDate}];
        }
        if (self.infoModel.lnvolvement.length>0) {
            [section1 addObject:@{@"参与度:":self.infoModel.lnvolvement}];
        }
        if (self.infoModel.deathReason) {
            SelectList *model =self.infoModel.deathReason;
            if (model.value.length>0) {
                [section1 addObject:@{@"死亡原因:":model.value}];
            }
        }
        
        if (self.infoModel.imageArray.count>0) {
            [section2 addObject:@{@"img":self.infoModel.imageArray}];
        }
        
        if (self.infoModel.finishFlag) {
            ItemTypeModel *modle = self.infoModel.finishFlag;
            if (modle.title.length>0) {
                [section3 addObject:@{@"完成情况:":modle.title}];
            }
        }
        if (self.infoModel.remark.length>0) {
            [section3 addObject:@{@"备注信息:":self.infoModel.remark}];
        }
       
    }else if ([self.taskModel.taskType isEqual:@"08"]){
        if (self.infoModel.organization) {
            HospitalModel *model = self.infoModel.organization;
            if (model.hospitalName.length>0) {
                [section1 addObject:@{@"鉴定机构:":model.hospitalName}];
            }
        }
        
        if (self.infoModel.identifier.length>0) {
            [section1 addObject:@{@"鉴定人:":self.infoModel.identifier}];
        }
        if (self.infoModel.ratio.length>0) {
            [section1 addObject:@{@"赔偿系数:":self.infoModel.ratio}];
        }
        
        if (self.infoModel.disabilityDescribe.length>0) {
            [section1 addObject:@{@"伤残描述:":self.infoModel.disabilityDescribe}];
        }
        
        if (self.infoModel.levelArray.count>0) {
            for (DisabilityModel *model in self.infoModel.levelArray) {
                [section2 addObject:@{[NSString stringWithFormat:@"%@[%@]",model.level,model.disabilityCode]:model.disabilityDescr}];
            }
        }

        if (self.infoModel.imageArray.count>0) {
            [section3 addObject:@{@"img":self.infoModel.imageArray}];
        }
        
        if (self.infoModel.finishFlag) {
            ItemTypeModel *modle = self.infoModel.finishFlag;
            if (modle.title.length>0) {
                [section4 addObject:@{@"完成情况:":modle.title}];
            }
        }
        if (self.infoModel.remark.length>0) {
            [section4 addObject:@{@"备注信息:":self.infoModel.remark}];
        }

    }else if ([self.taskModel.taskType isEqual:@"09"]||[self.taskModel.taskType isEqual:@"10"]) {
        
    }
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:@{@"section0":@"都一样"}];
    if (section1.count>0) {
        [self.dataArray addObject:@{@"section1":section1}];
    }
    if (section2.count>0) {
        [self.dataArray addObject:@{@"section2":section2}];
    }
    if (section3.count>0) {
        [self.dataArray addObject:@{@"section3":section3}];
    }
    if (section4.count>0) {
        [self.dataArray addObject:@{@"section4":section4}];
    }
    if (section5.count>0) {
        [self.dataArray addObject:@{@"section5":section5}];
    }
    if (section6.count>0) {
        [self.dataArray addObject:@{@"section6":section6}];
    }
}
-(void)addBottomView{
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
    if (self.selectIndex ==0) {
        [self.view addSubview:self.btnEdit];
    }
    [self.view addSubview:bottomView];
}

-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.selectIndex ==1) {
        return 2;
    }else{
        if ([self.taskModel.taskType isEqual:@"01"]){
            return 7;
        }else if ([self.taskModel.taskType isEqual:@"09"]||[self.taskModel.taskType isEqual:@"10"]) {
            return 5;
        }
        return self.dataArray.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        if (self.selectIndex == 1) {
            return 10;
        }else{
            if ([self.taskModel.taskType isEqual:@"01"]){
                if (section ==1){
                    return 1;
                }else if (section ==2){
                    return self.infoModel.diaArray.count;
                }else if (section ==3){
                    return self.infoModel.carePeopleArray.count;
                }else if (section ==4){
                    return 1;
                }else if (section ==5){
                    return 1;
                }else{
                    return 2;
                }
            }else if ([self.taskModel.taskType isEqual:@"09"]||[self.taskModel.taskType isEqual:@"10"]) {
                if (section ==1){
                    return 3;
                }else if (section ==2){
                    return self.infoModel.contactPersonArray.count;
                }else if (section ==3){
                    return 1;
                }else if (section ==4){
                    return 2;
                }
            }else{
                NSDictionary *sectionDic = [self.dataArray[section] allValues].firstObject;
                return sectionDic.count;
            }
            return 0;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 102;
    }else{
        if (self.selectIndex ==1) {
            return 44;
        }else{
            if ([self.taskModel.taskType isEqual:@"01"]){
                if(indexPath.section ==1){
                    if (self.infoModel.hosArray.count>0) {
                        return 60;
                    }else{
                        return 0;
                    }
                }else if (indexPath.section ==2 ) {
                    if (self.infoModel.diaArray.count>0) {
                        return 60;
                    }else{
                        return 0;
                    }
                }else if(indexPath.section ==3){
                    if (self.infoModel.carePeopleArray.count>0) {
                        return 60;
                    }else{
                        return 0;
                    }
                }else if(indexPath.section ==4){
                    if (self.infoModel.feePass.length>0) {
                        return 44;
                    }else{
                        return 0;
                    }
                }else if (indexPath.section == 5){
                    if (self.infoModel.imageArray.count>0) {
                        return 95+85*(self.infoModel.imageArray.count/4);
                    }else{
                        return 0;
                    }
                }else{
                    if (indexPath.row ==0) {
                        ItemTypeModel *model = self.infoModel.finishFlag;
                        if (model.title.length>0) {
                            return 44;
                        }else{
                            return 0;
                        }
                    }else{
                        if (self.infoModel.remark.length>0) {
                            return [self getHeightWithString:self.infoModel.remark];
                        }else{
                            return 0;
                        }
                    }
                }
            }else if ([self.taskModel.taskType isEqual:@"02"]){
                NSDictionary *dic = self.dataArray[indexPath.section];
                NSDictionary *rowDic =dic.allValues.firstObject[indexPath.row];
                if ([dic.allKeys.firstObject isEqual:@"section3"]){
                    if (self.infoModel.imageArray.count>0) {
                        return 95+85*(self.infoModel.imageArray.count/4);
                    }
                }else if([dic.allKeys.firstObject isEqual:@"section4"]&&[rowDic.allKeys.firstObject isEqual:@"备注信息:"]){
                    return [self getHeightWithString:self.infoModel.remark];
                }else{
                    return 44;
                }
            }else if ([self.taskModel.taskType isEqual:@"03"]){
                NSDictionary *dic = self.dataArray[indexPath.section];
                NSDictionary *rowDic =dic.allValues.firstObject[indexPath.row];
                if ([dic.allKeys.firstObject isEqual:@"section4"]){
                    if (self.infoModel.imageArray.count>0) {
                        return 95+85*(self.infoModel.imageArray.count/4);
                    }
                }else if([dic.allKeys.firstObject isEqual:@"section5"]&&[rowDic.allKeys.firstObject isEqual:@"备注信息:"]){
                    return [self getHeightWithString:self.infoModel.remark];
                }else{
                    return 44;
                }
            }else if ([self.taskModel.taskType isEqual:@"04"]){
                NSDictionary *dic = self.dataArray[indexPath.section];
                NSDictionary *rowDic =dic.allValues.firstObject[indexPath.row];
                if ([dic.allKeys.firstObject isEqual:@"section5"]){
                    if (self.infoModel.imageArray.count>0) {
                        return 95+85*(self.infoModel.imageArray.count/4);
                    }
                }else if([dic.allKeys.firstObject isEqual:@"section6"]&&[rowDic.allKeys.firstObject isEqual:@"备注信息:"]){
                    return [self getHeightWithString:self.infoModel.remark];
                }else if([dic.allKeys.firstObject isEqual:@"section3"]&&[rowDic.allKeys.firstObject isEqual:@"地址:"]){
                    return [self getHeightWithString:self.infoModel.remark];
                }else{
                    return 44;
                }
            }else if ([self.taskModel.taskType isEqual:@"05"]){
                NSDictionary *dic = self.dataArray[indexPath.section];
                NSDictionary *rowDic =dic.allValues.firstObject[indexPath.row];
                if ([dic.allKeys.firstObject isEqual:@"section3"]){
                    if (self.infoModel.imageArray.count>0) {
                        return 95+85*(self.infoModel.imageArray.count/4);
                    }
                }else if([dic.allKeys.firstObject isEqual:@"section4"]&&[rowDic.allKeys.firstObject isEqual:@"备注信息:"]){
                    return [self getHeightWithString:self.infoModel.remark];
                }else if ([dic.allKeys.firstObject isEqual:@"section1"]){
                    return 60;
                }else{
                    return 44;
                }

            }else if ([self.taskModel.taskType isEqual:@"06"]){
                NSDictionary *dic = self.dataArray[indexPath.section];
                NSDictionary *rowDic =dic.allValues.firstObject[indexPath.row];
                if ([dic.allKeys.firstObject isEqual:@"section2"]){
                    if (self.infoModel.imageArray.count>0) {
                        return 95+85*(self.infoModel.imageArray.count/4);
                    }
                }else if([dic.allKeys.firstObject isEqual:@"section3"]&&[rowDic.allKeys.firstObject isEqual:@"备注信息:"]){
                    return [self getHeightWithString:self.infoModel.remark];
                }else if ([rowDic.allKeys.firstObject isEqual:@"死亡原因"]){
                    return [self getHeightWithString:rowDic[@"死亡原因"]];
                }else{
                    return 44;
                }
            }else if ([self.taskModel.taskType isEqual:@"08"]){
                NSDictionary *dic = self.dataArray[indexPath.section];
                NSDictionary *rowDic =dic.allValues.firstObject[indexPath.row];
                if ([dic.allKeys.firstObject isEqual:@"section3"]){
                    if (self.infoModel.imageArray.count>0) {
                        return 95+85*(self.infoModel.imageArray.count/4);
                    }
                }else if([dic.allKeys.firstObject isEqual:@"section4"]&&[rowDic.allKeys.firstObject isEqual:@"备注信息:"]){
                    return [self getHeightWithString:self.infoModel.remark];
                }else if ([rowDic.allKeys.firstObject isEqual:@"伤残描述:"]){
                    return [self getHeightWithString:rowDic[@"伤残描述:"]];
                }else if ([dic.allKeys.firstObject isEqual:@"section2"]){
                    return 60;
                }else{
                    return 44;
                }

            }else if ([self.taskModel.taskType isEqual:@"09"]||[self.taskModel.taskType isEqual:@"10"]) {
                if (indexPath.section ==2 ) {
                    if (self.infoModel.contactPersonArray.count>0) {
                        return 44;
                    }else{
                        return 0;
                    }
                }else if (indexPath.section == 3){
                    if (self.infoModel.imageArray.count>0) {
                        return 95+85*(self.infoModel.imageArray.count/4);
                    }else{
                        return 0;
                    }
                }else if(indexPath.section ==1){
                    if (indexPath.row ==0) {
                        if ([self.taskModel.taskType isEqual:@"09"]) {
                            if (self.infoModel.address.length>0) {
                                return [self getHeightWithString:self.infoModel.address];
                            }else{
                                return 0;
                            }
                        }else{
                            if (self.infoModel.dealName.length>0) {
                                return 44;
                            }else{
                                return 0;
                            }
                        }
                    }else if (indexPath.row ==2){
                        if ([self.taskModel.taskType isEqual:@"09"]) {
                            if (self.infoModel.detailInfo.length>0) {
                                return [self getHeightWithString:self.infoModel.detailInfo];
                            }else{
                                return 0;
                            }
                        }else{
                            if (self.infoModel.dealResult.length>0) {
                                return [self getHeightWithString:self.infoModel.dealResult];
                            }else{
                                return 0;
                            }
                        }
                        
                    }else{
                        if ([self.taskModel.taskType isEqual:@"09"]) {
                            if (self.infoModel.accidentDate.length>0) {
                                return 44;
                            }else{
                                return 0;
                            }
                        }else{
                            if (self.infoModel.dealDate.length>0) {
                                return 44;
                            }else{
                                return 0;
                            }
                        }
                    }
                }else{
                    if (indexPath.row ==0) {
                        ItemTypeModel *model = self.infoModel.finishFlag;
                        if (model.title.length>0) {
                            return 44;
                        }else{
                            return 0;
                        }
                    }else{
                        if (self.infoModel.remark.length>0) {
                            return [self getHeightWithString:self.infoModel.remark];
                        }else{
                            return 0;
                        }
                    }
                }
            }
            return 0;
        }
    }
}
-(CGFloat)getHeightWithString:(NSString *)str{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame)-30, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return rect.size.height+28;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
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
            [self alertTellWithName:self.claimModel.insuredName andPhoneNumber:self.claimModel.mobilePhone];
        }];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *Date = [formatter dateFromString:self.taskModel.dispatchDate];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateStr = [formatter stringFromDate:Date];
        cell.lblTime.text = dateStr;
        return cell;
    }
    if (self.selectIndex == 0) {
        if ([self.taskModel.taskType isEqual:@"01"]){
            if(indexPath.section ==1 || indexPath.section ==2|| indexPath.section ==3){
                MedicalVisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MedicalCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MedicalVisitTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.section ==1) {
                    NSDictionary *dic = self.infoModel.hosArray.firstObject;
                    NSMutableString *detailString = [NSMutableString string];
                    HospitalModel *model = dic[@"Hospital"];
                    for (DepartmentsModel *departmentsModel in dic[@"department"]) {
                        if(detailString.length>0){
                            [detailString appendString:@"、"];
                        }
                        [detailString appendString:departmentsModel.value];
                    }
                    cell.lblTitle.text = model.hospitalName;
                    cell.lblDetail.text = detailString;
                }else if (indexPath.section ==2){
                    DiagnoseDetailModel *model = self.infoModel.diaArray[indexPath.row];
                    cell.lblTitle.text = model.itemCnName;
                    cell.lblDetail.text = model.way;
                    [cell.lblMoney removeFromSuperview];
                }else if (indexPath.section ==3){
                    CarePeopleModel *model = self.infoModel.carePeopleArray[indexPath.row];
                    SelectList *listModel = model.identity;
                    NSAttributedString *identity = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"  (%@)",listModel.value] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:Colorgray]}];
                    NSAttributedString *strName = [[NSAttributedString alloc]initWithString:model.name attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:Colorblack]}];
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString:strName];
                    [string appendAttributedString:identity];
                    cell.lblTitle.attributedText = string;
                    cell.lblDetail.text = [NSString stringWithFormat:@"天数:%@天",model.days];
                    cell.lblMoney.text = [NSString stringWithFormat:@"费用:￥%@",model.cost];
                }
                return cell;
            }else if (indexPath.section ==4 ||indexPath.section ==6){
                ShowDetailLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShowLabelCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ShowDetailLabelTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row ==0 && indexPath.section ==6) {
                    ItemTypeModel *model = self.infoModel.finishFlag;
                    [cell configCellWithString:model.title];
                    cell.lblTitle.text = @"完成情况:";
                    if (model.title.length ==0) {
                        cell.hidden = YES;
                    }
                }else if(indexPath.row ==1 && indexPath.section ==6){
                    [cell configCellWithString:self.infoModel.remark];
                    cell.lblTitle.text = @"备注信息:";
                    if (self.infoModel.remark.length ==0) {
                        cell.hidden = YES;
                    }
                }else{
                    [cell configCellWithString:[NSString stringWithFormat:@"￥%@",self.infoModel.feePass]];
                    cell.lblTitle.text = @"医疗费金额:";
                    if (self.infoModel.feePass.length ==0) {
                        cell.hidden = YES;
                    }
                }
                return cell;
            }else if (indexPath.section ==5){
                ImagePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ImagePhotoTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //取出model里所有图片
                NSMutableArray *array = [NSMutableArray array];
                for (imageModel *model in self.infoModel.imageArray) {
                    [array addObject:model.image];
                }
                if (array.count ==0) {
                    cell.hidden = YES;
                }else{
                    [cell configImgWithImgArray:array];
                    [cell setBtnSelectBlock:^(UIButton *btn) {
                        [self showPictureWithIndex:btn.tag-2000];
                    }];
                }
                return cell;
            }
        }else if ([self.taskModel.taskType isEqual:@"02"]){
            NSDictionary *sectionDic = self.dataArray[indexPath.section];
            if ([sectionDic.allKeys.firstObject isEqual:@"section1"]||[sectionDic.allKeys.firstObject isEqual:@"section4"]) {
                ShowDetailLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShowLabelCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ShowDetailLabelTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *arr = @[];
                if ([sectionDic.allKeys.firstObject isEqual:@"section1"]) {
                     arr = sectionDic[@"section1"];
                }else{
                     arr = sectionDic[@"section4"];
                }
                NSDictionary *dataDic = arr[indexPath.row];
                cell.lblTitle.text = dataDic.allKeys.firstObject;
                cell.lblShowDetail.text =dataDic.allValues.firstObject;
                return cell;
            }else if ([sectionDic.allKeys.firstObject isEqual:@"section2"]){
                LXRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LXRCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"LXRTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *arr = sectionDic[@"section2"];
                NSDictionary *dataDic = arr[indexPath.row];
                cell.lblName.text = dataDic.allKeys.firstObject;
                cell.lblPhoneNumber.text = dataDic.allValues.firstObject;
                [cell setBtnCallClickBlock:^{
                    [self alertTellWithName:dataDic.allKeys.firstObject andPhoneNumber:dataDic.allValues.firstObject];
                }];
                return cell;
            }else if ([sectionDic.allKeys.firstObject isEqual:@"section3"]){
                ImagePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ImagePhotoTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                NSArray *arr = sectionDic[@"section3"];
                NSMutableArray *array =[NSMutableArray array];
                NSDictionary *dataDic = arr[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //取出model里所有图片
                for (imageModel *model in dataDic.allValues.firstObject) {
                    [array addObject:model.image];
                }
                if (array.count ==0) {
                    cell.hidden = YES;
                }else{
                    [cell configImgWithImgArray:array];
                    [cell setBtnSelectBlock:^(UIButton *btn) {
                        [self showPictureWithIndex:btn.tag-2000];
                    }];
                }
                return cell;
            }
        }else if ([self.taskModel.taskType isEqual:@"03"]){
            NSDictionary *sectionDic = self.dataArray[indexPath.section];
            if ([sectionDic.allKeys.firstObject isEqual:@"section1"]||[sectionDic.allKeys.firstObject isEqual:@"section2"]||[sectionDic.allKeys.firstObject isEqual:@"section5"]) {
                ShowDetailLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShowLabelCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ShowDetailLabelTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *arr = sectionDic.allValues.firstObject;
                NSDictionary *dataDic = arr[indexPath.row];
                cell.lblTitle.text = dataDic.allKeys.firstObject;
                cell.lblShowDetail.text =dataDic.allValues.firstObject;
                return cell;
            }else if ([sectionDic.allKeys.firstObject isEqual:@"section3"]){
                LXRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LXRCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"LXRTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *arr = sectionDic[@"section3"];
                NSDictionary *dataDic = arr[indexPath.row];
                cell.lblName.text = dataDic.allKeys.firstObject;
                cell.lblPhoneNumber.text = dataDic.allValues.firstObject;
                [cell setBtnCallClickBlock:^{
                    [self alertTellWithName:dataDic.allKeys.firstObject andPhoneNumber:dataDic.allValues.firstObject];
                }];
                return cell;
            }else if ([sectionDic.allKeys.firstObject isEqual:@"section4"]){
                ImagePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ImagePhotoTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                NSArray *arr = sectionDic[@"section4"];
                NSMutableArray *array =[NSMutableArray array];
                NSDictionary *dataDic = arr[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //取出model里所有图片
                for (imageModel *model in dataDic.allValues.firstObject) {
                    [array addObject:model.image];
                }
                if (array.count ==0) {
                    cell.hidden = YES;
                }else{
                    [cell configImgWithImgArray:array];
                    [cell setBtnSelectBlock:^(UIButton *btn) {
                        [self showPictureWithIndex:btn.tag-2000];
                    }];
                }
                return cell;
            }
        }else if ([self.taskModel.taskType isEqual:@"04"]){
            NSDictionary *sectionDic = self.dataArray[indexPath.section];
            if ([sectionDic.allKeys.firstObject isEqual:@"section1"]||[sectionDic.allKeys.firstObject isEqual:@"section2"]||[sectionDic.allKeys.firstObject isEqual:@"section3"]||[sectionDic.allKeys.firstObject isEqual:@"section6"]) {
                ShowDetailLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShowLabelCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ShowDetailLabelTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *arr = @[];
                if ([sectionDic.allKeys.firstObject isEqual:@"section1"]) {
                    arr = sectionDic[@"section1"];
                }else if ([sectionDic.allKeys.firstObject isEqual:@"section2"]){
                    arr = sectionDic[@"section2"];
                }else if ([sectionDic.allKeys.firstObject isEqual:@"section3"]){
                    arr = sectionDic[@"section3"];
                }else if ([sectionDic.allKeys.firstObject isEqual:@"section6"]){
                    arr = sectionDic[@"section6"];
                }
                NSDictionary *dataDic = arr[indexPath.row];
                cell.lblTitle.text = dataDic.allKeys.firstObject;
                cell.lblShowDetail.text =dataDic.allValues.firstObject;
                return cell;
            }else if ([sectionDic.allKeys.firstObject isEqual:@"section5"]){
                ImagePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ImagePhotoTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                NSArray *arr = sectionDic[@"section5"];
                NSMutableArray *array =[NSMutableArray array];
                NSDictionary *dataDic = arr[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //取出model里所有图片
                for (imageModel *model in dataDic.allValues.firstObject) {
                    [array addObject:model.image];
                }
                if (array.count ==0) {
                    cell.hidden = YES;
                }else{
                    [cell configImgWithImgArray:array];
                    [cell setBtnSelectBlock:^(UIButton *btn) {
                        [self showPictureWithIndex:btn.tag-2000];
                    }];
                }
                return cell;
            }else if ([sectionDic.allKeys.firstObject isEqual:@"section4"]){
                LXRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LXRCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"LXRTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *arr = sectionDic[@"section4"];
                NSDictionary *dataDic = arr[indexPath.row];
                ContactPeopleModel *model =dataDic.allValues.firstObject;
                SelectList *listModel = model.insiderIdentity;
                NSAttributedString *identity = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"  (%@)",listModel.value] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:Colorgray]}];
                NSAttributedString *strName = [[NSAttributedString alloc]initWithString:model.name attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:Colorblack]}];
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString:strName];
                [string appendAttributedString:identity];
                cell.lblName.attributedText = string;
                cell.lblPhoneNumber.text = model.phone;
                [cell setBtnCallClickBlock:^{
                    [self alertTellWithName:dataDic.allKeys.firstObject andPhoneNumber:dataDic.allValues.firstObject];
                }];
                return cell;
            }

        }else if ([self.taskModel.taskType isEqual:@"05"]){
            NSDictionary *sectionDic = self.dataArray[indexPath.section];
            if ([sectionDic.allKeys.firstObject isEqual:@"section2"]||[sectionDic.allKeys.firstObject isEqual:@"section4"]) {
                ShowDetailLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShowLabelCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ShowDetailLabelTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *arr = @[];
                if ([sectionDic.allKeys.firstObject isEqual:@"section2"]) {
                    arr = sectionDic[@"section2"];
                }else{
                    arr = sectionDic[@"section4"];
                }
                NSDictionary *dataDic = arr[indexPath.row];
                cell.lblTitle.text = dataDic.allKeys.firstObject;
                cell.lblShowDetail.text =dataDic.allValues.firstObject;
                return cell;
            }else if ([sectionDic.allKeys.firstObject isEqual:@"section3"]){
                ImagePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ImagePhotoTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                NSArray *arr = sectionDic[@"section3"];
                NSMutableArray *array =[NSMutableArray array];
                NSDictionary *dataDic = arr[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //取出model里所有图片
                for (imageModel *model in dataDic.allValues.firstObject) {
                    [array addObject:model.image];
                }
                if (array.count ==0) {
                    cell.hidden = YES;
                }else{
                    [cell configImgWithImgArray:array];
                    [cell setBtnSelectBlock:^(UIButton *btn) {
                        [self showPictureWithIndex:btn.tag-2000];
                    }];
                }
                return cell;
            }else if ([sectionDic.allKeys.firstObject isEqual:@"section1"]){
                MedicalVisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MedicalCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MedicalVisitTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *arr = sectionDic[@"section1"];
                NSDictionary *dataDic = arr[indexPath.row];
                UpBringModel *model = dataDic.allValues.firstObject;
                SelectList *relation = model.Relation;
                NSAttributedString *identity = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"  (%@)",relation.value] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:Colorgray]}];
                NSAttributedString *strName = [[NSAttributedString alloc]initWithString:model.name attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:Colorblack]}];
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString:strName];
                [string appendAttributedString:identity];
                cell.lblTitle.attributedText = string;
                SelectList *householdType = model.householdType;
                cell.lblDetail.text = householdType.value;
                cell.lblMoney.text =[NSString stringWithFormat:@"扶养年限:%@年",model.years];
                return cell;
            }
        }else if ([self.taskModel.taskType isEqual:@"06"]){
            NSDictionary *sectionDic = self.dataArray[indexPath.section];
            if ([sectionDic.allKeys.firstObject isEqual:@"section1"]||[sectionDic.allKeys.firstObject isEqual:@"section3"]) {
                ShowDetailLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShowLabelCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ShowDetailLabelTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *arr = @[];
                if ([sectionDic.allKeys.firstObject isEqual:@"section1"]) {
                    arr = sectionDic[@"section1"];
                }else{
                    arr = sectionDic[@"section3"];
                }
                NSDictionary *dataDic = arr[indexPath.row];
                cell.lblTitle.text = dataDic.allKeys.firstObject;
                cell.lblShowDetail.text =dataDic.allValues.firstObject;
                return cell;
            }else if ([sectionDic.allKeys.firstObject isEqual:@"section2"]){
                ImagePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ImagePhotoTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                NSArray *arr = sectionDic[@"section2"];
                NSMutableArray *array =[NSMutableArray array];
                NSDictionary *dataDic = arr[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //取出model里所有图片
                for (imageModel *model in dataDic.allValues.firstObject) {
                    [array addObject:model.image];
                }
                if (array.count ==0) {
                    cell.hidden = YES;
                }else{
                    [cell configImgWithImgArray:array];
                    [cell setBtnSelectBlock:^(UIButton *btn) {
                        [self showPictureWithIndex:btn.tag-2000];
                    }];
                }
                return cell;
            }
        }else if ([self.taskModel.taskType isEqual:@"08"]){
            NSDictionary *sectionDic = self.dataArray[indexPath.section];
            if ([sectionDic.allKeys.firstObject isEqual:@"section1"]||[sectionDic.allKeys.firstObject isEqual:@"section4"]) {
                ShowDetailLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShowLabelCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ShowDetailLabelTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *arr = @[];
                if ([sectionDic.allKeys.firstObject isEqual:@"section1"]) {
                    arr = sectionDic[@"section1"];
                }else{
                    arr = sectionDic[@"section4"];
                }
                NSDictionary *dataDic = arr[indexPath.row];
                cell.lblTitle.text = dataDic.allKeys.firstObject;
                cell.lblShowDetail.text =dataDic.allValues.firstObject;
                return cell;
            }else if ([sectionDic.allKeys.firstObject isEqual:@"section3"]){
                ImagePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ImagePhotoTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                NSArray *arr = sectionDic[@"section3"];
                NSMutableArray *array =[NSMutableArray array];
                NSDictionary *dataDic = arr[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //取出model里所有图片
                for (imageModel *model in dataDic.allValues.firstObject) {
                    [array addObject:model.image];
                }
                if (array.count ==0) {
                    cell.hidden = YES;
                }else{
                    [cell configImgWithImgArray:array];
                    [cell setBtnSelectBlock:^(UIButton *btn) {
                        [self showPictureWithIndex:btn.tag-2000];
                    }];
                }
                return cell;
            }else if ([sectionDic.allKeys.firstObject isEqual:@"section2"]){
                MedicalVisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MedicalCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MedicalVisitTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSArray *arr = sectionDic[@"section2"];
                NSDictionary *dataDic = arr[indexPath.row];
                cell.lblTitle.text = dataDic.allKeys.firstObject;
                cell.lblDetail.text = dataDic.allValues.firstObject;
                return cell;
            }
        }else if ([self.taskModel.taskType isEqual:@"09"] ||[self.taskModel.taskType isEqual:@"10"]) {
            if(indexPath.section ==1 || indexPath.section ==4){
                ShowDetailLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShowLabelCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ShowDetailLabelTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lblShowDetail.textColor = [UIColor colorWithHexString:Colorblack];
                if (indexPath.row ==0 && indexPath.section ==1) {
                    if ([self.taskModel.taskType isEqual:@"09"]) {
                        [cell configCellWithString:self.infoModel.address];
                        cell.lblTitle.text = @"事故地址:";
                        if (self.infoModel.address.length ==0) {
                            cell.hidden = YES;
                        }
                    }else{
                        [cell configCellWithString:self.infoModel.dealName];
                        cell.lblTitle.text = @"姓        名:";
                        if (self.infoModel.dealName.length ==0) {
                            cell.hidden = YES;
                        }
                    }
                }else if (indexPath.row ==1&& indexPath.section ==1){
                    if ([self.taskModel.taskType isEqual:@"09"]) {
                        [cell configCellWithString:self.infoModel.accidentDate];
                        cell.lblTitle.text = @"事故时间:";
                        if (self.infoModel.accidentDate.length ==0) {
                            cell.hidden = YES;
                        }
                    }else{
                        [cell configCellWithString:self.infoModel.dealDate];
                        cell.lblTitle.text = @"时        间:";
                        if (self.infoModel.dealDate.length ==0) {
                            cell.hidden = YES;
                        }
                    }
                }else if (indexPath.row ==2&& indexPath.section ==1){
                    if ([self.taskModel.taskType isEqual:@"09"]) {
                        [cell configCellWithString:self.infoModel.detailInfo];
                        cell.lblTitle.text = @"事故详情:";
                        if (self.infoModel.detailInfo.length ==0) {
                            cell.hidden = YES;
                        }
                    }else{
                        [cell configCellWithString:self.infoModel.dealResult];
                        cell.lblTitle.text = @"处理结果:";
                        if (self.infoModel.dealResult.length ==0) {
                        cell.hidden = YES;
                        }
                    }
                }else if (indexPath.row ==0 && indexPath.section ==4){
                    ItemTypeModel *model = self.infoModel.finishFlag;
                    [cell configCellWithString:model.title];
                    cell.lblTitle.text = @"完成情况:";
                    if (model.title.length ==0) {
                        cell.hidden = YES;
                    }
                }else if (indexPath.row ==1 && indexPath.section ==4){
                    [cell configCellWithString:self.infoModel.remark];
                    cell.lblTitle.text = @"备注信息:";
                    if (self.infoModel.remark.length ==0) {
                        cell.hidden = YES;
                    }
                }
                return cell;
            }else if (indexPath.section ==3){
                ImagePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ImagePhotoTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //取出model里所有图片
                NSMutableArray *array = [NSMutableArray array];
                for (imageModel *model in self.infoModel.imageArray) {
                    [array addObject:model.image];
                }
                if (array.count ==0) {
                    cell.hidden = YES;
                }else{
                    [cell configImgWithImgArray:array];
                    [cell setBtnSelectBlock:^(UIButton *btn) {
                        [self showPictureWithIndex:btn.tag-2000];
                    }];
                }
                return cell;
            }else{
                LXRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LXRCell"];
                if (!cell) {
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"LXRTableViewCell" owner:nil options:nil];
                    if (nib.count>0) {
                        cell = [nib firstObject];
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                ContactPeopleModel *model = self.infoModel.contactPersonArray[indexPath.row];
                cell.lblName.text = model.name;
                cell.lblPhoneNumber.text = model.phone;
                [cell setBtnCallClickBlock:^{
                    [self alertTellWithName:model.name andPhoneNumber:model.phone];
                }];
                return cell;
            }
        }
        return nil;
    }else{
        ShowDetailLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShowLabelCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ShowDetailLabelTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row ==0) {
            [cell.line removeFromSuperview];
        }
        cell.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.lblTitle.font = [UIFont systemFontOfSize:15];
        cell.lblShowDetail.textColor = [UIColor colorWithHexString:Colorblack];
        cell.lblShowDetail.font = [UIFont systemFontOfSize:15];
        if (indexPath.row ==0) {
            cell.lblTitle.text = @"损伤类型:";
            cell.lblShowDetail.text = @"";
        }else if (indexPath.row ==1){
            cell.lblTitle.text = @"报  案  号:";
            cell.lblShowDetail.text = self.claimModel.reportNo;
        }else if (indexPath.row ==2){
            cell.lblTitle.text = @"估损单号:";
            cell.lblShowDetail.text = @"";
        }else if (indexPath.row ==3){
            cell.lblTitle.text = @"车  牌  号:";
            cell.lblShowDetail.text = self.claimModel.plateNo;
        }else if (indexPath.row ==4){
            cell.lblTitle.text = @"出险时间:";
            cell.lblShowDetail.text = self.claimModel.dangerDate;
        }else if (indexPath.row ==5){
            cell.lblTitle.text = @"报案时间:";
            cell.lblShowDetail.text = self.claimModel.reportDate;
        }else if (indexPath.row ==6){
            cell.lblTitle.text = @"被保险人:";
            cell.lblShowDetail.text = self.claimModel.insuredName;
        }else if (indexPath.row ==7){
            cell.lblTitle.text = @"交  强  险:";
            cell.lblShowDetail.text = self.claimModel.fPolicyNo;
        }else if (indexPath.row ==8){
            cell.lblTitle.text = @"商  业  险:";
            cell.lblShowDetail.text = self.claimModel.bPolicyNo;
        }else {
            cell.lblTitle.text = @"是否异地:";
            cell.lblShowDetail.text = @"";
        }
        cell.userInteractionEnabled = NO;
        return cell;
    }
}
-(void)showPictureWithIndex:(NSInteger)index{
    ShowPictureViewController *vc = [[ShowPictureViewController alloc]init];
    //取出model里所有图片
    NSMutableArray *array = [NSMutableArray array];
    for (imageModel *model in self.infoModel.imageArray) {
        [array addObject:model.image];
    }
    vc.pictureArray = array;
    vc.selectIndex = index;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)alertTellWithName:(NSString *)name andPhoneNumber:(NSString *)phone{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:name message:phone preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *call = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]]];
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
            if ([self.taskModel.taskType isEqual:@"01"]){
                if (section ==1) {
                    if (self.infoModel.hosArray.count>0){
                        return 39;
                    }
                }else if (section ==2) {
                    if (self.infoModel.diaArray.count>0) {
                        return 39;
                    }
                }else if (section ==3) {
                    if (self.infoModel.carePeopleArray.count>0) {
                        return 39;
                    }
                }else if (section ==4) {
                    if (self.infoModel.feePass.length>0) {
                        return 39;
                    }
                }else if (section ==5) {
                    if (self.infoModel.imageArray.count>0) {
                        return 39;
                    }
                }else if (section ==6) {
                    if (self.infoModel.remark.length>0 || self.infoModel.finishFlag) {
                        return 39;
                    }
                }
            }else if ([self.taskModel.taskType isEqual:@"09"] ||[self.taskModel.taskType isEqual:@"10"]) {
                if (section ==1) {
                    if ([self.taskModel.taskType isEqual:@"09"]) {
                        if (self.infoModel.address.length>0 || self.infoModel.accidentDate.length>0 ||self.infoModel.detailInfo.length>0) {
                            return 39;
                        }
                    }else{
                        if (self.infoModel.dealName.length>0 || self.infoModel.dealDate.length>0 ||self.infoModel.dealResult.length>0) {
                            return 39;
                        }
                    }
                }else if (section ==2) {
                    if (self.infoModel.contactPersonArray.count>0) {
                        return 39;
                    }
                }else if (section ==3) {
                    if (self.infoModel.imageArray.count>0) {
                        return 39;
                    }
                }else if (section ==4) {
                    if (self.infoModel.remark.length>0 || self.infoModel.finishFlag) {
                        return 39;
                    }
                }
            }else{
                return 39;
            }
            return 0.01;
        }else{
            return 0.01;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view ;
    if (section == 0 ) {
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
            if (section ==1) {
                label.text = @"医院信息";
            }else if (section ==2){
                label.text = @"诊断信息";
            }else if (section ==3){
                label.text = @"护理人信息";
            }else if (section ==4){
                label.text = @"费用信息";
            }else if (section ==5){
                label.text = @"影像资料";
            }else if (section ==6){
                label.text = @"其他信息";
            }
            if (section ==1) {
                if (self.infoModel.hosArray.count>0) {
                }else{
                    return nil;
                }
            }else if (section ==2) {
                if (self.infoModel.diaArray.count>0) {
                }else{
                    return nil;
                }
            }else if (section ==3) {
                if (self.infoModel.carePeopleArray.count>0) {
                }else{
                    return nil;
                }
            }else if (section ==4) {
                if (self.infoModel.feePass.length>0) {
                }else{
                    return nil;
                }
            }else if (section ==5) {
                if (self.infoModel.imageArray.count>0) {
                }else{
                    return nil;
                }
            }else if (section ==6) {
                if (self.infoModel.remark.length>0 || self.infoModel.finishFlag) {
                }else{
                    return nil;
                }
            }
        }else if ([self.taskModel.taskType isEqual:@"02"]){
            NSDictionary *dic = self.dataArray[section];
            if ([dic.allKeys.firstObject isEqual:@"section1"]) {
                label.text = @"就业信息";
            }else if ([dic.allKeys.firstObject isEqual:@"section2"]) {
                label.text = @"联系人";
            }else if ([dic.allKeys.firstObject isEqual:@"section3"]) {
                label.text = @"影像资料";
            }else if ([dic.allKeys.firstObject isEqual:@"section4"]) {
                label.text = @"其他信息";
            }
        }else if ([self.taskModel.taskType isEqual:@"03"]){
             NSDictionary *dic = self.dataArray[section];
            if ([dic.allKeys.firstObject isEqual:@"section1"]) {
                label.text = @"就业信息";
            }else if ([dic.allKeys.firstObject isEqual:@"section2"]) {
                label.text = @"误工信息";
            }else if ([dic.allKeys.firstObject isEqual:@"section3"]) {
                label.text = @"联系人";
            }else if ([dic.allKeys.firstObject isEqual:@"section4"]) {
                label.text = @"影像资料";
            }else if ([dic.allKeys.firstObject isEqual:@"section5"]) {
                label.text = @"其他信息";
            }
            
        }else if ([self.taskModel.taskType isEqual:@"04"]){
            NSDictionary *dic = self.dataArray[section];
            if ([dic.allKeys.firstObject isEqual:@"section1"]) {
                label.text = @"户籍信息";
            }else if ([dic.allKeys.firstObject isEqual:@"section2"]) {
                label.text = @"家庭成员信息";
            }else if ([dic.allKeys.firstObject isEqual:@"section3"]) {
                label.text = @"居住地信息";
            }else if ([dic.allKeys.firstObject isEqual:@"section4"]) {
                label.text = @"被询问人信息";
            }else if ([dic.allKeys.firstObject isEqual:@"section5"]) {
                label.text = @"影像资料";
            }else if ([dic.allKeys.firstObject isEqual:@"section6"]) {
                label.text = @"其他信息";
            }
        }else if ([self.taskModel.taskType isEqual:@"05"]){
            NSDictionary *dic = self.dataArray[section];
            if ([dic.allKeys.firstObject isEqual:@"section1"]) {
                label.text = @"被扶养人信息";
            }else if ([dic.allKeys.firstObject isEqual:@"section2"]) {
                label.text = @"赔偿信息";
            }else if ([dic.allKeys.firstObject isEqual:@"section3"]) {
                label.text = @"影像资料";
            }else if ([dic.allKeys.firstObject isEqual:@"section4"]) {
                label.text = @"其他信息";
            }
        }else if ([self.taskModel.taskType isEqual:@"06"]){
            NSDictionary *dic = self.dataArray[section];
            if ([dic.allKeys.firstObject isEqual:@"section1"]) {
                label.text = @"死亡信息";
            }else if ([dic.allKeys.firstObject isEqual:@"section2"]) {
                label.text = @"影像资料";
            }else if ([dic.allKeys.firstObject isEqual:@"section3"]) {
                label.text = @"其他信息";
            }
        }else if ([self.taskModel.taskType isEqual:@"08"]){
            NSDictionary *dic = self.dataArray[section];
            if ([dic.allKeys.firstObject isEqual:@"section1"]) {
                label.text = @"鉴定机构信息";
            }else if ([dic.allKeys.firstObject isEqual:@"section2"]) {
                label.text = @"伤残等级";
            }else if ([dic.allKeys.firstObject isEqual:@"section3"]) {
                label.text = @"影像资料";
            }else if ([dic.allKeys.firstObject isEqual:@"section4"]) {
                label.text = @"其他信息";
            }
        }else if ([self.taskModel.taskType isEqual:@"09"] ||[self.taskModel.taskType isEqual:@"10"]) {
            if (section ==1) {
                if ([self.taskModel.taskType isEqual:@"09"]) {
                    label.text = @"事故地址信息";
                }else{
                    label.text = @"事故处理人信息";
                }
            }else if (section ==2){
                label.text = @"联系人";
            }else if (section ==3){
                label.text = @"影像资料";
            }else if (section ==4){
                label.text = @"其他信息";
            }
            if (section ==1) {
                if ([self.taskModel.taskType isEqual:@"09" ]) {
                    if (self.infoModel.address.length>0 || self.infoModel.accidentDate.length>0 ||self.infoModel.detailInfo.length>0) {
                    }else{
                        return nil;
                    }
                }else{
                    if (self.infoModel.dealName.length>0 || self.infoModel.dealDate.length>0 ||self.infoModel.dealResult.length>0) {
                    }else{
                        return nil;
                    }
                }
            }else if (section ==2) {
                if (self.infoModel.contactPersonArray.count>0) {
                }else{
                    return nil;
                }
            }else if (section ==3) {
                if (self.infoModel.imageArray.count>0) {
                }else{
                    return nil;
                }
            }else if (section ==4) {
                if (self.infoModel.remark.length>0 || self.infoModel.finishFlag) {
                }else{
                    return nil;
                }
            }
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
        if ([self.taskModel.taskType isEqual:@"01"]){
            if (section ==1) {
                if (self.infoModel.hosArray.count>0) {
                    return 10;
                }else{
                    return 0.01;
                }
            }else if (section ==2) {
                if (self.infoModel.diaArray.count>0) {
                    return 10;
                }else{
                    return 0.01;
                }
            }else if (section ==3) {
                if (self.infoModel.carePeopleArray.count>0) {
                    return 10;
                }else{
                    return 0.01;
                }
            }else if (section ==4) {
                if (self.infoModel.feePass.length>0) {
                    return 10;
                }else{
                    return 0.01;
                }
            }else if (section ==5) {
                if (self.infoModel.imageArray.count>0) {
                    return 10;
                }else{
                    return 0.01;
                }
            }else if (section ==6) {
                if (self.infoModel.remark.length>0||self.infoModel.finishFlag) {
                    return 10;
                }else{
                    return 0.01;
                }
            }
        }else if ([self.taskModel.taskType isEqual:@"09" ]||[self.taskModel.taskType isEqual:@"10"]){
            if (section ==1) {
                if ([self.taskModel.taskType isEqual:@"09" ]) {
                    if (self.infoModel.address.length>0 || self.infoModel.accidentDate.length>0 ||self.infoModel.detailInfo.length>0) {
                        return 10;
                    }else{
                        return 0.01;
                    }
                }else{
                    if (self.infoModel.dealName.length>0 || self.infoModel.dealDate.length>0 ||self.infoModel.dealResult.length>0) {
                        return 10;
                    }else{
                        return 0.01;
                    }
                }
            }else if (section ==2) {
                if (self.infoModel.contactPersonArray.count>0) {
                    return 10;
                }else{
                    return 0.01;
                }
            }else if (section ==3) {
                if (self.infoModel.imageArray.count>0) {
                    return 10;
                }else{
                    return 0.01;
                }
            }else if (section ==4) {
                if (self.infoModel.remark.length>0 || self.infoModel.finishFlag) {
                    return 10;
                }else{
                    return 0.01;
                }
            }
        }else{
            return 10;
        }
        return 0;
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
        [vc setSaveInfoBlock:^(EditInfoModel *infoModel) {
            self.infoModel = infoModel;
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"02"]){
        IncomeViewController *vc = [[IncomeViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [vc setSaveInfoBlock:^(EditInfoModel *infoModel) {
            self.infoModel = infoModel;
            [self getData];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"03"]){
        DelayViewController *vc = [[DelayViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [vc setSaveInfoBlock:^(EditInfoModel *infoModel) {
            self.infoModel = infoModel;
            [self getData];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"04"]){
        FamilyRegisterViewController *vc = [[FamilyRegisterViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [vc setSaveInfoBlock:^(EditInfoModel *infoModel) {
            self.infoModel = infoModel;
            [self getData];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"05"]){
        UpbringViewController *vc = [[UpbringViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [vc setSaveInfoBlock:^(EditInfoModel *infoModel) {
            self.infoModel = infoModel;
            [self getData];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"06"]){
        DeathInfoViewController *vc = [[DeathInfoViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [vc setSaveInfoBlock:^(EditInfoModel *infoModel) {
            self.infoModel = infoModel;
            [self getData];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"08"]){
        DisabilityViewController *vc = [[DisabilityViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [vc setSaveInfoBlock:^(EditInfoModel *infoModel) {
            self.infoModel = infoModel;
            [self getData];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    } if ([self.taskModel.taskType isEqual:@"09"]) {
        EditInfoViewController *vc = [[EditInfoViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [vc setSaveInfoBlock:^(EditInfoModel *infoModel) {
            self.infoModel = infoModel;
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.taskModel.taskType isEqual:@"10"]){
        EditDealInfoViewController *vc = [[EditDealInfoViewController alloc]init];
        vc.claimModel = self.claimModel;
        vc.taskModel = self.taskModel;
        [vc setSaveInfoBlock:^(EditInfoModel *infoModel) {
            self.infoModel = infoModel;
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)changeSeg:(UISegmentedControl *)seg{
    self.selectIndex = seg.selectedSegmentIndex;
    [UIView animateWithDuration:0.5 animations:^{
        self.buttonDown.frame = CGRectMake(DeviceSize.width/2*self.selectIndex, self.seg.bottom, DeviceSize.width/2, 3) ;
    }];
    if (self.selectIndex ==0) {
        [self.view addSubview:self.btnEdit];
    }else{
        [self.btnEdit removeFromSuperview];
    }
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

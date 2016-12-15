//
//  FamilyRegisterViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/16.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "FamilyRegisterViewController.h"
#import "EditInfoModel.h"
#import "DealNameTableViewCell.h"
#import "AccidentTimeTableViewCell.h"
#import "PersonalInformationTableViewCell3.h"
#import "AccidentAddressTableViewCell.h"
#import "PictureTableViewCell.h"
#import "ShowPictureViewController.h"
#import "AccidentAddressViewController.h"
#import "SelectTradeViewController.h"
#import "SelectItemViewController.h"
#import "SelectDefiniteCityViewController.h"
#import "InsiderViewController.h"
#import "ContactPeopleModel.h"
@interface FamilyRegisterViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
//选择时间
@property (nonatomic,strong)UIView *containerView;
@property (nonatomic,strong)UIDatePicker *pickView;
@property (nonatomic,strong)NSDateFormatter *formatter;
//添加的询问人数组
@property (nonatomic,strong)NSMutableArray *askPeopleArray;
@property (nonatomic,strong)UIButton *btnCommit;
@property (nonatomic,strong)UIButton *btnSave;
//本页面信息model
@property (nonatomic,strong)EditInfoModel *infoModel;
//未上传图片数组 （上传判断使用）
@property (nonatomic,strong)NSMutableArray *unUploadImageArray;
@end

@implementation FamilyRegisterViewController
{
    UIAlertController *myActionSheet;
}
- (void)loadView
{
    [super loadView];
    //  根据屏幕的高度自动计算弹出键盘是否试视图控制器是否向上滚动
    self.view = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceSize.width, DeviceSize.height - 64-54)];
    [(TPKeyboardAvoidingScrollView *)self.view setContentSize:CGSizeMake(DeviceSize.width,  DeviceSize.height - 64-54)];
    [self getLocalData];
}
-(void)getLocalData{
    NSArray *arr =[CommUtil readDataWithFileName:localSelectArry];
    for (SelectList *model in arr) {
        NSString *str = [NSString stringWithFormat:@"%@,%@",model.typeCode,model.value];
        NSLog(@"%@",str);
    }
    self.infoModel =[CommUtil readDataWithFileName:[NSString stringWithFormat:@"%@%@",self.taskModel.taskNo,self.taskModel.taskType]];
    if (self.infoModel.contactPersonArray.count>0) {
        [self.askPeopleArray addObjectsFromArray:self.infoModel.contactPersonArray];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.top = 10;
    self.tableView.height = DeviceSize.height-self.tableView.top-64-54;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"保存"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.bottom, DeviceSize.width, 54)];
    bottomView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    [bottomView addSubview:self.btnCommit];
    [bottomView addSubview:self.btnSave];
    [self.view addSubview:bottomView];
    [self setUpForDismissKeyboard];
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if(section == 1){
        return 4;
    }else if(section == 2){
        return 4;
    }else if(section == 3){
        return self.askPeopleArray.count;
    }else if(section == 4){
        return 1;
    }else{
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3){
        return 44;
    }else{
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 44)];
        vc.backgroundColor = [UIColor colorWithHexString:Colorwhite];
//        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(15, 0, DeviceSize.width-30, 1)];
//        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
//        [vc addSubview:line];
        UILabel *lblContact = [[UILabel alloc]initWithFrame:CGRectMake(15, 1, 100, 41)];
        lblContact.text = @"被询问人";
        lblContact.backgroundColor =[UIColor colorWithHexString:Colorwhite];
        lblContact.textColor = [UIColor colorWithHexString:@"#666666"];
        lblContact.font = [UIFont systemFontOfSize:15];
        [vc addSubview:lblContact];
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAdd setImage:[UIImage imageNamed:@"15-添加电话"] forState:UIControlStateNormal];
        [btnAdd setImage:[UIImage imageNamed:@"15-1"] forState:UIControlStateHighlighted];
        btnAdd.frame = CGRectMake(DeviceSize.width-38, 14.5, 13, 13);
        [btnAdd addTarget:self action:@selector(addContact) forControlEvents:UIControlEventTouchUpInside];
        [vc addSubview:btnAdd];
        return vc;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(void)addContact{
    InsiderViewController *vc = [[InsiderViewController alloc]init];
    [vc setSaveInsiderBlock:^(NSMutableArray *insiderArray) {
        [self.askPeopleArray addObjectsFromArray:insiderArray];
        self.infoModel.insiderPersonArray = [NSArray arrayWithArray:self.askPeopleArray];
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 1&&indexPath.row ==2)||(indexPath.section == 1&&indexPath.row ==3)||(indexPath.section == 2&&indexPath.row ==3)) {
        DealNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealNameCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DealNameTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        if ((indexPath.section == 1&&indexPath.row ==2)) {
            cell.lblTitle.text = @"子女人数";
            cell.txtName.tag = 5001;
            if (self.infoModel.sonCount.length>0) {
                cell.txtName.text = self.infoModel.sonCount;
            }
        }else if ((indexPath.section == 1&&indexPath.row ==3)){
            cell.lblTitle.text = @"姊妹人数";
            cell.txtName.tag = 5002;
            if (self.infoModel.bratherCount.length>0) {
                cell.txtName.text = self.infoModel.bratherCount;
            }
        }else{
            cell.lblTitle.text = @"居住年限";
            cell.txtName.tag = 5003;
            if (self.infoModel.liveStay.length>0) {
                cell.txtName.text = self.infoModel.liveStay;
            }
        }
        cell.txtName.keyboardType = UIKeyboardTypeNumberPad;
        [cell.txtName addTarget:self action:@selector(txtChange:) forControlEvents:UIControlEventEditingChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        return cell;
    }else if ((indexPath.section ==2 &&indexPath.row ==1)||(indexPath.section ==2&&indexPath.row ==2)){
        AccidentTimeTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"AccidentTimeTableViewCell" owner:nil options:nil]firstObject];
        if (indexPath.section ==2 &&indexPath.row ==1){
            cell.lblTitle.text = @"居住开始时间";
            cell.btnTime.tag =3000;
            if (self.infoModel.liveStartDate.length>0) {
                [cell.btnTime setTitle:self.infoModel.liveStartDate forState:UIControlStateNormal];
            }
        }else if (indexPath.section ==2 &&indexPath.row ==2){
            cell.lblTitle.text = @"居住结束时间";
            cell.btnTime.tag =3001;
            if (self.infoModel.liveEndDate.length>0) {
                [cell.btnTime setTitle:self.infoModel.liveEndDate forState:UIControlStateNormal];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btnTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.section ==3){
        ContactPeopleModel *model = self.askPeopleArray[indexPath.row];
        PersonalInformationTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInformationCell3"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PersonalInformationTableViewCell3" owner:self options:nil];
            if (nib.count > 0) {
                cell = nib.firstObject;
            }
        }
        cell.labelLeft.text = model.name;
        cell.labelRight.text = model.phone;
        cell.labelLeft.textColor = [UIColor colorWithHexString:Colorblack];
        cell.labelRight.textColor = [UIColor colorWithHexString:Colorgray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section ==2 &&indexPath.row ==0){
        AccidentAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentAddressCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AccidentAddressTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.txtDetail.delegate =self;
        cell.txtDetail.tag = 1001;
        if (self.infoModel.houseAddress.length>0) {
            cell.txtDetail.text =self.infoModel.houseAddress;
        }
        if (cell.txtDetail.text.length ==0) {
            cell.lblPlaceHolder.hidden = NO;
        }else{
            cell.lblPlaceHolder.hidden = YES;
        }
        WeakSelf(FamilyRegisterViewController);
        __weak AccidentAddressTableViewCell *weakCell = cell;
        [cell setBtnClickBlock:^{
            AccidentAddressViewController *vc = [[AccidentAddressViewController alloc]init];
            [vc setSelectAddressBlock:^(NSString *address) {
                [weakCell configCellWithAddress:address];
                self.infoModel.houseAddress = address;
                [self.tableView reloadData];
            }];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        cell.lblTitle.text = @"居住地址";
        [cell.lblLine removeFromSuperview];
        return cell;
    }else if (indexPath.section ==4){
        PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PictureTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        [cell.lblLine removeFromSuperview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //取出model里所有图片
        NSMutableArray *array = [NSMutableArray array];
        for (imageModel *model in self.infoModel.imageArray) {
            [array addObject:model.image];
        }
        [cell configImgWithImgArray:array];
        [cell setBtnSelectBlock:^(UIButton *btn) {
            if (btn.tag-2000 == self.infoModel.imageArray.count) {
                [self openMenu];
            }else{
                [self showPictureWithIndex:btn.tag-2000];
            }
        }];
        return cell;
    }else if (indexPath.section ==5 &&indexPath.row ==1){
        AccidentAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentAddressCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AccidentAddressTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.txtDetail.delegate =self;
        cell.txtDetail.tag = 1002;
        cell.lblPlaceHolder.hidden = YES;
        cell.lblTitle.text = @"备注信息";
        [cell.btnMap removeFromSuperview];
        if (self.infoModel.remark.length>0) {
            cell.txtDetail.text =self.infoModel.remark;
        }
        return cell;
    }else if ((indexPath.section ==0 &&indexPath.row <3)||(indexPath.section ==1 &&indexPath.row <2)||(indexPath.section ==5 &&indexPath.row ==0)){
        AccidentTimeTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"AccidentTimeTableViewCell" owner:nil options:nil]firstObject];
        if (indexPath.section ==0 &&indexPath.row ==0){
            cell.lblTitle.text = @"户籍地";
            cell.lblLine.backgroundColor = [UIColor colorWithHexString:Colorwhite];
            CityModel *model = self.infoModel.household;
            if (model.name.length>0) {
                [cell.btnTime setTitle:model.name forState:UIControlStateNormal];
            }
        }else if (indexPath.section ==0 &&indexPath.row ==1){
            cell.lblTitle.text = @"户籍类型";
            SelectList *model = self.infoModel.householdType;
            if (model.value.length>0) {
                [cell.btnTime setTitle:model.value forState:UIControlStateNormal];
            }

        }else if (indexPath.section ==1 &&indexPath.row ==0){
            cell.lblTitle.text = @"父亲状况";
            [cell.lblLine removeFromSuperview];
            ItemTypeModel *model = self.infoModel.fatherExt;
            if (model.title.length>0) {
                [cell.btnTime setTitle:model.title forState:UIControlStateNormal];
            }
        }else if (indexPath.section ==1 &&indexPath.row ==1){
            cell.lblTitle.text = @"母亲状况";
            ItemTypeModel *model = self.infoModel.matherExt;
            if (model.title.length>0) {
                [cell.btnTime setTitle:model.title forState:UIControlStateNormal];
            }
        }else if (indexPath.section ==0 &&indexPath.row ==2){
            cell.lblTitle.text = @"户籍地居住";
            ItemTypeModel *model = self.infoModel.addressBeTrue;
            if (model.title.length>0) {
                [cell.btnTime setTitle:model.title forState:UIControlStateNormal];
            }
        }else if (indexPath.section ==5 &&indexPath.row ==0){
            cell.lblTitle.text = @"完成情况";
            [cell.lblLine removeFromSuperview];
            ItemTypeModel *model = self.infoModel.finishFlag;
            if (model.title.length>0) {
                [cell.btnTime setTitle:model.title forState:UIControlStateNormal];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btnTime.tag = 100+indexPath.section+indexPath.row;
        [cell.btnTime addTarget:self action:@selector(selectState:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        return nil;
    }
}
-(void)selectState:(UIButton *)btn{
    if(btn.tag == 100) {
        SelectDefiniteCityViewController *vc = [[SelectDefiniteCityViewController alloc]init];
        vc.title = @"户籍地";
        [vc setSelectCityBlock:^(CityModel *model) {
            [btn setTitle:model.name forState:UIControlStateNormal];
            self.infoModel.household =model;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 101){
        SelectTradeViewController*vc = [[SelectTradeViewController alloc]init];
        vc.itemName = @"户籍类型";
        NSArray *seletListArray = [CommUtil readDataWithFileName:localSelectArry];
        if (seletListArray.count >0) {
            for (SelectList *model in seletListArray) {
                if ([model.typeCode isEqual:@"D109"]) {
                    [vc.dataArray addObject:model];
                }
            }
        }
        [vc setSelectIdentityBlock:^(SelectList *model) {
            self.infoModel.householdType = model;
            [btn setTitle:model.value forState:UIControlStateNormal];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 102){
        SelectItemViewController *vc = [[SelectItemViewController alloc]init];
        vc.itemName = @"父亲";
        LocalDataModel *model = [LocalDataModel shareInstance];
        vc.dataArray = [NSMutableArray arrayWithArray:model.parentStateArray];
        [vc setSelectItemBlock:^(ItemTypeModel *model) {
            [btn setTitle:model.title forState:UIControlStateNormal];
            self.infoModel.fatherExt = model;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 103){
        SelectItemViewController *vc = [[SelectItemViewController alloc]init];
        vc.itemName = @"母亲";
        LocalDataModel *model = [LocalDataModel shareInstance];
        vc.dataArray = [NSMutableArray arrayWithArray:model.parentStateArray];
        [vc setSelectItemBlock:^(ItemTypeModel *model) {
            [btn setTitle:model.title forState:UIControlStateNormal];
            self.infoModel.matherExt = model;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 106){
        SelectItemViewController *vc = [[SelectItemViewController alloc]init];
        vc.itemName = @"户籍地居住";
        LocalDataModel *model = [LocalDataModel shareInstance];
        vc.dataArray = [NSMutableArray arrayWithArray:model.boolArray];
        [vc setSelectItemBlock:^(ItemTypeModel *model) {
            [btn setTitle:model.title forState:UIControlStateNormal];
            self.infoModel.addressBeTrue = model;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 104){
        SelectItemViewController *vc = [[SelectItemViewController alloc]init];
        vc.itemName = @"完成情况";
        LocalDataModel *model = [LocalDataModel shareInstance];
        vc.dataArray = [NSMutableArray arrayWithArray:model.finishStateArray];
        [vc setSelectItemBlock:^(ItemTypeModel *model) {
            [btn setTitle:model.title forState:UIControlStateNormal];
            self.infoModel.finishFlag = model;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)selectTime:(UIButton *)btn{
    self.tableView.userInteractionEnabled = NO;
    self.containerView.tag =btn.tag;
    [self.view addSubview:self.containerView];
    [UIView animateWithDuration:0.5 animations:^{
        _containerView.frame = CGRectMake(0, self.view.bottom - 176-64, DeviceSize.width, 176);
    }];
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
    UIView *vc = btn.superview;
    AccidentTimeTableViewCell *cell;
    if (vc.tag == 3000) {
        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
        self.infoModel.liveStartDate =[_formatter stringFromDate:_pickView.date];
    }else{
        cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
        self.infoModel.liveEndDate =[_formatter stringFromDate:_pickView.date];
    }
    
    [cell.btnTime setTitle:[_formatter stringFromDate:_pickView.date] forState:UIControlStateNormal];
    [cell.btnTime setTitleColor:[UIColor colorWithHexString:Colorblack] forState:UIControlStateNormal];
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
- (void)setSelectDate:(NSString *)selectDate {
    [_pickView setDate:[self.formatter dateFromString:selectDate] animated:YES];
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    [CommUtil saveData:self.infoModel andSaveFileName:[NSString stringWithFormat:@"%@%@",self.taskModel.taskNo,self.taskModel.taskType]];
    if (self.saveInfoBlock) {
        self.saveInfoBlock(self.infoModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textViewDidChange:(UITextView *)textView{
    AccidentAddressTableViewCell *cell;
    if(textView.tag == 1001){
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        self.infoModel.houseAddress = textView.text;
        if (textView.text.length>0) {
            cell.lblPlaceHolder.hidden = YES;
        }else{
            if (textView.tag != 1002) {
                cell.lblPlaceHolder.hidden = NO;
            }
        }
    }else if (textView.tag == 1002){
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:5]];
        self.infoModel.remark = textView.text;
    }
   
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelAction:nil];
}
-(NSString *)title{
    return @"编辑";
}
-(NSMutableArray *)askPeopleArray{
    if (!_askPeopleArray) {
        _askPeopleArray = [NSMutableArray array];
    }
    return _askPeopleArray;
}
//开始拍照
-(void)openMenu
{
    //在这里呼出下方菜单按钮项
    myActionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LocalPhoto];
    }];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [myActionSheet addAction:picture];
    [myActionSheet addAction:takePhoto];
    [myActionSheet addAction:cancel];
    [self presentViewController:myActionSheet animated:YES completion:nil];
}

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        CGSize imgSize = CGSizeMake(320*2, 240*2);
        if(image.imageOrientation == UIImageOrientationLeft || image.imageOrientation == UIImageOrientationRight){
            imgSize = CGSizeMake(240*2, 320*2);
        }else if(image.imageOrientation == UIImageOrientationUp || image.imageOrientation == UIImageOrientationDown){
            imgSize = CGSizeMake(320*2, 240*2);
        }
        image = [image imageZoomToSize_Ext:imgSize];
        NSDate *date = [NSDate date];
        NSString *dateStr = [NSDate stringWithDate:date format:@"yyyy-MM-dd_HHmmss"];
        NSString *picName = [NSString stringWithFormat:@"%@.jpg",dateStr];
        imageModel *imgModel = [[imageModel alloc]init];
        imgModel.imgName = picName;
        imgModel.image = image;
        imgModel.isUpload = NO;
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSString *imgeBase64 = [imageData base64EncodedStringWithOptions:0];
        imgModel.imgBase64 = imgeBase64;
        [self.infoModel.imageArray addObject:imgModel];
    }
    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(UIButton *)btnCommit{
    if (!_btnCommit) {
        _btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCommit.frame = CGRectMake(15,7, 165, 40);
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
    NSString *userCode = @"0131002498";
    NSMutableDictionary *uploadDic = [NSMutableDictionary dictionary];
    [uploadDic setObject:self.taskModel.taskNo forKey:@"taskNo"];
    [uploadDic setObject:userCode forKey:@"userCode"];
    ItemTypeModel *finishModel = self.infoModel.finishFlag;
    [uploadDic setObject:finishModel.value forKey:@"finishFlag"];
    [uploadDic setObject:self.infoModel.remark forKey:@"remark"];
    [uploadDic setObject:self.infoModel.houseAddress forKey:@"address"];
    CityModel *cityModel = self.infoModel.household;
    [uploadDic setObject:cityModel.name forKey:@"household"];
    SelectList *typeModel = self.infoModel.householdType;
    [uploadDic setObject:typeModel.value forKey:@"householdType"];
    ItemTypeModel *fatherModel = self.infoModel.fatherExt;
    [uploadDic setObject:fatherModel.value forKey:@"fatherExt"];
    ItemTypeModel *motherModel = self.infoModel.matherExt;
    [uploadDic setObject:motherModel.value forKey:@"matherExt"];
    [uploadDic setInteger:self.infoModel.sonCount.integerValue forKey:@"sonCount"];
    [uploadDic setInteger:self.infoModel.bratherCount.integerValue forKey:@"bratherCount"];
    ItemTypeModel *addressBeTrueModel = self.infoModel.addressBeTrue;
    [uploadDic setObject:addressBeTrueModel.value forKey:@"addressBeTrue"];
    [uploadDic setObject:self.infoModel.liveStartDate forKey:@"liveStartDate"];
    [uploadDic setObject:self.infoModel.liveEndDate forKey:@"liveEndDate"];
    if (self.infoModel.insiderPersonArray.count >0) {
        ContactPeopleModel *model = self.infoModel.insiderPersonArray.firstObject;
        [uploadDic setObject:model.name forKey:@"insider"];
        [uploadDic setObject:model.phone forKey:@"insiderPhone"];
        SelectList *idModel = model.insiderIdentity;
        [uploadDic setObject:idModel.value forKey:@"insiderIdentity"];
    }
    if (self.infoModel.imageArray.count>0) {
        self.unUploadImageArray =self.infoModel.imageArray;
        for (imageModel *model in self.infoModel.imageArray) {
            if (model.isUpload) {
                [self.unUploadImageArray removeObject:model];
            }
        }
    }
    //图片全部上传后开始上传基本信息
    if (self.unUploadImageArray.count>0) {
        [self uploadImage];
    }else{
        WeakSelf(FamilyRegisterViewController);
        [self showHudWaitingView:WaitPrompt];
        [[NetWorkManager shareNetWork]uploadHouseholdInfoWithDataDic:uploadDic andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
            [weakSelf removeMBProgressHudInManaual];
            if ([response.responseCode isEqual:@"1"]) {
                [weakSelf showHudAuto:@"提交成功"];
            }else{
                [weakSelf showHudAuto:@"提交失败"];
            }
        } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
            [weakSelf removeMBProgressHudInManaual];
            [weakSelf showHudAuto:InternetFailerPrompt];
        }];
    }
}
-(void)uploadImage{
    WeakSelf(FamilyRegisterViewController);
    imageModel *uploadImageModel = [self.unUploadImageArray firstObject];
    [self showHudWaitingView:WaitPrompt];
    [[NetWorkManager shareNetWork]uploadImageWithImgName:uploadImageModel.imgName andImgBase64:uploadImageModel.imgBase64 andReportCode:self.taskModel.taskNo andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if ([response.responseCode isEqual:@"1"]) {
            uploadImageModel.isUpload = YES;
            [weakSelf commit];
        }else{
            [weakSelf showHudAuto:@"上传失败"];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf removeMBProgressHudInManaual];
        [weakSelf showHudAuto:InternetFailerPrompt];
    }];
}
-(UIButton *)btnSave{
    if (!_btnSave) {
        _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSave.frame = CGRectMake(DeviceSize.width-29/2-165,7, 165, 40);
        [_btnSave addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [_btnSave setTitle:@"保存" forState:UIControlStateNormal];
        [_btnSave setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
        [_btnSave setTitleColor:[UIColor colorWithHexString:@"#6ca6f2"] forState:UIControlStateHighlighted];
        [_btnSave setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
        _btnSave.layer.masksToBounds = YES;
        _btnSave.layer.cornerRadius = 40*0.16;
    }
    return _btnSave;
}
-(EditInfoModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [[EditInfoModel alloc]init];
    }
    return _infoModel;
}
-(NSMutableArray *)unUploadImageArray{
    if (!_unUploadImageArray) {
        _unUploadImageArray = [NSMutableArray array];
    }
    return _unUploadImageArray;
}
-(void)txtChange:(UITextField *)txt{
    if (txt.tag == 5001) {
        self.infoModel.sonCount =txt.text;
    }else if (txt.tag == 5002){
        self.infoModel.bratherCount =txt.text;
    }else if (txt.tag == 5003){
        self.infoModel.liveStay = txt.text;
    }
    txt.frame = CGRectMake(DeviceSize.width-15-txt.text.length*16, txt.frame.origin.y, txt.text.length*16, txt.frame.size.height);
}
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
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

//
//  AddUpBringViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/22.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "AddUpBringViewController.h"
#import "DealNameTableViewCell.h"
#import "AccidentAddressTableViewCell.h"
#import "AccidentTimeTableViewCell.h"
#import "AccidentAddressViewController.h"
#import "SelectTradeViewController.h"
#import "DeleteBringUpTableViewCell.h"
@interface AddUpBringViewController ()<UITextViewDelegate>
//将保存的联系人数组
@property (nonatomic,strong)NSMutableArray *selectUpBringArray;
//选择生日
@property (nonatomic,strong)UIView *containerView;
@property (nonatomic,strong)UIDatePicker *pickView;
@property (nonatomic,strong)NSDateFormatter *formatter;
@end

@implementation AddUpBringViewController
- (void)loadView
{
    [super loadView];
    //  根据屏幕的高度自动计算弹出键盘是否试视图控制器是否向上滚动
    self.view = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceSize.width, DeviceSize.height - 64-54)];
    [(TPKeyboardAvoidingScrollView *)self.view setContentSize:CGSizeMake(DeviceSize.width,  DeviceSize.height - 64-54)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.top = 14;
    self.tableView.height = DeviceSize.height-14-64-54;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"保存"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UpBringModel *model =[[UpBringModel alloc]init];
    [self.dataArray addObject:model];
    [self addBottomView];
    [self setUpForDismissKeyboard];
}
// Do any additional setup after loading the view.

-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    for (int i=0; i<self.dataArray.count; i++) {
        UpBringModel *model = self.dataArray[i];
        [self.selectUpBringArray addObject:model];
    }
    if (self.addUpBringBlock) {
        self.addUpBringBlock(self.selectUpBringArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceSize.height-54-64, DeviceSize.width, 54)];
    bottomView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(15, 7, DeviceSize.width-30, 40);
    btnAdd.layer.masksToBounds = YES;
    btnAdd.layer.cornerRadius = 40*0.16;
    [btnAdd setTitle:@"+添加被抚养人" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
    [btnAdd setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
    [btnAdd addTarget:self action:@selector(addSection) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnAdd];
    [self.view addSubview:bottomView];
}
-(void)addSection{
    UpBringModel *model =[[UpBringModel alloc]init];
    [self.dataArray addObject:model];
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UpBringModel *model = self.dataArray[indexPath.section];
    if (model.selected &&indexPath.row>0) {
        return 0;
    }else{
        return UITableViewAutomaticDimension;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   if (indexPath.row == 2||indexPath.row == 3||indexPath.row == 4){
        AccidentTimeTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"AccidentTimeTableViewCell" owner:nil options:nil] firstObject];
        if (indexPath.row == 2) {
            cell.lblTitle.text = @"出生日期";
            [cell.btnTime addTarget:self action:@selector(selectBirthday:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnTime.tag = 1000+indexPath.section;
        }else if (indexPath.row ==3){
            cell.lblTitle.text = @"户口性质";
            [cell.btnTime addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnTime.tag = 2000+indexPath.section;
        }else{
            cell.lblTitle.text = @"与受害人关系";
            [cell.btnTime addTarget:self action:@selector(selectRelation:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnTime.tag = 3000+indexPath.section;
        }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       UpBringModel *model =self.dataArray[indexPath.section];
       if (model.selected) {
           cell.hidden = YES;
       }else{
           cell.hidden = NO;
       }
       return cell;
    }else if(indexPath.row == 1||indexPath.row == 5||indexPath.row ==6 ||indexPath.row ==7){
        DealNameTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"DealNameTableViewCell" owner:nil options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        if (indexPath.row == 1){
            cell.lblTitle.text = @"姓名";
            [cell.txtName addTarget:self action:@selector(nameChange:) forControlEvents:UIControlEventEditingChanged];
        }else if (indexPath.row == 5){
            cell.lblTitle.text = @"年龄";
            [cell.txtName addTarget:self action:@selector(ageChange:) forControlEvents:UIControlEventEditingChanged];
        }else if (indexPath.row == 6){
            cell.lblTitle.text = @"抚养年限";
            [cell.txtName addTarget:self action:@selector(yearsChange:) forControlEvents:UIControlEventEditingChanged];
        }else{
            cell.lblTitle.text = @"共同抚养人数";
            [cell.txtName addTarget:self action:@selector(numChange:) forControlEvents:UIControlEventEditingChanged];
        }
        cell.txtName.tag = indexPath.section;
        UpBringModel *model =self.dataArray[indexPath.section];
        if (model.selected) {
            cell.hidden = YES;
        }else{
            cell.hidden = NO;
        }
        return cell;
    }else if (indexPath.row == 8){
        AccidentAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentAddressCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AccidentAddressTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTitle.text = @"常住地址";
        cell.txtDetail.delegate =self;
        cell.txtDetail.tag = 6000+indexPath.section;
        if (cell.txtDetail.text.length ==0) {
            cell.lblPlaceHolder.hidden = NO;
        }else{
            cell.lblPlaceHolder.hidden = YES;
        }
        WeakSelf(AddUpBringViewController);
        __weak AccidentAddressTableViewCell *weakCell = cell;
        [cell setBtnClickBlock:^{
            AccidentAddressViewController *vc = [[AccidentAddressViewController alloc]init];
            [vc setSelectAddressBlock:^(NSString *address) {
                [weakCell configCellWithAddress:address];
                UpBringModel *model = self.dataArray[indexPath.section];
                model.address = address;
                [self.tableView reloadData];
            }];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        UpBringModel *model =self.dataArray[indexPath.section];
        if (model.selected) {
            cell.hidden = YES;
        }else{
            cell.hidden = NO;
        }
        return cell;
    }else{
        DeleteBringUpTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"DeleteBringUpTableViewCell" owner:nil options:nil]firstObject];
        cell.lblBringUp.text = [NSString stringWithFormat:@"被抚养人%lu",indexPath.section+1];
        cell.lineV.backgroundColor = [UIColor colorWithHexString:Colorblue];
        UIImage *image =[UIImage imageNamed:@"16"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [cell.btnDelete setImage:image forState:UIControlStateNormal];
        [cell.btnDelete setImage:[UIImage imageNamed:@"16-1"] forState:UIControlStateHighlighted];
        [cell.btnDelete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDelete.tag = indexPath.section+100;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btnOpen setTitleColor:[UIColor colorWithHexString:Colorblue] forState:UIControlStateNormal];
        cell.btnOpen.titleLabel.font = [UIFont systemFontOfSize:15];
        UpBringModel *model =self.dataArray[indexPath.section];
        if (model.selected) {
            [cell.btnOpen setTitle:@"展开" forState:UIControlStateNormal];
        }else{
            [cell.btnOpen setTitle:@"收回" forState:UIControlStateNormal];
        }
        cell.btnOpen.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.btnOpen.tag = 4000+indexPath.section;
        [cell.btnOpen addTarget:self action:@selector(stateChange:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
-(void)nameChange:(UITextField *)txt{
    UpBringModel *model = self.dataArray[txt.tag];
    model.name = txt.text;
}
-(void)ageChange:(UITextField *)txt{
    UpBringModel *model = self.dataArray[txt.tag];
    model.age= txt.text;
}
-(void)yearsChange:(UITextField *)txt{
    UpBringModel *model = self.dataArray[txt.tag];
    model.years = txt.text;
}
-(void)numChange:(UITextField *)txt{
    UpBringModel *model = self.dataArray[txt.tag];
    model.upBringNum = txt.text;
}
-(void)textViewDidChange:(UITextView *)textView{
    AccidentAddressTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:textView.tag-6000]];
    if (textView.text.length>0) {
        cell.lblPlaceHolder.hidden = YES;
    }else{
        cell.lblPlaceHolder.hidden = NO;
    }
    UpBringModel *model = self.dataArray[textView.tag -6000];
    model.address = textView.text;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    [self.tableView beginUpdates];
    [self.tableView endUpdates];   
}
-(void)stateChange:(UIButton *)btn{
    UpBringModel *model =self.dataArray[btn.tag-4000];
    model.selected = !model.selected;
    [self.tableView reloadData];
}
-(void)selectBirthday:(UIButton *)btn{
    self.tableView.userInteractionEnabled = NO;
    self.containerView.tag = btn.tag-1000;
    [self.view addSubview:self.containerView];
    [UIView animateWithDuration:0.5 animations:^{
        _containerView.frame = CGRectMake(0, self.view.bottom - 176-64, DeviceSize.width, 176);
    }];
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
    UpBringModel *model = self.dataArray[btn.superview.tag];
    AccidentTimeTableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:btn.superview.tag]];
    model.birthday =[_formatter stringFromDate:_pickView.date];
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
-(void)selectType:(UIButton *)btn{
    SelectTradeViewController*vc = [[SelectTradeViewController alloc]init];
    vc.itemName = @"户口性质";
    NSArray *seletListArray = [CommUtil readDataWithFileName:localSelectArry];
    if (seletListArray.count >0) {
        for (SelectList *model in seletListArray) {
            if ([model.typeCode isEqual:@"D109"]) {
                [vc.dataArray addObject:model];
            }
        }
    }
    [vc setSelectIdentityBlock:^(SelectList *model) {
        UpBringModel *upBringModel = self.dataArray[btn.tag-2000];
        upBringModel.householdType = model;
        [btn setTitle:model.value forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)selectRelation:(UIButton *)btn{
    SelectTradeViewController*vc = [[SelectTradeViewController alloc]init];
    vc.itemName = @"与受害人关系";
    NSArray *seletListArray = [CommUtil readDataWithFileName:localSelectArry];
    if (seletListArray.count >0) {
        for (SelectList *model in seletListArray) {
            if ([model.typeCode isEqual:@"D116"]) {
                [vc.dataArray addObject:model];
            }
        }
    }
    [vc setSelectIdentityBlock:^(SelectList *model) {
        UpBringModel *upBringModel = self.dataArray[btn.tag-3000];
        upBringModel.Relation = model;
        [btn setTitle:model.value forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 10)];
    vc.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
    return vc;
}
-(void)delete:(UIButton *)btn{
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:btn.tag-100];
    [self.dataArray removeObjectAtIndex:indexSet.firstIndex];
    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSString *)title{
    return @"添加被抚养人";
}
-(NSMutableArray *)selectUpBringArray{
    if (!_selectUpBringArray) {
        _selectUpBringArray = [NSMutableArray array];
    }
    return _selectUpBringArray;
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

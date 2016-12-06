//
//  MedicalVisitViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/8.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MedicalVisitViewController.h"
#import "EditDealInfoViewController.h"
#import "EditInfoViewController.h"
#import "AccidentTimeTableViewCell.h"
#import "MedicalVisitTableViewCell.h"
#import "PersonalInformationTableViewCell3.h"
#import "PictureTableViewCell.h"
#import "ShowPictureViewController.h"
#import "DealNameTableViewCell.h"
#import "AccidentAddressTableViewCell.h"
#import "SelectHospitalViewController.h"
#import "AddCarePeopleViewController.h"
#import "AddDiagnoseViewController.h"
#import "SearchTableViewCell.h"
#import "DepartmentsModel.h"
#import "CarePeopleModel.h"
#import "DiagnoseDetailModel.h"
#import "SelectItemViewController.h"
@interface MedicalVisitViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic,assign)NSInteger contactNum;
@property (nonatomic,strong)UILabel *placeHolder;
//添加的医院数组
@property (nonatomic,strong)NSMutableArray *hospitalArray;
//添加的诊断数组
@property (nonatomic,strong)NSMutableArray *diagnoseArray;
//添加的护理人数组
@property (nonatomic,strong)NSMutableArray *carePeopleArray;
@property (nonatomic,strong)UIButton *btnCommit;
@property (nonatomic,strong)UIButton *btnSave;
//本页面信息model
@property (nonatomic,strong)EditInfoModel *infoModel;
//未上传图片数组 （上传判断使用）
@property (nonatomic,strong)NSMutableArray *unUploadImageArray;
//tableview 高度
@property(nonatomic,assign)CGFloat heght;
@end

@implementation MedicalVisitViewController
{
    UIAlertController *myActionSheet;
}
- (void)loadView
{
    self.heght = DeviceSize.height;
    [super loadView];
    if (self.isShow) {
        if (self.heght!=0) {
            self.view = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 40, DeviceSize.width-30, self.heght)];
        }else{
            self.view = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 40, DeviceSize.width-30, 1000)];
        }
        self.tableView.scrollEnabled = NO;
        self.tableView.top = 0;
    }else{
        self.view = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceSize.width, DeviceSize.height - 64-54)];
        [(TPKeyboardAvoidingScrollView *)self.view setContentSize:CGSizeMake(DeviceSize.width,  DeviceSize.height - 64-54)];
        self.tableView.top = 10;
    }
    //  根据屏幕的高度自动计算弹出键盘是否试视图控制器是否向上滚动
    [self getLocalData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.heght!=0) {
        self.tableView.height = self.heght;
    }else{
        self.tableView.height = DeviceSize.height-self.tableView.top-64-54;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"保存"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.bottom, DeviceSize.width, 54)];
    bottomView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    [bottomView addSubview:self.btnCommit];
    [bottomView addSubview:self.btnSave];
    [self.view addSubview:bottomView];
    //添加诊断通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addDiagnose:) name:@"Diagnose" object:nil];
    [self setUpForDismissKeyboard];
    // Do any additional setup after loading the view.
}
-(void)getLocalData{
    self.infoModel =[CommUtil readDataWithFileName:[NSString stringWithFormat:@"%@%@",self.taskModel.taskNo,self.taskModel.taskType]];
    if (self.infoModel) {
        self.hospitalArray =self.infoModel.hosArray;
        self.diagnoseArray =self.infoModel.diaArray;
        self.carePeopleArray =self.infoModel.carePeopleArray;
    }
}
-(void)addDiagnose:(NSNotification *)text{
    DiagnoseDetailModel *model = [MTLJSONAdapter modelOfClass:[DiagnoseDetailModel class] fromJSONDictionary:text.userInfo error:NULL];
    [self.diagnoseArray addObject:model];
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.hospitalArray.count;
    }else if(section == 1){
        return self.diagnoseArray.count;
    }else if(section == 2){
        return self.carePeopleArray.count;;
    }else{
        return 4;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section < 3 ) {
        self.heght+=44;
        return 44;
    }else{
        return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==0 &&self.hospitalArray.count>0 && !self.isShow) {
        self.heght+=10;
        return 10;
    }else if (section == 1&&self.diagnoseArray.count>0&&!self.isShow){
        self.heght+=10;
        return 10;
    }else if (section == 2&&self.carePeopleArray.count>0&&!self.isShow){
        self.heght+=10;
        return 10;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section <3) {
        UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
        vc.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        UILabel *lblContact = [[UILabel alloc]initWithFrame:CGRectMake(15, 1, 50, 41)];
        lblContact.textColor = [UIColor colorWithHexString:@"#666666"];
        lblContact.font = [UIFont systemFontOfSize:15];
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(15, 43, self.view.width-30, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [vc addSubview:line];
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!self.isShow) {
            btnAdd.frame = CGRectMake(self.view.width-65, 0, 50, 44);
            [btnAdd setImage:[UIImage imageNamed:@"15-添加电话"] forState:UIControlStateNormal];
            [btnAdd setImage:[UIImage imageNamed:@"15-1"] forState:UIControlStateHighlighted];
            [btnAdd setImageEdgeInsets:UIEdgeInsetsMake(15.5, 26.5, 15.5, 10.5)];
        }
        if (section == 0) {
            lblContact.text = @"医院";
            [btnAdd addTarget:self action:@selector(addHospital) forControlEvents:UIControlEventTouchUpInside];
        }else if (section == 1){
            lblContact.text = @"诊断";
            [btnAdd addTarget:self action:@selector(addDiagnose) forControlEvents:UIControlEventTouchUpInside];
        }else if (section == 2){
            lblContact.text = @"护理人";
            [btnAdd addTarget:self action:@selector(addCarePeople) forControlEvents:UIControlEventTouchUpInside];
        }
        [vc addSubview:lblContact];
        [vc addSubview:btnAdd];
        return vc;
    }else{
        return nil;
    }
}
-(void)addHospital{
    SelectHospitalViewController *vc = [[SelectHospitalViewController alloc]init];
    vc.flag = @"1";
    [vc setSelectBlock:^(HospitalModel *model, NSMutableArray *array) {
        NSDictionary *dic = @{@"Hospital":model,@"department":array};
        [self.hospitalArray removeAllObjects];
        [self.hospitalArray addObject:dic];
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addDiagnose{
    AddDiagnoseViewController *vc = [[AddDiagnoseViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addCarePeople{
    AddCarePeopleViewController *vc = [[AddCarePeopleViewController alloc]init];
    [vc setAddCareBlock:^(NSMutableArray *array) {
        [self.carePeopleArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section <3) {
        MedicalVisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MedicalCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MedicalVisitTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        self.heght+=44;
        if (indexPath.row == 0) {
            [cell.line removeFromSuperview];
        }
        if (indexPath.section == 0) {
            NSDictionary *dic = self.hospitalArray[indexPath.row];
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
        }else if (indexPath.section == 1){
            DiagnoseDetailModel *model = self.diagnoseArray[indexPath.row];
            cell.lblTitle.text = model.itemCnName;
            cell.lblDetail.text = model.way;
            [cell.lblMoney removeFromSuperview];
        }else if (indexPath.section == 2){
            CarePeopleModel *model = self.carePeopleArray[indexPath.row];
            cell.lblTitle.text = model.name;
            SelectList *identityModel =model.identity;
            cell.lblDetail.text =identityModel.value;
            cell.lblMoney.text = [NSString stringWithFormat:@"￥%@",model.cost];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        if (indexPath.row == 0){
            DealNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealNameCell"];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DealNameTableViewCell" owner:nil options:nil];
                if (nib.count>0) {
                    cell = [nib firstObject];
                }
            }
            self.heght+=44;
            cell.lblTitle.text = @"已发生医疗费";
            [cell.lblLine removeFromSuperview];
            if (self.infoModel.feePass) {
                cell.txtName.text = [NSString stringWithFormat:@"%.2f",self.infoModel.feePass];
            }
            [cell.txtName addTarget:self action:@selector(txtChange:) forControlEvents:UIControlEventEditingChanged];
            cell.txtName.delegate =self;
            cell.txtName.keyboardType =UIKeyboardTypeDecimalPad;
            cell.txtName.textAlignment = NSTextAlignmentRight;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
            return cell;
        }else if (indexPath.row ==1){
            PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell"];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PictureTableViewCell" owner:nil options:nil];
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
            [cell configImgWithImgArray:array];
            [cell setBtnSelectBlock:^(UIButton *btn) {
                if (btn.tag-2000 == self.infoModel.imageArray.count) {
                    [self openMenu];
                }else{
                    [self showPictureWithIndex:btn.tag-2000];
                }
            }];
            self.heght+=cell.height;
            return cell;
        }else if (indexPath.row ==2){
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
            cell.txtDetail.text = self.infoModel.remark;
            cell.lblPlaceHolder.hidden = YES;
            cell.lblTitle.text = @"备注信息";
            [cell.btnMap removeFromSuperview];
            self.heght+=cell.height;
            return cell;
        }else{
            AccidentTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AccidentTimeTableViewCell" owner:nil options:nil];
                if (nib.count>0) {
                    cell = [nib firstObject];
                }
            }
            self.heght+=cell.height;
            cell.lblTitle.text = @"完成情况";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.btnTime addTarget:self action:@selector(selectState:) forControlEvents:UIControlEventTouchUpInside];
            ItemTypeModel *model = self.infoModel.finishFlag;
            [cell.btnTime setTitle:model.title forState:UIControlStateNormal];
            return cell;
        }
    }
}
//设置可删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //1.更新数据
        if (indexPath.section == 0) {
            [self.hospitalArray removeObjectAtIndex:indexPath.row];//tableview数据源
        }else if (indexPath.section ==1){
            [self.diagnoseArray removeObjectAtIndex:indexPath.row];//tableview数据源
        }else if (indexPath.section ==2){
            [self.carePeopleArray removeObjectAtIndex:indexPath.row];//tableview数据源
        };
        //2.更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor colorWithHexString:@"f90d00"];
    //添加一个编辑按钮
    UITableViewRowAction *editRowAction =[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
    }];
    //编辑按钮颜色
    editRowAction.backgroundColor = [UIColor colorWithHexString:@"c7c7cc"];
    //将设置好的按钮方到数组中返回
    if (indexPath.section == 2) {
        return @[deleteAction,editRowAction];
    }else{
        return @[deleteAction];
    }
}
//滑动删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableView.isEditing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(void)selectState:(UIButton *)btn{
    SelectItemViewController *vc = [[SelectItemViewController alloc]init];
    vc.itemName = @"完成情况";
    LocalDataModel *model = [LocalDataModel shareInstance];
    vc.dataArray = [NSMutableArray arrayWithArray:model.finishStateArray];
    [vc setSelectItemBlock:^(ItemTypeModel *model) {
        self.infoModel.finishFlag = model;
        [btn setTitle:model.title forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:YES];
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

-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    self.infoModel.hosArray = self.hospitalArray;
    self.infoModel.diaArray = self.diagnoseArray;
    self.infoModel.carePeopleArray = self.carePeopleArray;
    [CommUtil saveData:self.infoModel andSaveFileName:[NSString stringWithFormat:@"%@%@",self.taskModel.taskNo,self.taskModel.taskType]];
    if (self.saveInfoBlock) {
        self.saveInfoBlock(self.infoModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textViewDidChange:(UITextView *)textView{
    AccidentAddressTableViewCell *cell;
    self.infoModel.remark = textView.text;
    if (textView.text.length>0) {
        cell.lblPlaceHolder.hidden = YES;
    }else{
        if (textView.tag != 1002) {
            cell.lblPlaceHolder.hidden = NO;
        }
    }
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
-(NSString *)title{
    return @"编辑";
}
-(NSMutableArray *)carePeopleArray{
    if (!_carePeopleArray) {
        _carePeopleArray = [NSMutableArray array];
    }
    return _carePeopleArray;
}
-(NSMutableArray *)hospitalArray{
    if (!_hospitalArray) {
        _hospitalArray = [NSMutableArray array];
    }
    return _hospitalArray;
}
-(NSMutableArray *)diagnoseArray{
    if (!_diagnoseArray) {
        _diagnoseArray = [NSMutableArray array];
    }
    return _diagnoseArray;
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
    NSMutableDictionary *uploadDic = [NSMutableDictionary dictionary];
    NSString *userCode = @"0131002498";
    [uploadDic setObject:userCode forKey:@"userCode"];
    if (self.hospitalArray.count>0) {
        NSDictionary *selectHosDic = self.hospitalArray.firstObject;
        HospitalModel *hospitalModel = selectHosDic[@"Hospital"];
        NSMutableString *departmentString = [NSMutableString string];
        for (DepartmentsModel *departmentsModel in selectHosDic[@"department"]) {
            if (departmentString.length>0) {
                [departmentString appendString:@","];
            }
            [departmentString appendFormat:@"%@",departmentsModel.key];
        }
        NSDictionary *hospital = @{@"hospitalId":hospitalModel.hospitalId,@"hospitalProperty":hospitalModel.hospitalProperty,@"hospitalDepartment":departmentString};
        [uploadDic setObject:hospital forKey:@"hospital"];
    }
    if (self.diagnoseArray.count>0) {
        NSMutableArray *disabList =[NSMutableArray array];
        for (DiagnoseDetailModel *model in self.diagnoseArray) {
            NSString * flag;
            if ([model.way isEqual:@"保守治疗"]) {
                flag = @"0";
            }else if ([model.way isEqual:@"手术治疗"]){
                flag = @"1";
            }
            NSDictionary *dic = @{@"id":model.Id,@"disabilityCode":model.itemCode,@"disabilityDescr":model.itemCnName,@"operation":flag};
            [disabList addObject:dic];
        }
        [uploadDic setObject:disabList forKey:@"disabList"];
    }
    if (self.carePeopleArray.count>0) {
        NSMutableArray *nurseList =[NSMutableArray array];
        for (CarePeopleModel *model in self.carePeopleArray) {
            SelectList *identityModel =model.identity;
            NSDictionary *dic = @{@"nurseName":model.name,@"nurseIndustryCode":identityModel.key,@"nurseIndustryName":identityModel.value,@"nurseDailyReceipts":model.cost,@"nurseDayCount":model.days};
            [nurseList addObject:dic];
        }
        [uploadDic setObject:nurseList forKey:@"nurseList"];
    }
    [uploadDic setObject:self.taskModel.taskNo forKey:@"taskNo"];
    [uploadDic setFloat:self.infoModel.feePass forKey:@"feePass"];
    ItemTypeModel *model =self.infoModel.finishFlag;
    [uploadDic setObject:model.value forKey:@"finishFlag"];
    [uploadDic setObject:self.infoModel.remark forKey:@"remark"];
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
        WeakSelf(MedicalVisitViewController);
        [self showHudWaitingView:WaitPrompt];
        [[NetWorkManager shareNetWork]uploadMedicalWithDataDic:uploadDic andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response){
            [weakSelf removeMBProgressHudInManaual];
            if ([response.responseCode isEqual:@"1"]) {
                [weakSelf showHudAuto:@"提交成功"];
            }else{
                [weakSelf showHudAuto:@"提交失败"];
            }
        } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
            [self removeMBProgressHudInManaual];
            [self showHudAuto:InternetFailerPrompt];
        }];
        
    }
}
-(void)uploadImage{
    WeakSelf(MedicalVisitViewController);
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
    self.infoModel.feePass =[txt.text floatValue];
}
//设置文本框只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //如果是限制只能输入数字的文本框
    return [self validateNumber:string];
}
- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"addDiagnose" object:nil];
}
@end

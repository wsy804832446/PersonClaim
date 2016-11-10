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
#import "AddContactPersonViewController.h"
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
@interface MedicalVisitViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic,assign)NSInteger contactNum;
@property (nonatomic,strong)UILabel *placeHolder;
//添加的联系人数组
@property (nonatomic,strong)NSMutableArray *contactPeopleArray;
@property (nonatomic,strong)UIButton *btnCommit;
@property (nonatomic,strong)UIButton *btnSave;
//本页面信息model
@property (nonatomic,strong)EditInfoModel *infoModel;
//未上传图片数组 （上传判断使用）
@property (nonatomic,strong)NSMutableArray *unUploadImageArray;

@end

@implementation MedicalVisitViewController
{
    UIAlertController *myActionSheet;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.VCstyle = UITableViewStylePlain;
    self.tableView.top = 10;
    self.tableView.height = DeviceSize.height-self.tableView.top-64-54;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"保存"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.bottom, DeviceSize.width, 54)];
    bottomView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    [bottomView addSubview:self.btnCommit];
    [bottomView addSubview:self.btnSave];
    [self.view addSubview:bottomView];
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if(section == 1){
        return 0;
    }else if(section == 2){
        return 0;
    }else{
        return 4;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section < 3) {
        return 44;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section <3) {
        UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 44)];
        vc.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(15, 43, DeviceSize.width-30, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
        [vc addSubview:line];
        UILabel *lblContact = [[UILabel alloc]initWithFrame:CGRectMake(15, 1, 50, 41)];
        lblContact.textColor = [UIColor colorWithHexString:@"#666666"];
        lblContact.font = [UIFont systemFontOfSize:15];
       
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake(DeviceSize.width-65, 0, 50, 44);
        [btnAdd setImage:[UIImage imageNamed:@"15-添加电话"] forState:UIControlStateNormal];
        [btnAdd setImage:[UIImage imageNamed:@"15-1"] forState:UIControlStateHighlighted];
        [btnAdd setImageEdgeInsets:UIEdgeInsetsMake(15.5, 26.5, 15.5, 10.5)];
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
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addDiagnose{
    AddDiagnoseViewController *vc = [[AddDiagnoseViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addCarePeople{
    AddCarePeopleViewController *vc = [[AddCarePeopleViewController alloc]init];
    [vc setContactBlock:^(NSMutableArray *careArray) {
        
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
            cell.lblTitle.text = @"已发生医疗费";
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
            cell.lblPlaceHolder.hidden = YES;
            cell.lblTitle.text = @"备注信息";
            [cell.btnMap removeFromSuperview];
            return cell;
        }else{
            AccidentTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AccidentTimeTableViewCell" owner:nil options:nil];
                if (nib.count>0) {
                    cell = [nib firstObject];
                }
            }
            cell.lblTitle.text = @"完成情况";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.btnTime addTarget:self action:@selector(selectState:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnTime2 addTarget:self action:@selector(selectState:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
}
-(void)selectState:(UIButton *)btn{
    
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
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textViewDidChange:(UITextView *)textView{
    AccidentAddressTableViewCell *cell;
    if (textView.tag == 1000) {
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.infoModel.address = textView.text;
    }else if (textView.tag == 1001){
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    }else if (textView.tag == 1002){
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
        self.infoModel.remark = textView.text;
    }
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
-(NSMutableArray *)contactPeopleArray{
    if (!_contactPeopleArray) {
        _contactPeopleArray = [NSMutableArray array];
    }
    return _contactPeopleArray;
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
        [[NetWorkManager shareNetWork]uploadBaseInfoWithTaskNo:self.taskModel.taskNo andAddress:self.infoModel.address andContactPerson:self.infoModel.contactPerson andContactTel:self.infoModel.contactTel andRemark:self.infoModel.remark andAccidentDate:self.infoModel.accidentDate andUserCode:userCode andTaskType:self.taskModel.taskType andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
            [weakSelf removeMBProgressHudInManaual];
            if ([response.responseCode isEqual:@"1"]) {
                [self showHudAuto:@"提交成功"];
            }else{
                [self showHudAuto:@"提交失败"];
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
    if (_unUploadImageArray) {
        _unUploadImageArray = [NSMutableArray array];
    }
    return _unUploadImageArray;
}
-(void)txtChange:(UITextField *)txt{
    self.infoModel.address =txt.text;
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end

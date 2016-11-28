//
//  UpbringViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/22.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "UpbringViewController.h"
#import "EditInfoModel.h"
#import "AddContactPersonViewController.h"
#import "AccidentTimeTableViewCell.h"
#import "ContactPeopleModel.h"
#import "PersonalInformationTableViewCell3.h"
#import "PictureTableViewCell.h"
#import "ShowPictureViewController.h"
#import "DealNameTableViewCell.h"
#import "AccidentAddressTableViewCell.h"
#import "SelectItemViewController.h"
#import "AddUpBringViewController.h"
@interface UpbringViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
//添加的被扶养人数组
@property (nonatomic,strong)NSMutableArray *upBringArray;
@property (nonatomic,strong)UIButton *btnCommit;
@property (nonatomic,strong)UIButton *btnSave;
//本页面信息model
@property (nonatomic,strong)EditInfoModel *infoModel;
//未上传图片数组 （上传判断使用）
@property (nonatomic,strong)NSMutableArray *unUploadImageArray;

@end

@implementation UpbringViewController

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
    self.infoModel =[CommUtil readDataWithFileName:self.taskModel.taskNo];
    if (self.infoModel) {
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
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.upBringArray.count;
    }else{
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }else{
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, 44)];
        vc.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        UILabel *lblContact = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, 41)];
        lblContact.text = @"被抚养人";
        lblContact.textColor = [UIColor colorWithHexString:@"#666666"];
        lblContact.font = [UIFont systemFontOfSize:15];
        [vc addSubview:lblContact];
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAdd setImage:[UIImage imageNamed:@"15-添加电话"] forState:UIControlStateNormal];
        [btnAdd setImage:[UIImage imageNamed:@"15-1"] forState:UIControlStateHighlighted];
        btnAdd.frame = CGRectMake(DeviceSize.width-38, 14.5, 13, 13);
        [btnAdd addTarget:self action:@selector(addUpBring) forControlEvents:UIControlEventTouchUpInside];
        [vc addSubview:btnAdd];
        return vc;
    }else{
        return nil;
    }
}
-(void)addUpBring{
    AddUpBringViewController *vc = [[AddUpBringViewController alloc]init];
    [vc setAddUpBringBlock:^(NSMutableArray *array) {
        [self.upBringArray addObjectsFromArray:array];
        self.infoModel.upBringArray = [NSArray arrayWithArray:self.upBringArray];
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 1&&indexPath.row ==0)||(indexPath.section == 1&&indexPath.row ==1)) {
        DealNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealNameCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DealNameTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        if (indexPath.row == 0) {
            cell.lblTitle.text = @"伤残赔偿系数";
            cell.txtName.tag = 3000;
        }else{
            cell.lblTitle.text = @"抚养费金额";
            cell.txtName.tag = 3001;
        }
        [cell.txtName addTarget:self action:@selector(txtChange:) forControlEvents:UIControlEventEditingChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        return cell;
    }else if (indexPath.section ==1 &&indexPath.row ==2){
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
    }else if (indexPath.section ==1 &&indexPath.row ==3){
        AccidentAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentAddressCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AccidentAddressTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.txtDetail.delegate =self;
        cell.lblPlaceHolder.hidden = YES;
        cell.lblTitle.text = @"备注信息";
        [cell.btnMap removeFromSuperview];
        return cell;
    }else if (indexPath.section ==1 &&indexPath.row ==4){
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
        return cell;
    }else{
        UpBringModel *model = self.upBringArray[indexPath.row];
        PersonalInformationTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInformationCell3"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PersonalInformationTableViewCell3" owner:self options:nil];
            if (nib.count > 0) {
                cell = nib.firstObject;
            }
        }
        cell.labelLeft.text = model.name;
        SelectList *type = model.householdType;
        cell.labelRight.text = type.value;
        cell.labelLeft.textColor = [UIColor colorWithHexString:Colorblack];
        cell.labelRight.textColor = [UIColor colorWithHexString:Colorgray];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
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
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textViewDidChange:(UITextView *)textView{
    self.infoModel.remark = textView.text;
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
-(NSMutableArray *)upBringArray{
    if (!_upBringArray) {
        _upBringArray = [NSMutableArray array];
    }
    return _upBringArray;
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
    [uploadDic setObject:self.infoModel.maintenance forKey:@"dependentSum"];
    if (self.infoModel.upBringArray.count >0) {
        NSMutableArray *upBringArr = [NSMutableArray array];
        for (UpBringModel *model in self.infoModel.upBringArray) {
            SelectList *typeModel = model.householdType;
            SelectList *relationModel = model.Relation;
            NSDictionary *dic = @{@"dependentName":model.name,@"dependentBirthday":model.birthday,@"dependentAge":model.age,@"dependentYearTotal":model.years,@"residenceNatureName":typeModel.value,@"victimRelationName":relationModel.value,@"dependentCount":model.years,@"dependentShare":@"",@"dependentAddr":model.address};
            [upBringArr addObject:dic];
        }
        [uploadDic setObject:upBringArr forKey:@"dependentItemList"];
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
        WeakSelf(UpbringViewController);
        [[NetWorkManager shareNetWork]uploadUpBringInfoWithDataDic:uploadDic andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
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
    WeakSelf(UpbringViewController);
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
    if (txt.tag == 3000) {
        self.infoModel.ratio = txt.text;
    }else{
        self.infoModel.maintenance =txt.text;
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

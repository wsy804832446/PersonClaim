//
//  AddContactPersonViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/10/20.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "AddContactPersonViewController.h"
#import "ContactNameTableViewCell.h"
#import "DeleteContactTableViewCell.h"
#import <ContactsUI/ContactsUI.h>
#import "ContactPeopleModel.h"
@interface AddContactPersonViewController ()<CNContactPickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *contactTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
//将保存的联系人数组
@property (nonatomic,strong)NSMutableArray *selectContactArray;
@end

@implementation AddContactPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"保存"];
    [self.view addSubview:self.contactTableView];
    ContactPeopleModel *model =[[ContactPeopleModel alloc]init];
    [self.dataArray addObject:model];
//    [self addBottomView];
}
    // Do any additional setup after loading the view.

-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    for (int i=0; i<self.dataArray.count; i++) {
        ContactPeopleModel *model = self.dataArray[i];
        ContactNameTableViewCell *cell =[self.contactTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:i]];
        model.name = cell.txtName.text;
        model.phone = cell.txtPhone.text;
        [self.selectContactArray addObject:model];
    }
    if (self.saveContactBlock) {
        self.saveContactBlock(self.selectContactArray);
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
    [btnAdd setTitle:@"+添加联系人" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
    [btnAdd setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
    [btnAdd addTarget:self action:@selector(addSection) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnAdd];
    [self.view addSubview:bottomView];
}
-(void)addSection{
    ContactPeopleModel *model =[[ContactPeopleModel alloc]init];
    [self.dataArray addObject:model];
    [self.contactTableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }else{
        return 89;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1){
        ContactNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellName"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ContactNameTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell =nib.firstObject;
            }
        }
        cell.lblName.text = @"姓名:";
        cell.lblName.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.lblPhone.text = @"电话:";
        cell.lblPhone.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.txtName.clearButtonMode = UITextFieldViewModeWhileEditing ;
        cell.txtPhone.clearButtonMode = UITextFieldViewModeWhileEditing ;
        cell.lineH.backgroundColor =[UIColor colorWithHexString:@"#dddddd"];
        cell.lineV.backgroundColor =[UIColor colorWithHexString:@"#dddddd"];
        [cell.btnAdd setImage:[UIImage imageNamed:@"30"] forState:UIControlStateNormal];
        [cell.btnAdd setImage:[UIImage imageNamed:@"30-1"] forState:UIControlStateHighlighted];
        [cell.btnAdd addTarget:self action:@selector(addFromContacts:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnAdd.tag = indexPath.section+2000;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        DeleteContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellDelete"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DeleteContactTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell =nib.firstObject;
            }
        }
        cell.lblContact.text = [NSString stringWithFormat:@"联系人%lu",indexPath.section+1];
        cell.linV.backgroundColor = [UIColor colorWithHexString:Colorblue];
        [cell.btnDelete setImage:[UIImage imageNamed:@"16"] forState:UIControlStateNormal];
        [cell.btnDelete setImage:[UIImage imageNamed:@"16-1"] forState:UIControlStateHighlighted];
        [cell.btnDelete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDelete.tag = indexPath.section+1000;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
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
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:btn.tag-1000];
    [self.dataArray removeObjectAtIndex:indexSet.firstIndex];
    [self.contactTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    [self.contactTableView reloadData];
}
-(void)addFromContacts:(UIButton *)btn{
    CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc]init];
    contactPicker.delegate = self;
    contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    ContactNameTableViewCell *cell = [self.contactTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:btn.tag-2000]];
    [self setContactBlock:^(NSString *name, NSString *phone) {
        cell.txtName.text =name;
        cell.txtPhone.text = phone;
    }];
    [self presentViewController:contactPicker animated:YES completion:nil];
}
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    NSString *name = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    NSString *phone = phoneNumber.stringValue;
    if (self.contactBlock) {
        self.contactBlock(name,phone);
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UITableView *)contactTableView{
    if (!_contactTableView) {
        _contactTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 14, DeviceSize.width, DeviceSize.height-74-54) style:UITableViewStyleGrouped];
        _contactTableView.delegate = self;
        _contactTableView.dataSource = self;
        _contactTableView.showsVerticalScrollIndicator =NO;
        _contactTableView.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
    }
    return _contactTableView;
}
-(NSString *)title{
    return @"添加联系人";
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)selectContactArray{
    if (!_selectContactArray) {
        _selectContactArray = [NSMutableArray array];
    }
    return _selectContactArray;
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

//
//  AddCarePeopleViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/9.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "AddCarePeopleViewController.h"
#import "DealNameTableViewCell.h"
#import "DeleteContactTableViewCell.h"
#import "ContactPeopleModel.h"
#import "AccidentTimeTableViewCell.h"
@interface AddCarePeopleViewController ()
//将保存的联系人数组
@property (nonatomic,strong)NSMutableArray *selectCareArray;
@end

@implementation AddCarePeopleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.top = 14;
    self.tableView.height = DeviceSize.height-14-64;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"保存"];
    CarePeopleModel *model =[[CarePeopleModel alloc]init];
    [self.dataArray addObject:model];
    [self addBottomView];
}
// Do any additional setup after loading the view.

-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    for (int i=0; i<self.dataArray.count; i++) {
        ContactPeopleModel *model = self.dataArray[i];

        [self.selectCareArray addObject:model];
    }
    if (self.contactBlock) {
        self.contactBlock(self.selectCareArray);
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
    [btnAdd setTitle:@"+添加护理人" forState:UIControlStateNormal];
    [btnAdd setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
    [btnAdd setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
    [btnAdd addTarget:self action:@selector(addSection) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnAdd];
    [self.view addSubview:bottomView];
}
-(void)addSection{
    CarePeopleModel *model =[[CarePeopleModel alloc]init];
    [self.dataArray addObject:model];
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        DeleteContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellDelete"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DeleteContactTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell =nib.firstObject;
            }
        }
        cell.lblContact.text = [NSString stringWithFormat:@"护理人%lu",indexPath.section+1];
        cell.linV.backgroundColor = [UIColor colorWithHexString:Colorblue];
        [cell.btnDelete setImage:[UIImage imageNamed:@"16"] forState:UIControlStateNormal];
        [cell.btnDelete setImage:[UIImage imageNamed:@"16-1"] forState:UIControlStateHighlighted];
        [cell.btnDelete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDelete.tag = indexPath.section+1000;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        AccidentTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AccidentTimeTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        cell.lblTitle.text = @"护理人身份";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btnTime addTarget:self action:@selector(careIdentity:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnTime2 addTarget:self action:@selector(careIdentity:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        DealNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealNameCell"];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DealNameTableViewCell" owner:nil options:nil];
            if (nib.count>0) {
                cell = [nib firstObject];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
        if (indexPath.row == 2){
            cell.lblTitle.text = @"护理人姓名";
        }else if (indexPath.row == 3){
            cell.lblTitle.text = @"护理天数";
        }else if (indexPath.row == 4){
            cell.lblTitle.text = @"护理费";
        }
         return cell;
    }
}
-(void)careIdentity:(UIButton *)btn{
    
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
    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSString *)title{
    return @"添加护理人";
}
-(NSMutableArray *)selectCareArray{
    if (!_selectCareArray) {
        _selectCareArray = [NSMutableArray array];
    }
    return _selectCareArray;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}- (void)didReceiveMemoryWarning {
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

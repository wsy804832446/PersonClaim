//
//  AllViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/10/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "AllViewController.h"
#import "FollowPlatFormViewCell.h"
#import "FollowDetaiViewController.h"
@interface AllViewController ()
//标题名称数组
@property (nonatomic,strong)NSArray *itemsArr;
//选中index
@property (nonatomic,assign)NSInteger selectIndex;
//segment条
@property (nonatomic,strong)UIView *buttonDown;
//标题按钮数组
@property (nonatomic,strong)NSMutableArray *ButtonArray;
@property (nonatomic,strong)UIScrollView *searchScrollView;
//超时时间按钮数组
@property (nonatomic,strong)NSMutableArray *overTimeBtnArray;
@end

@implementation AllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andImageName:@"8-搜索"];
    [self.view addSubview:self.searchScrollView];
    self.itemsArr = @[@"全部",@"未超时",@"已超时",@"已完成"];
    [self AddSegumentArray:_itemsArr];
    self.tableView.top = self.searchScrollView.bottom+10;
    self.tableView.height = DeviceSize.height-self.tableView.top;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}
-(void)getData{
    NSArray *arr = [CommUtil readDataWithFileName:[NSString stringWithFormat:@"cliam%@",[CommUtil readDataWithFileName:@"account"]]];
    for (ClaimModel *claimModel in arr) {
        for (NSDictionary * taskDic in claimModel.taskList){
            TaskModel *taskModel = [MTLJSONAdapter modelOfClass:[TaskModel class] fromJSONDictionary:taskDic error:NULL];
            if (self.claimType ==0 && [taskModel.taskType isEqual:@"09"]) {
                [self.dataArray addObject:claimModel];
                break;
            }else if (self.claimType ==1 && [taskModel.taskType isEqual:@"10"]) {
                [self.dataArray addObject:claimModel];
                break;
            }else if (self.claimType ==2 && [taskModel.taskType isEqual:@"01"]) {
                [self.dataArray addObject:claimModel];
                break;
            }else if (self.claimType ==3 && [taskModel.taskType isEqual:@"02"]) {
                [self.dataArray addObject:claimModel];
                break;
            }else if (self.claimType ==4 && [taskModel.taskType isEqual:@"03"]) {
                [self.dataArray addObject:claimModel];
                break;
            }else if (self.claimType ==5 && [taskModel.taskType isEqual:@"04"]) {
                [self.dataArray addObject:claimModel];
                break;
            }else if (self.claimType ==6 && [taskModel.taskType isEqual:@"05"]) {
                [self.dataArray addObject:claimModel];
                break;
            }else if (self.claimType ==7 && [taskModel.taskType isEqual:@"08"]) {
                [self.dataArray addObject:claimModel];
                break;
            }else if (self.claimType ==8 && [taskModel.taskType isEqual:@"06"]) {
                [self.dataArray addObject:claimModel];
                break;
            }
        }
    }
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    
}
-(void)AddSegumentArray:(NSArray *)SegumentArray
{
    CGFloat witdFloat=(DeviceSize.width)/4;
    for (int i=0; i<SegumentArray.count; i++) {
        UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(i*witdFloat, 0, witdFloat,35)];
        [button setTitle:SegumentArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:Colorblue]  forState:UIControlStateSelected];
        [button setTag:1000+i];
        [button addTarget:self action:@selector(changeTheSegument:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            self.buttonDown=[[UIView alloc]initWithFrame:CGRectMake(i*witdFloat,button.bottom, witdFloat, 3)];
            [_buttonDown setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
            [_searchScrollView addSubview:_buttonDown];
        }
        [_searchScrollView addSubview:button];
        [self.ButtonArray addObject:button];
    }
    [[self.ButtonArray firstObject] setSelected:YES];
}
-(void)changeTheSegument:(UIButton*)button
{
    [self selectTheSegument:button.tag-1000];
    
}
-(void)selectTheSegument:(NSInteger)segument
{
    if (self.selectIndex!=segument) {
        [self.ButtonArray[_selectIndex] setSelected:NO];
        UIButton *btn = self.ButtonArray[segument] ;
        [btn setSelected:YES];
        [UIView animateWithDuration:0.5 animations:^{
            [_buttonDown setFrame:CGRectMake(btn.left,btn.bottom,btn.width, 3)];
        }];
        _selectIndex=segument;
        [self.tableView reloadData];
    }
    if (segument ==3) {
        NSArray *overTimeArr = @[@"全部",@"超3天",@"超5天",@"超7天",@"超30天"];
        CGFloat witdFloat=(DeviceSize.width)/5;
        for (int i=0; i<5; i++) {
            UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(i*witdFloat+(witdFloat-50)/2,self.searchScrollView.bottom+25/2, 50,19)];
            [button setTitle:overTimeArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitleColor:[UIColor colorWithHexString:Colorgray] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:Colorwhite]  forState:UIControlStateSelected];
            [button setTag:2000+i];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 4;
            [button addTarget:self action:@selector(overTimeChange:) forControlEvents:UIControlEventTouchUpInside];
            [self.overTimeBtnArray addObject:button];
            [self.view addSubview:button];
            self.tableView.top = button.bottom+25/2;
            self.tableView.height = DeviceSize.height-self.tableView.top;
            if (i == 0) {
                button.selected = YES;
                button.backgroundColor = [UIColor colorWithHexString:Colorblue];
            }
        }
    }else{
        for (UIButton *button in self.overTimeBtnArray) {
            [button removeFromSuperview];
        }
        self.tableView.top = self.searchScrollView.bottom+10;
        self.tableView.height = DeviceSize.height-self.tableView.top;
    }
}
-(void)overTimeChange:(UIButton *)btn{
    btn.selected = YES;
    btn.backgroundColor = [UIColor colorWithHexString:Colorblue];
    for (UIButton *button in self.overTimeBtnArray) {
        if (button.tag != btn.tag) {
            button.selected = NO;
            button.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
        }
    }
}
- (UIScrollView *)searchScrollView{
    if (!_searchScrollView) {
        _searchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceSize.width, 38)];
        _searchScrollView.delegate = self;
        _searchScrollView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        _searchScrollView.contentSize = CGSizeMake(DeviceSize.width/5*_itemsArr.count, 38);
        _searchScrollView.showsHorizontalScrollIndicator = NO;
        _searchScrollView.showsVerticalScrollIndicator = NO;
        _searchScrollView.pagingEnabled = NO;
        _searchScrollView.bouncesZoom = NO;
    }
    return _searchScrollView;
}
-(NSMutableArray *)ButtonArray{
    if (!_ButtonArray) {
        _ButtonArray = [NSMutableArray array];
    }
    return _ButtonArray;
}
-(NSMutableArray *)overTimeBtnArray{
    if (!_overTimeBtnArray) {
        _overTimeBtnArray = [NSMutableArray array];
    }
    return _overTimeBtnArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ClaimModel *model = self.dataArray[section];
    for (NSDictionary *dic in model.taskList) {
        TaskModel *taskModel = [MTLJSONAdapter modelOfClass:[TaskModel class] fromJSONDictionary:dic error:NULL];
        if (self.claimType ==0 && [taskModel.taskType isEqual:@"09"]) {
            [model.taskArr addObject:taskModel];
        }else if (self.claimType ==1 && [taskModel.taskType isEqual:@"10"]) {
            [model.taskArr addObject:taskModel];
        }else if (self.claimType ==2 && [taskModel.taskType isEqual:@"01"]) {
            [model.taskArr addObject:taskModel];
        }else if (self.claimType ==3 && [taskModel.taskType isEqual:@"02"]) {
            [model.taskArr addObject:taskModel];
        }else if (self.claimType ==4 && [taskModel.taskType isEqual:@"03"]) {
            [model.taskArr addObject:taskModel];        }
        else if (self.claimType ==5 && [taskModel.taskType isEqual:@"04"]) {
            [model.taskArr addObject:taskModel];
        }else if (self.claimType ==6 && [taskModel.taskType isEqual:@"05"]) {
            [model.taskArr addObject:taskModel];
        }else if (self.claimType ==7 && [taskModel.taskType isEqual:@"08"]) {
            [model.taskArr addObject:taskModel];
        }else if (self.claimType ==8 && [taskModel.taskType isEqual:@"06"]) {
            [model.taskArr addObject:taskModel];
        }

    }
    return model.taskArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowPlatFormViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlatFormCELL"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"FollowPlatFormViewCell" owner:nil options:nil];
        if (nib.count>0) {
            cell = nib.firstObject;
        }
    }
    if (indexPath.row == 0) {
        cell.line.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    }
    ClaimModel *claimModel =self.dataArray[indexPath.section];
    TaskModel *taskModel= claimModel.taskArr[indexPath.row];
    cell.lblName.text = claimModel.insuredName;
    cell.lblTime.text = taskModel.dispatchDate;
    cell.lblTime.textColor = [UIColor colorWithHexString:Colorgray];
    cell.lblNum.text = [NSString stringWithFormat:@"报案号:%@",claimModel.reportNo];
    cell.lblNum.textColor = [UIColor colorWithHexString:Colorgray];
    cell.lblState.layer.masksToBounds = YES;
    cell.lblState.layer.borderWidth =1;
    cell.lblState.layer.cornerRadius =4;
    cell.lblState.font = [UIFont systemFontOfSize:12];
    cell.lblTaskType.layer.masksToBounds = YES;
    cell.lblTaskType.layer.cornerRadius = 10;
    cell.lblTaskType.backgroundColor = [UIColor colorWithHexString:@"#9DC5F9"];
    cell.lblTaskType.textColor = [UIColor colorWithHexString:Colorwhite];
    if ([taskModel.taskType isEqualToString:@"01"]) {cell.lblTaskType.text = @"医";
    }else if ([taskModel.taskType isEqualToString:@"02"]) {cell.lblTaskType.text = @"薪";
    }else if ([taskModel.taskType isEqualToString:@"03"]) {cell.lblTaskType.text = @"误";
    }else if ([taskModel.taskType isEqualToString:@"04"]) {cell.lblTaskType.text = @"籍";
    }else if ([taskModel.taskType isEqualToString:@"05"]) {cell.lblTaskType.text = @"扶";
    }else if ([taskModel.taskType isEqualToString:@"06"]) {cell.lblTaskType.text = @"死";
    }else if ([taskModel.taskType isEqualToString:@"08"]) {cell.lblTaskType.text = @"伤";
    }else if ([taskModel.taskType isEqualToString:@"09"]) {cell.lblTaskType.text = @"基";
    }else if ([taskModel.taskType isEqualToString:@"10"]) {cell.lblTaskType.text = @"处";
    }
//    if (self.selectIndex == 3) {
//        cell.lblState.text = nil;
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"超%ld天",(long)indexPath.row]];
//        NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:15]};
//        NSDictionary *dict2 = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:Colorgray],NSFontAttributeName:[UIFont systemFontOfSize:12]};
//        [str addAttributes:dict range:NSMakeRange(1, str.length-2)];
//        [str addAttributes:dict2 range:NSMakeRange(0,1)];
//        [str addAttributes:dict2 range:NSMakeRange(str.length-1, 1)];
//        cell.lblOverTime.attributedText = str;
//    }else if(self.selectIndex == 0){
//        cell.lblOverTime.attributedText = nil;
//        cell.lblState.layer.masksToBounds = YES;
//        cell.lblState.layer.borderWidth =1;
//        cell.lblState.layer.cornerRadius =4;
//        cell.lblState.font = [UIFont systemFontOfSize:12];
//        switch (indexPath.row) {
//            case 4:
//                cell.lblState.text =@" 完成 ";
//                cell.lblState.textColor = [UIColor colorWithHexString:@"#00c632"];
//                cell.lblState.layer.borderColor = [UIColor colorWithHexString:@"#00c632"].CGColor;
//                break;
//            case 3:
//                cell.lblState.text =@" 超时 ";
//                cell.lblState.textColor = [UIColor colorWithHexString:@"#ff0000"];
//                cell.lblState.layer.borderColor = [UIColor colorWithHexString:@"#ff0000"].CGColor;
//                break;
//            case 2:
//                cell.lblState.text =@" 进行中 ";
//                cell.lblState.textColor = [UIColor colorWithHexString:@"#ffc106"];
//                cell.lblState.layer.borderColor = [UIColor colorWithHexString:@"#ffc106"].CGColor;
//                break;
//            case 1:
//                cell.lblState.text =@" 待办 ";
//                cell.lblState.textColor = [UIColor colorWithHexString:@"#3282f0"];
//                cell.lblState.layer.borderColor = [UIColor colorWithHexString:@"#3282f0"].CGColor;
//                break;
//            default:
//                cell.lblState.text =@" xxx ";
//                break;
//        }
//
//    }else{
//         cell.lblState.text= nil;
//    }
       return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setHidesBottomBarWhenPushed:YES];
    FollowPlatFormViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    FollowDetaiViewController *vc = [[FollowDetaiViewController alloc]init];
    vc.taskTypeName = cell.lblTaskType.text;
    ClaimModel *claimModel =self.dataArray[indexPath.section];
    vc.claimModel = claimModel;
    vc.taskModel = claimModel.taskArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSString *)title{
    if (self.claimType ==0) {
        return @"伤残基本信息";
    }else if (self.claimType ==1){
        return @"事故现场";
    }else if (self.claimType ==2){
        return @"医院探视";
    }else if (self.claimType ==3){
        return @"收入情况";
    }else if (self.claimType ==4){
        return @"误工情况";
    }else if (self.claimType ==5){
        return @"户籍居住";
    }else if (self.claimType ==6){
        return @"被扶养人";
    }else if (self.claimType ==7){
        return @"伤残鉴定";
    }else if(self.claimType ==8){
        return  @"死亡信息";
    }else{
        return @"全部任务";
    }
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

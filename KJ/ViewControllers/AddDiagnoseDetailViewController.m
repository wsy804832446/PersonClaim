//
//  AddDiagnoseDetailViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/11.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "AddDiagnoseDetailViewController.h"
#import "DiagnoseDetailModel.h"
@interface AddDiagnoseDetailViewController ()

@end

@implementation AddDiagnoseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem =[UIBarButtonItemExtension rightButtonItem:@selector(rightAction:) andTarget:self andTitleName:@"确定"];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    WeakSelf(AddDiagnoseDetailViewController);
    [weakSelf showHudWaitingView:WaitPrompt];
    [[NetWorkManager shareNetWork]getDiagnoseDeatilListWithKindCode:self.Id andSearchCode:@"" andPageNo:self.pageNO andPageSize:self.pageSize andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if ([response.responseCode isEqual:@"1"]) {
            if (weakSelf.pageNO == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in response.dataDic[@"disabList"]) {
                DiagnoseDetailModel *model = [MTLJSONAdapter modelOfClass:[DiagnoseDetailModel class]  fromJSONDictionary:dic error:NULL];
                [weakSelf.dataArray addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf removeMBProgressHudInManaual];
    }];
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    DiagnoseDetailModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.itemCnName;
    return cell;
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction:(UIButton *)btn{
    
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

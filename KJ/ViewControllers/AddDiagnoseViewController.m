//
//  AddDiagnoseViewController.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/10.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "AddDiagnoseViewController.h"
#import "PersonalInformationTableViewCell2.h"
#import "BodyPartModel.h"
#import "AddDiagnoseDetailViewController.h"
@interface AddDiagnoseViewController ()

@end

@implementation AddDiagnoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andImageName:@"8-搜索"];
    [self getData];
        // Do any additional setup after loading the view.
}
-(void)getData{
    WeakSelf(AddDiagnoseViewController);
    [weakSelf showHudWaitingView:WaitPrompt];
    [[NetWorkManager shareNetWork]getDiagnoseListWithCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if ([response.responseCode isEqual:@"1"]) {
            for (NSDictionary *dic in response.dataArray) {
                BodyPartModel *model =[MTLJSONAdapter modelOfClass:[BodyPartModel class] fromJSONDictionary:dic error:NULL];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf showHudAuto:response.message];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        [weakSelf removeMBProgressHudInManaual];
    }];

}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalInformationTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInformationCell2"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PersonalInformationTableViewCell2" owner:self options:nil];
        if (nib.count > 0) {
            cell = nib.firstObject;
        }
        
    }
    BodyPartModel *model = self.dataArray[indexPath.row];
    cell.img.image = [UIImage imageNamed:@"箭头"];
    cell.labelLeft.textColor = [UIColor colorWithHexString:Colorblack];
    cell.labelLeft.text =model.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddDiagnoseDetailViewController *vc = [[AddDiagnoseDetailViewController alloc]init];
    BodyPartModel *model = self.dataArray[indexPath.row];
    vc.title = model.name;
    vc.body = model;
    [self.navigationController pushViewController:vc animated:YES];
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

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
#import "SQSectorButton.h"
@interface AddDiagnoseViewController ()
@property (nonatomic,strong)UISegmentedControl *seg;
@property (nonatomic,strong)UIView *imageView;
@property (nonatomic,strong)UIButton *btnRotate;
//0 头  1全身  2背
@property (nonatomic,copy)NSString *state;
@end

@implementation AddDiagnoseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andImageName:@"8-搜索"];
    [self getData];
    if (self.seg.selectedSegmentIndex ==0) {
        [self.tableView removeFromSuperview];
        [self addImage];
    }else{
        [self.view addSubview:self.tableView];
    }
    self.navigationItem.titleView = self.seg;
        // Do any additional setup after loading the view.
}
-(UIButton *)btnRotate{
    if (!_btnRotate) {
        _btnRotate = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRotate.frame = CGRectMake(DeviceSize.width-30-57, DeviceSize.height-57-60-64, 57, 57);
        [_btnRotate addTarget:self action:@selector(Rotate:) forControlEvents:UIControlEventTouchUpInside];
        _btnRotate.layer.masksToBounds = YES;
        _btnRotate.layer.cornerRadius = 57/2;
        _btnRotate.tag = 9999;
    }
    return _btnRotate;
}
-(void)Rotate:(UIButton *)btn{
     if ([self.state isEqual:@"1"]) {
         self.state = @"2";
         UIView *vc = [self.view viewWithTag:8888];
         [vc removeFromSuperview];
         UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, DeviceSize.height-64)];;
         backView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
         backView.tag = 8888;
         NSArray *imageNameArr = @[@"2-背面",@"3-背部-分散"];
         NSArray *heightLightImageNameArr = @[@"2-背面",@"2-点击区域",];
         for (int i=0; i<2; i++) {
             SQSectorButton *btn = [[SQSectorButton alloc]initWithFrame:CGRectMake(0, 0, 375, 603)];
             [btn setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
             [btn setImage:[UIImage imageNamed:heightLightImageNameArr[i]] forState:UIControlStateHighlighted];
             btn.tag = 1000+i;
             [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
             [backView addSubview:btn];
         }
         [backView addSubview:self.btnRotate];
         [_btnRotate setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
         [_btnRotate setImage:[UIImage imageNamed:@"switch_pre"] forState:UIControlStateHighlighted];
         [self.view addSubview:backView];
     }else {
         [self addImage];
     }
}
-(void)addImage{
    self.state = @"1";
    UIView *vc = [self.view viewWithTag:8888];
    if (vc) {
        [vc removeFromSuperview];
    }
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, DeviceSize.height-64)];
    backView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    backView.tag = 8888;
    NSArray *imageNameArr = @[@"底图",@"1-头",@"2-四肢",@"3-颈部",@"4-胸",@"5-腹部",@"6-盆骨",@"7-生殖"];
    NSArray *heightLightImageNameArr = @[@"底图",@"1-头部",@"1-四肢",@"1-颈部",@"1-胸部",@"1-腹部",@"点击区域",@"1-必尿生殖"];
    for (int i=0; i<8; i++) {
        SQSectorButton *btn = [[SQSectorButton alloc]initWithFrame:CGRectMake(0, 0, 375, 603)];
        [btn setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:heightLightImageNameArr[i]] forState:UIControlStateHighlighted];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
    }
    [backView addSubview:self.btnRotate];
    [_btnRotate setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
    [_btnRotate setImage:[UIImage imageNamed:@"switch_pre"] forState:UIControlStateHighlighted];
    [self.view addSubview:backView];
}
-(void)btnClick:(UIButton *)btn{
    if ([self.state isEqual:@"1"]) {
        if (btn.tag ==1001) {
            self.state = @"0";
            UIView *vc = [self.view viewWithTag:8888];
            [vc removeFromSuperview];
            UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceSize.width, DeviceSize.height-64)];;
            backView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
            backView.tag = 8888;
            NSArray *imageNameArr = @[@"1-头底图",@"1-耳朵",@"3-鼻子",@"4-眼睛",@"6-嘴"];
            NSArray *heightLightImageNameArr = @[@"1-头底图",@"3-右耳",@"2-鼻子",@"5-眼睛",@"4-嘴"];
            for (int i=0; i<5; i++) {
                SQSectorButton *btn = [[SQSectorButton alloc]initWithFrame:CGRectMake(0, 0, 375, 603)];
                [btn setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:heightLightImageNameArr[i]] forState:UIControlStateHighlighted];
                btn.tag = 1000+i;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:btn];
            }
            [backView addSubview:self.btnRotate];
            [_btnRotate setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [_btnRotate setImage:[UIImage imageNamed:@"back_pre"] forState:UIControlStateHighlighted];
            [self.view addSubview:backView];
        }else{
            AddDiagnoseDetailViewController *vc = [[AddDiagnoseDetailViewController alloc]init];
            for (BodyPartModel *model in self.dataArray) {
                if ([model.name isEqual:@"四肢"]&&btn.tag ==1002) {
                    vc.title = model.name;
                    vc.body = model;
                }else if ([model.name isEqual:@"颈部"]&&btn.tag ==1003){
                    vc.title = model.name;
                    vc.body = model;
                }else if ([model.name isEqual:@"胸部"]&&btn.tag ==1004){
                    vc.title = model.name;
                    vc.body = model;
                }else if ([model.name isEqual:@"腹部"]&&btn.tag ==1005){
                    vc.title = model.name;
                    vc.body = model;
                }else if ([model.name isEqual:@"骨盆"]&&btn.tag ==1006){
                    vc.title = model.name;
                    vc.body = model;
                }else if ([model.name isEqual:@"泌尿生殖"]&&btn.tag ==1007){
                    vc.title = model.name;
                    vc.body = model;
                }
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if([self.state isEqual:@"0"]){
//        AddDiagnoseDetailViewController *vc = [[AddDiagnoseDetailViewController alloc]init];
//        for (BodyPartModel *model in self.dataArray) {
//            if (btn.tag ==1001) {
//                vc.title = model.name;
//                vc.body = model;
//        if ([model.name isEqual:@"背部"]&&btn.tag ==1001) {
//            vc.title = model.name;
//            vc.body = model;
//        }else if ([model.name isEqual:@"背部"]&&btn.tag ==1002){
//            vc.title = model.name;
//            vc.body = model;
//        }else if ([model.name isEqual:@"背部"]&&btn.tag ==1003){
//            vc.title = model.name;
//            vc.body = model;
//        }else if ([model.name isEqual:@"背部"]&&btn.tag ==1004){
//            vc.title = model.name;
//            vc.body = model;
//        }
    }else{
        if (btn.tag ==1001) {
            AddDiagnoseDetailViewController *vc = [[AddDiagnoseDetailViewController alloc]init];
            for (BodyPartModel *model in self.dataArray) {
                if ([model.name isEqual:@"背部"]) {
                    vc.title = model.name;
                    vc.body = model;
                }
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)getData{
    WeakSelf(AddDiagnoseViewController);
    [weakSelf showHudWaitingView:WaitPrompt];
    [[NetWorkManager shareNetWork]getDiagnoseListWithCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        [weakSelf removeMBProgressHudInManaual];
        if ([response.responseCode isEqual:@"1"]) {
            [weakSelf.dataArray removeAllObjects];
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
-(void)segChange:(UISegmentedControl *)seg{
    if (self.seg.selectedSegmentIndex ==0) {
        [self.tableView removeFromSuperview];
        [self.view addSubview:self.imageView];
    }else{
        [self.imageView removeFromSuperview];
        [self.view addSubview:self.tableView];
        [self getData];
    }
}
-(UISegmentedControl *)seg{
    if (!_seg) {
        _seg = [[UISegmentedControl alloc]initWithItems:@[@"人体图",@"诊断列表"]];
        _seg.frame =CGRectMake(0, 0, 222, 34);
        _seg.selectedSegmentIndex = 0;
        [_seg addTarget:self action:@selector(segChange:) forControlEvents:UIControlEventValueChanged];
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName: [UIColor colorWithHexString:Colorblue]};
        NSDictionary* unSelectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName: [UIColor colorWithHexString:Colorwhite]};
        [_seg setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        [_seg setTitleTextAttributes:unSelectedTextAttributes forState:UIControlStateNormal];
        _seg.layer.masksToBounds = YES;
        _seg.layer.cornerRadius = 34*0.16;
        _seg.layer.borderColor = [UIColor colorWithHexString:Colorwhite].CGColor;
        _seg.layer.borderWidth = 1;
        _seg.backgroundColor = [UIColor clearColor];
        _seg.tintColor = [UIColor colorWithHexString:Colorwhite];
    }
    return _seg;
}
-(UIView *)imageView{
    if (!_imageView) {
        _imageView = [[UIView alloc]initWithFrame:self.view.frame];
    }
    return _imageView;
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

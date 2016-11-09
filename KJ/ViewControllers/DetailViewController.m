//
//  DetailViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/9/30.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
//标题
@property (nonatomic,strong)UILabel *lableTitle;
//机构
@property (nonatomic,strong)UILabel *lableOrganization;
//时间
@property (nonatomic,strong)UILabel *lableTime;
//xx号文件
@property (nonatomic,strong)UILabel *lableNum;
//具体内容
@property (nonatomic,strong)UILabel *lableDetail;
//顶部粗条
@property (nonatomic,strong)UIView *line1;
//分割线
@property (nonatomic,strong)UIView *line2;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction:) andTarget:self andImageName:@"收藏_r1_c1"];
    self.view.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    self.line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,10)];
    _line1.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
    [self.view addSubview:self.line1];
    [self.view addSubview:self.lableTitle];
    [self.view addSubview:self.lableOrganization];
    self.line2 = [[UIView alloc]initWithFrame:CGRectMake(15, _lableOrganization.bottom+10, self.view.width-30, 1)];
    _line2.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.lableTime];
    [self.view addSubview:self.lableNum];
    [self.view addSubview:self.lableDetail];
    // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setImage:[UIImage imageNamed:@"收藏_r1_c3"] forState:UIControlStateNormal];
    }else{
         [btn setImage:[UIImage imageNamed:@"收藏_r1_c1"] forState:UIControlStateNormal];
    }
}
-(UILabel *)lableTitle{
    if (!_lableTitle) {
        _lableTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, _line1.bottom+10, self.view.width-30, 0)];
        _lableTitle.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        _lableTitle.text = @"外交部举行";
        _lableTitle.numberOfLines = 0;
        _lableTitle.font = [UIFont systemFontOfSize:15];
        CGSize size =[_lableTitle sizeThatFits:CGSizeMake(self.view.width, MAXFLOAT)];
        _lableTitle.frame = CGRectMake(_lableTitle.frame.origin.x, _lableTitle.frame.origin.y, _lableTitle.frame.size.width, size.height);
    }
    return _lableTitle;
}
-(UILabel *)lableOrganization{
    if (!_lableOrganization) {
        _lableOrganization = [[UILabel alloc]initWithFrame:CGRectMake(_lableTitle.origin.x, _lableTitle.bottom+10,0,13)];
        _lableOrganization.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        _lableOrganization.font = [UIFont systemFontOfSize:12];
        _lableOrganization.textColor = [UIColor colorWithHexString:@"#666666"];
        _lableOrganization.text =@"2222222";
        _lableOrganization.frame =CGRectMake(_lableTitle.origin.x, _lableTitle.bottom+10,_lableOrganization.text.length*12,15);
        
    }
    return _lableOrganization;
}
-(UILabel *)lableTime{
    if (!_lableTime) {
        _lableTime = [[UILabel alloc]initWithFrame:CGRectMake(_lableOrganization.right, _lableOrganization.origin.y, self.view.width-_lableOrganization.right-15, _lableOrganization.height)];
        _lableTime.text = @"2011-11-11";
        _lableTime.textAlignment = NSTextAlignmentRight;
        _lableTime.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        _lableTime.font = [UIFont systemFontOfSize:12];
        _lableTime.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _lableTime;
}
-(UILabel *)lableNum{
    if (!_lableNum) {
        _lableNum = [[UILabel alloc]initWithFrame:CGRectMake(_lableOrganization.origin.x,_line2.bottom+10,0, _lableOrganization.height)];
        _lableNum.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        _lableNum.font = [UIFont systemFontOfSize:12];
        _lableNum.textColor = [UIColor colorWithHexString:@"#666666"];
        _lableNum.text = @"xxxxxxxxxxxxx1";
        _lableNum.frame = CGRectMake(_lableOrganization.origin.x,_line2.bottom+10,_lableNum.text.length*12, 13);
    }
    return _lableNum;
}
-(UILabel *)lableDetail{
    if (!_lableDetail) {
        _lableDetail = [[UILabel alloc]initWithFrame:CGRectMake(15, _lableNum.bottom+10, self.view.width-30, self.view.height-_lableDetail.top)];
        NSString *str =@"外交部举行中外媒体吹风会。外交部副部长李保东、部长助理孔铉佑分别介绍习近平主席即将对柬埔寨、孟加拉国进行国事访问并出席在印度果阿举行的金砖国家领导人第八次会晤有关情况，并回答记者提问。孔铉佑表示，习近平主席将于10月13日至15日对柬埔寨、孟加拉国进行国事访问。中柬友谊源远流长。柬埔寨是中国的友好邻邦和重要合作伙伴。 中方愿同柬方紧密配合，落实好两国领导人达成的共识，深化各领域务";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        _lableDetail.attributedText = attributedString;
        _lableDetail.font = [UIFont systemFontOfSize:14];
        _lableDetail.textColor = [UIColor colorWithHexString:Colorblack];
        _lableDetail.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        _lableDetail.numberOfLines = 0;
        CGSize size =[_lableDetail sizeThatFits:CGSizeMake(self.view.width,3000)];
        _lableDetail.frame = CGRectMake(_lableDetail.frame.origin.x, _lableDetail.frame.origin.y, _lableDetail.frame.size.width, size.height);
    }
    return _lableDetail;
}
-(NSString *)title{
    return @"详情";
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

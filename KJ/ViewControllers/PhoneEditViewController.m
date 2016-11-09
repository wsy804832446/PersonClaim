//
//  PhoneEditViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/9/28.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "PhoneEditViewController.h"
#import "MyTextField.h"
#import "SMS_SDK/SMSSDK.h"
@interface PhoneEditViewController ()
@property (nonatomic,strong)UILabel *oldPhoneLabel;
//手机号输入框
@property (nonatomic,strong)MyTextField *PhoneTextField;
//验证码输入框
@property (nonatomic,strong)MyTextField *verificationCode;
//获取验证码按钮
@property (nonatomic,strong)UIButton *GetVerificationCode;
//下方确定按钮
@property (nonatomic,strong)UIButton *sureBtn;
//计时器
@property (nonatomic,strong)NSTimer *timer;
//倒计时数字
@property (nonatomic,assign)NSInteger countNum;
@end

@implementation PhoneEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"确定"];
    [self.view addSubview:self.oldPhoneLabel];
    [self.view addSubview:self.PhoneTextField];
    [self.view addSubview:self.verificationCode];
    [self.view addSubview:self.GetVerificationCode];
    [self.view addSubview:self.sureBtn];
    //倒计时60s
    self.countNum = 60;
    // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
   
}
-(UILabel *)oldPhoneLabel{
    if (!_oldPhoneLabel) {
        _oldPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
        _oldPhoneLabel.backgroundColor = self.view.backgroundColor;
        NSDictionary *AttDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"    原手机号:     %@",self.phoneNum]attributes:AttDic];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:Colorgray] range:NSMakeRange(0, 9)];
        _oldPhoneLabel.font = [UIFont systemFontOfSize:15];
        _oldPhoneLabel.attributedText = str;
    }
    return _oldPhoneLabel;
}
-(UITextField *)PhoneTextField{
    if (!_PhoneTextField) {
        _PhoneTextField = [[MyTextField alloc]initWithFrame:CGRectMake(0, self.oldPhoneLabel.bottom, self.view.width, 45)];
        _PhoneTextField.placeholder = @"请输入新手机号";
        _PhoneTextField.font = [UIFont systemFontOfSize:15];
        _PhoneTextField.backgroundColor = [UIColor whiteColor];
        _PhoneTextField.clearButtonMode = UITextFieldViewModeAlways;
        _PhoneTextField.inset = 15;
    }
    return _PhoneTextField;
}
-(UITextField *)verificationCode{
    if (!_verificationCode) {
        _verificationCode = [[MyTextField alloc]initWithFrame:CGRectMake(0, self.PhoneTextField.bottom+10, self.view.width-10-134, 45)];
        _verificationCode.placeholder = @"请输入验证码";
        _verificationCode.font = [UIFont systemFontOfSize:15];
        _verificationCode.backgroundColor = [UIColor whiteColor];
        _verificationCode.inset = 15;
    }
    return _verificationCode;
}
-(UIButton *)GetVerificationCode{
    if (!_GetVerificationCode) {
        _GetVerificationCode = [UIButton buttonWithType:UIButtonTypeCustom];
        _GetVerificationCode.frame = CGRectMake(self.verificationCode.right+10, self.PhoneTextField.bottom+10, 134, 45);
        [_GetVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _GetVerificationCode.titleLabel.font = [UIFont systemFontOfSize:15];
        [_GetVerificationCode setBackgroundColor:[UIColor colorWithHexString:Colorwhite]];
        [_GetVerificationCode setTitleColor:[UIColor colorWithHexString:Colorblue] forState:UIControlStateNormal];
        [_GetVerificationCode addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _GetVerificationCode;
}
//获取验证码
-(void)btnClick:(UIButton *)btn{
    if (self.countNum == 60) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.PhoneTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if (!error) {
                NSLog(@"success");
            }else{
                NSLog(@"%@",error);
            }
        }];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
        [self.timer fire];
        btn.enabled = NO;
        [btn setTitleColor:[UIColor colorWithHexString:@"#bbbbbb"] forState:UIControlStateNormal];
    }

}
-(void)timeCount{
    if (self.countNum == 0) {
        [self.timer invalidate];
        self.GetVerificationCode.enabled = YES;
        self.countNum = 60;
        [self.GetVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.GetVerificationCode setTitleColor:[UIColor colorWithHexString:Colorblue] forState:UIControlStateNormal];
    }else{
        self.countNum --;
        [self.GetVerificationCode setTitle:[NSString stringWithFormat:@"%luS",self.countNum] forState:UIControlStateNormal];
    }
    
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(25,self.verificationCode.bottom+58, self.view.width-50, 44.5);
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 44*0.16;
        [_sureBtn setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    return _sureBtn;
}
//#pragma 控制文本框输入起始位置
-(void)sureBtn:(UIButton *)btn{
    
}
-(NSString *)title{
    return @"更改手机号";
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_PhoneTextField resignFirstResponder];
    [_verificationCode resignFirstResponder];
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

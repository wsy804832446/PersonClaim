//
//  ForgetPassWordViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/10/12.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "MyTextField.h"
#import "SMS_SDK/SMSSDK.h"
#import "NewPassWordViewController.h"
@interface ForgetPassWordViewController ()<UITextFieldDelegate>
//手机号
@property (nonatomic,strong)MyTextField *txtPhone;
//请输验证码
@property (nonatomic,strong)MyTextField *txtVerificationCode;
//下一步
@property (nonatomic,strong)UIButton *btnNext;
//获取验证码
@property (nonatomic,strong)UIButton *GetVerificationCode;
//倒计时数字
@property (nonatomic,assign)NSInteger countNum;
//计时器
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"下一步"];
    self.countNum = 60;
    [self.view addSubview:self.txtPhone];
    [self.view addSubview:self.txtVerificationCode];
    [self.view addSubview:self.GetVerificationCode];
    [self.view addSubview:self.btnNext];
    self.view.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    [self.navigationController setNavigationBarHidden:NO];
    // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    NewPassWordViewController *vc = [[NewPassWordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(MyTextField *)txtPhone{
    if (!_txtPhone) {
        _txtPhone = [[MyTextField alloc]initWithFrame:CGRectMake(75/2, 104,DeviceSize.width-75, 44)];
        _txtPhone.placeholder= @"工号/手机号";
        _txtPhone.layer.masksToBounds = YES;
        _txtPhone.delegate = self;
        _txtPhone.layer.cornerRadius = 5;
        _txtPhone.layer.borderWidth = 1;
        _txtPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtPhone.layer.borderColor = [UIColor colorWithHexString:placeHoldColor].CGColor;
        _txtPhone.tag = 3000;
        _txtPhone.clearButtonMode =UITextFieldViewModeWhileEditing;
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2"]];
        icon.tag = 2000;
        icon.frame = CGRectMake(7, 12, 20, 20);
        [_txtPhone addSubview:icon];
        _txtPhone.inset = 34;
    }
    return _txtPhone;
}
-(MyTextField *)txtVerificationCode{
    if (!_txtVerificationCode) {
        _txtVerificationCode = [[MyTextField alloc]initWithFrame:CGRectMake(_txtPhone.left, _txtPhone.bottom+15, _txtPhone.width/2, 44)];
        _txtVerificationCode.placeholder= @"请输入密码";
        _txtVerificationCode.delegate = self;
        _txtVerificationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtVerificationCode.layer.masksToBounds = YES;
        _txtVerificationCode.layer.cornerRadius = 5;
        _txtVerificationCode.layer.borderWidth = 1;
        _txtVerificationCode.layer.borderColor = [UIColor colorWithHexString:placeHoldColor].CGColor;
        _txtVerificationCode.tag = 3001;
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"4"]];
        icon.tag = 2001;
        icon.frame = CGRectMake(7, 12, 20, 20);
        [_txtVerificationCode addSubview:icon];
        _txtVerificationCode.inset = 34;
    }
    return _txtVerificationCode;
}
-(UIButton *)GetVerificationCode{
    if (!_GetVerificationCode) {
        _GetVerificationCode = [UIButton buttonWithType:UIButtonTypeCustom];
        _GetVerificationCode.frame = CGRectMake(self.txtVerificationCode.right+15, self.txtVerificationCode.top,self.txtVerificationCode.width-15,self.txtVerificationCode.height);
        [_GetVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _GetVerificationCode.titleLabel.font = [UIFont systemFontOfSize:15];
        _GetVerificationCode.layer.masksToBounds = YES;
        _GetVerificationCode.layer.cornerRadius = 5;
        [_GetVerificationCode setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
        [_GetVerificationCode setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
        [_GetVerificationCode addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _GetVerificationCode;
}
//获取验证码
-(void)btnClick:(UIButton *)btn{
    if (self.countNum == 60) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.txtPhone.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
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

-(NSString *)title{
    return @"忘记密码";
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UIImageView *view = [self.view viewWithTag:textField.tag-1000];
    if (textField.tag == 3000) {
        view.image = [UIImage imageNamed:@"2-1"];
    }else{
        view.image = [UIImage imageNamed:@"4-1"];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    UIImageView *view = [self.view viewWithTag:textField.tag-1000];
    if (textField.tag == 3000) {
        view.image = [UIImage imageNamed:@"2"];
    }else{
        view.image = [UIImage imageNamed:@"4"];
    }
}
-(UIButton *)btnNext{
    if (!_btnNext) {
        _btnNext = [UIButton buttonWithType:UIButtonTypeCustom ];
        _btnNext.frame = CGRectMake(_txtPhone.left, _txtVerificationCode.bottom+44, _txtPhone.width, 49);
        [_btnNext setTitle:@"下一步" forState:UIControlStateNormal];
        [_btnNext setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
        [_btnNext setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
        [_btnNext addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        _btnNext.layer.masksToBounds = YES;
        _btnNext.layer.cornerRadius = 5;
    }
    return _btnNext;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_txtPhone resignFirstResponder];
    [_txtVerificationCode resignFirstResponder];
    
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

//
//  LoginViewController.m
//  PersonClaim
//
//  Created by 王晟宇 on 16/9/27.
//  Copyright © 2016年 jingyoutimes. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "MyTextField.h"
#import "SMS_SDK/SMSSDK.h"
#import "ForgetPassWordViewController.h"
#import "PersonInfoModel.h"
@interface LoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)TPKeyboardAvoidingScrollView *loginView;
//白板配合logonview使用
@property (nonatomic,strong)UIView *emptyView;
//输入信息view
@property(nonatomic,strong)UIScrollView *scrollView;
//账号登录选项
@property (nonatomic,strong)UIButton *btnAccount;
//短信验证码登录选项
@property (nonatomic,strong)UIButton *btnPhoneMessage;
//滑条
@property (nonatomic,strong)UIView *bottomView;
//选项数组
@property (nonatomic,strong)NSMutableArray *btnArray;
//账号 (通过MyTextField重写placeholder位置) tag 3000
@property (nonatomic,strong)MyTextField *accountField;
//密码 tag 3001
@property (nonatomic,strong)MyTextField *passWordField;
//手机号 tag 3002
@property (nonatomic,strong)MyTextField *phoneField;
//请输验证码
@property (nonatomic,strong)MyTextField *VerificationCodeField;
//登录按钮
@property (nonatomic,strong)UIButton *btnLogin;
//忘记密码
@property (nonatomic,strong)UIButton *btnForgetPassWord;
//获取验证码
@property (nonatomic,strong)UIButton *GetVerificationCode;
//倒计时数字
@property (nonatomic,assign)NSInteger countNum;
//计时器
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self.navigationController setNavigationBarHidden:YES];
    
    //倒计时60s
    self.countNum = 60;
    // Do any additional setup after loading the view.
}
-(void)createUI{
    //大图
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 248)];
    self.imgView.image = [UIImage imageNamed:@"1-切图"];
    [self.view addSubview:self.imgView];
    //小图
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.width-89)/2, 90, 89, 108)];
    imgView2.image = [UIImage imageNamed:@"登录icon"];
    [self.view addSubview:imgView2];
    [self.view addSubview:self.loginView];
    [_loginView addSubview:self.emptyView];
    [self Addseg];
}
-(void)Addseg
{
    [self.emptyView addSubview:self.btnAccount];
    [self.emptyView addSubview:self.btnPhoneMessage];
    [self.emptyView addSubview:self.bottomView];
    UIView *buttonDown=[[UIView alloc]initWithFrame:CGRectMake(_btnAccount.left, _btnAccount.bottom+10,_btnAccount.width*2, 1)];
    [buttonDown setBackgroundColor:[UIColor colorWithHexString:@"#dddddd"]];
    [self.emptyView addSubview:buttonDown];
    [self.emptyView addSubview:self.scrollView];
    [self.scrollView addSubview:self.accountField];
    [self.scrollView addSubview:self.passWordField];
    [self.scrollView addSubview:self.phoneField];
    [self.scrollView addSubview:self.VerificationCodeField];
    [self.btnArray addObject:self.btnAccount];
    [self.btnArray addObject:self.btnPhoneMessage];
    [self.emptyView addSubview:self.btnLogin];
    [self.scrollView addSubview:self.btnForgetPassWord];
    [self.scrollView addSubview:self.GetVerificationCode];
}

-(UIButton *)btnAccount{
    if (!_btnAccount) {
        _btnAccount =[[UIButton alloc]initWithFrame:CGRectMake(75/2,30,(self.view.width-75)/2, 33)];
        [_btnAccount setTitle:@"账号登录" forState:UIControlStateNormal];
        [_btnAccount.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btnAccount setTitleColor:[UIColor colorWithHexString:Colorgray] forState:UIControlStateNormal];
        [_btnAccount setTitleColor:[UIColor colorWithHexString:Colorblue] forState:UIControlStateSelected];
        [_btnAccount addTarget:self action:@selector(changeTheSegument:) forControlEvents:UIControlEventTouchUpInside];
        _btnAccount.selected = YES;
        _btnAccount.tag = 1000;
    }
    return _btnAccount;
}
-(UIButton *)btnPhoneMessage{
    if (!_btnPhoneMessage) {
        _btnPhoneMessage =[[UIButton alloc]initWithFrame:CGRectMake(_btnAccount.right,_btnAccount.top,_btnAccount.width, 33)];
        [_btnPhoneMessage setTitle:@"短信验证码登录" forState:UIControlStateNormal];
        [_btnPhoneMessage.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btnPhoneMessage setTitleColor:[UIColor colorWithHexString:Colorgray] forState:UIControlStateNormal];
        [_btnPhoneMessage setTitleColor:[UIColor colorWithHexString:Colorblue] forState:UIControlStateSelected];
        [_btnPhoneMessage addTarget:self action:@selector(changeTheSegument:) forControlEvents:UIControlEventTouchUpInside];
        _btnPhoneMessage.tag = 1001;
    }
    return _btnPhoneMessage;
}
-(void)changeTheSegument:(UIButton *)btn{
    if (!btn.selected) {
        if (btn.tag == 1001) {
            self.scrollView.contentOffset = CGPointMake(DeviceSize.width, 0);
        }else{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
        btn.selected = YES;
    }
    for (UIButton *button in self.btnArray) {
        if (button.tag != btn.tag) {
            button.selected = NO;
        }else{
            button.selected = YES;
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        _bottomView.frame = CGRectMake(btn.left, _bottomView.origin.y, _bottomView.size.width, _bottomView.size.height);
    }];
}
-(NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
-(MyTextField *)accountField{
    if (!_accountField) {
        _accountField = [[MyTextField alloc]initWithFrame:CGRectMake(_btnAccount.left,20, _btnAccount.width*2, 44)];
        _accountField.placeholder= @"工号/手机号";
        _accountField.layer.masksToBounds = YES;
        _accountField.delegate = self;
        _accountField.layer.cornerRadius = 5;
        _accountField.layer.borderWidth = 1;
        _accountField.layer.borderColor = [UIColor colorWithHexString:placeHoldColor].CGColor;
        _accountField.tag = 3000;
        [_accountField addTarget:self action:@selector(txtChange:) forControlEvents:UIControlEventEditingChanged];
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
        _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        icon.tag = 2000;
        icon.frame = CGRectMake(7, 12, 20, 20);
        [_accountField addSubview:icon];
        _accountField.inset = 34;
    }
    return _accountField;
}
-(MyTextField *)passWordField{
    if (!_passWordField) {
        _passWordField = [[MyTextField alloc]initWithFrame:CGRectMake(_btnAccount.left, _accountField.bottom+14, _btnAccount.width*2, 44)];
        _passWordField.placeholder= @"请输入密码";
        _passWordField.delegate = self;
        [_passWordField setSecureTextEntry:YES];
        _passWordField.layer.masksToBounds = YES;
        _passWordField.layer.cornerRadius = 5;
        _passWordField.layer.borderWidth = 1;
        _passWordField.layer.borderColor = [UIColor colorWithHexString:placeHoldColor].CGColor;
        _passWordField.tag = 3001;
        _passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_passWordField addTarget:self action:@selector(txtChange:) forControlEvents:UIControlEventEditingChanged];
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3"]];
        icon.tag = 2001;
        icon.frame = CGRectMake(7, 12, 20, 20);
        [_passWordField addSubview:icon];
        _passWordField.inset = 34;
    }
    return _passWordField;
}
-(MyTextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[MyTextField alloc]initWithFrame:CGRectMake(_btnAccount.left+DeviceSize.width,20, _btnAccount.width*2, 44)];
        _phoneField.placeholder= @"手机号";
        _phoneField.layer.masksToBounds = YES;
        _phoneField.delegate = self;
        _phoneField.layer.cornerRadius = 5;
        _phoneField.layer.borderWidth = 1;
        _phoneField.layer.borderColor = [UIColor colorWithHexString:placeHoldColor].CGColor;
        _phoneField.tag = 3002;
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2"]];
        _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        icon.tag = 2002;
        icon.frame = CGRectMake(7, 12, 20, 20);
        [_phoneField addSubview:icon];
        _phoneField.inset = 34;
    }
    return _phoneField;
}
-(MyTextField *)VerificationCodeField{
    if (!_VerificationCodeField) {
        _VerificationCodeField = [[MyTextField alloc]initWithFrame:CGRectMake(_phoneField.left, _phoneField.bottom+14, _btnAccount.width, 44)];
        _VerificationCodeField.placeholder= @"请输验证码";
        _VerificationCodeField.delegate = self;
        _VerificationCodeField.layer.masksToBounds = YES;
        _VerificationCodeField.layer.cornerRadius = 5;
        _VerificationCodeField.layer.borderWidth = 1;
        _VerificationCodeField.layer.borderColor = [UIColor colorWithHexString:placeHoldColor].CGColor;
        _VerificationCodeField.tag = 3003;
        _VerificationCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"4"]];
        icon.tag = 2003;
        icon.frame = CGRectMake(7, 12, 20, 20);
        [_VerificationCodeField addSubview:icon];
        _VerificationCodeField.inset = 34;
    }
    return _VerificationCodeField;
}

//重写placeholder位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+34, bounds.origin.y, bounds.size.width -34, bounds.size.height);//更好理解些
    return inset;
}

-(TPKeyboardAvoidingScrollView *)loginView{
    if (!_loginView) {
        _loginView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceSize.width, DeviceSize.height)];
        [_loginView setContentSize:CGSizeMake(DeviceSize.width,  DeviceSize.height)];
    }
    return _loginView;
}
-(UIView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, _imgView.bottom, DeviceSize.width, DeviceSize.height-248)];
        _emptyView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    }
    return _emptyView;
}
-(UIButton *)btnLogin{
    if (!_btnLogin) {
        _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom ];
        _btnLogin.frame = CGRectMake(_accountField.left, _scrollView.bottom, _accountField.width, 49);
        [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        [_btnLogin setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
        [_btnLogin setTitleColor:[UIColor colorWithHexString:unEnableColor] forState:UIControlStateDisabled];
        [_btnLogin setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
        [_btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        _btnLogin.layer.masksToBounds = YES;
        _btnLogin.layer.cornerRadius = 5;
        _btnLogin.enabled = NO;
    }
    return _btnLogin;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UIImageView *view = [self.view viewWithTag:textField.tag-1000];
    switch (textField.tag) {
        case 3000:
            view.image = [UIImage imageNamed:@"1-1"];
            break;
        case 3001:
            view.image = [UIImage imageNamed:@"3-1"];
            break;
        case 3002:
            view.image = [UIImage imageNamed:@"2-1"];
            break;
        case 3003:
            view.image = [UIImage imageNamed:@"4-1"];
            break;
        default:
            break;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
     UIImageView *view = [self.view viewWithTag:textField.tag-1000];
    switch (textField.tag) {
        case 3000:
            view.image = [UIImage imageNamed:@"1"];
            break;
        case 3001:
            view.image = [UIImage imageNamed:@"3"];
            break;
        case 3002:
            view.image = [UIImage imageNamed:@"2"];
            break;
        case 3003:
            view.image = [UIImage imageNamed:@"4"];
            break;
        default:
            break;
    }
}
-(void)login:(UIButton *)btn{
//    TabBarViewController *tabVc = [[TabBarViewController alloc]init];
//    [self presentViewController:tabVc animated:YES completion:nil];
    if (self.btnAccount.selected) {
        WeakSelf(LoginViewController);
        [weakSelf showHudWaitingView:WaitPrompt];
        [[NetWorkManager shareNetWork]LoginWithAccount:self.accountField.text andPassword:self.passWordField.text andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
            [weakSelf removeMBProgressHudInManaual];
            if ([response.responseCode isEqual:@"1"] ) {
                [CommUtil saveData:@"0131002498" andSaveFileName:@"account"];
                PersonInfoModel *model = [response thParseDataFromDic:response.dataDic andModel:[PersonInfoModel class]];
                [CommUtil saveData:model andSaveFileName:[NSString stringWithFormat:@"PersonInfoModel%@",[CommUtil readDataWithFileName:@"account"]]];
                TabBarViewController *tabVc = [[TabBarViewController alloc]init];
                [weakSelf presentViewController:tabVc animated:YES completion:nil];
               
            }else{
                [self showHudAuto:response.message];
            }
        } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
            [weakSelf removeMBProgressHudInManaual];
            [self showHudAuto:InternetFailerPrompt];
        }];
    }else if(self.btnPhoneMessage.selected){
        
    }
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(_btnAccount.left, _btnAccount.bottom+7, _btnAccount.width, 4)];
        _bottomView.backgroundColor = [UIColor colorWithHexString:Colorblue];
    }
    return _bottomView;
}
-(UIButton *)btnForgetPassWord{
    if (!_btnForgetPassWord) {
        _btnForgetPassWord = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnForgetPassWord setTitle:@"忘记密码?" forState:UIControlStateNormal];
        CGFloat BtnWidth =_btnForgetPassWord.titleLabel.text.length*16;
        _btnForgetPassWord.frame = CGRectMake(_passWordField.right-BtnWidth,_passWordField.bottom+14,BtnWidth, 16);
        [_btnForgetPassWord setTitleColor:[UIColor colorWithHexString:Colorblue] forState:UIControlStateNormal];
        _btnForgetPassWord.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnForgetPassWord addTarget:self action:@selector(forgetPassWord) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btnForgetPassWord;
}
-(void)forgetPassWord{
    ForgetPassWordViewController *vc = [[ForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(UIButton *)GetVerificationCode{
    if (!_GetVerificationCode) {
        _GetVerificationCode = [UIButton buttonWithType:UIButtonTypeCustom];
        _GetVerificationCode.frame = CGRectMake(self.VerificationCodeField.right+15, self.VerificationCodeField.top,self.VerificationCodeField.width-15,self.VerificationCodeField.height);
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
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.accountField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
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
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,_btnAccount.bottom+11, DeviceSize.width, 166)];
        _scrollView.contentSize = CGSizeMake(2*DeviceSize.width, _scrollView.height);
        _scrollView.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UIButton *btn = [self.view viewWithTag:scrollView.contentOffset.x/DeviceSize.width+1000];
    [self changeTheSegument:btn];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 3000) {
        if (range.location>16) {
            return NO;
        }
    }
    NSString *accountRegex = @"^[^\u4e00-\u9fa5]{0,}$";
    NSPredicate *accountText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",accountRegex];
    return [accountText evaluateWithObject:string];
}
-(void)txtChange:(UITextField *)txt{
    if (_btnAccount.selected) {
        if (_accountField.text.length>=1&&_passWordField.text.length>=1) {
            _btnLogin.enabled = YES;
        }else{
            _btnLogin.enabled = NO;
        }
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

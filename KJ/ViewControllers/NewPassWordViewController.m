//
//  NewPassWordViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/10/12.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "NewPassWordViewController.h"
#import "MyTextField.h"
@interface NewPassWordViewController ()<UITextFieldDelegate>
//新密码
@property (nonatomic,strong)MyTextField *txtNewPassWord;
//确定按钮
@property (nonatomic,strong)UIButton *btnSure;
@end

@implementation NewPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"确定"];
    //初始rightBarButtonItem为enabled
    self.navigationItem.rightBarButtonItem.enabled = NO;
    UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
    [btn setTitleColor:[UIColor colorWithHexString:unEnableColor] forState:UIControlStateNormal];
    [self.view addSubview:self.txtNewPassWord];
    [self.view addSubview:self.btnSure];
    self.view.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{

}
-(MyTextField *)txtNewPassWord{
    if (!_txtNewPassWord) {
        _txtNewPassWord = [[MyTextField alloc]initWithFrame:CGRectMake(75/2, 104,DeviceSize.width-75, 44)];
        _txtNewPassWord.placeholder= @"请输入新密码";
        _txtNewPassWord.layer.masksToBounds = YES;
        _txtNewPassWord.delegate = self;
        _txtNewPassWord.layer.cornerRadius = 5;
        _txtNewPassWord.layer.borderWidth = 1;
        _txtNewPassWord.layer.borderColor = [UIColor colorWithHexString:placeHoldColor].CGColor;
        _txtNewPassWord.tag = 3000;
        _txtNewPassWord.clearButtonMode =UITextFieldViewModeWhileEditing;
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3"]];
        icon.tag = 2000;
        icon.frame = CGRectMake(7, 12, 20, 20);
        [_txtNewPassWord addSubview:icon];
        _txtNewPassWord.inset = 34;
    }
    return _txtNewPassWord;
}
-(UIButton *)btnSure{
    if (!_btnSure) {
        _btnSure = [UIButton buttonWithType:UIButtonTypeCustom ];
        _btnSure.frame = CGRectMake(_txtNewPassWord.left, _txtNewPassWord.bottom+103, _txtNewPassWord.width, 49);
        [_btnSure setTitle:@"确定" forState:UIControlStateNormal];
        [_btnSure setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
        [_btnSure setTitleColor:[UIColor colorWithHexString:unEnableColor] forState:UIControlStateNormal];
        [_btnSure addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        _btnSure.layer.masksToBounds = YES;
        _btnSure.layer.cornerRadius = 5;
        _btnSure.enabled = NO;
    }
    return _btnSure;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UIImageView *view = [self.view viewWithTag:textField.tag-1000];
    view.image = [UIImage imageNamed:@"3-1"];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    UIImageView *view = [self.view viewWithTag:textField.tag-1000];
    view.image = [UIImage imageNamed:@"3"];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqual:@""]&&(textField.text.length == 1)){
        _btnSure.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [_btnSure setTitleColor:[UIColor colorWithHexString:unEnableColor] forState:UIControlStateNormal];
        UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
        [btn setTitleColor:[UIColor colorWithHexString:unEnableColor] forState:UIControlStateNormal];
    }else{
        _btnSure.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [_btnSure setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
        UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
        [btn setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_txtNewPassWord resignFirstResponder];
}
-(NSString *)title{
    return @"新密码";
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

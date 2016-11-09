//
//  NameEditViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/9/28.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "NameEditViewController.h"
#import "MyTextField.h"
@interface NameEditViewController ()
@property (nonatomic,strong)MyTextField *textField;
@end

@implementation NameEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    if (self.pageTitle == 1) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"下一步"];
        [self.view addSubview:self.textField];
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"确定"];
        [self.view addSubview:self.textField];
    }
    //修改密码页面创建下方按钮
    if (self.pageTitle != 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(25, self.view.bottom-360-44.5, self.view.width-50, 44.5);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 44*0.16;
        [btn setBackgroundColor:[UIColor colorWithHexString:Colorblue]];
        [btn setTitleColor:[UIColor colorWithHexString:Colorwhite]forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:)
         forControlEvents:UIControlEventTouchUpInside];
        if (self.pageTitle == 1) {
            [btn setTitle:@"下一步" forState:UIControlStateNormal];
            btn.tag = 1001;
        }else{
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            btn.tag = 1002;
        }
        [self.view addSubview:btn];
    }
// Do any additional setup after loading the view.
}
-(void)btnClick:(UIButton *)btn{
    if (btn.selected) {
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#277cef"]];
    }
    if (btn.tag == 1001) {
        NameEditViewController *vc = [[NameEditViewController alloc]init];
        vc.pageTitle = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    if (self.pageTitle !=1) {
        if (self.block) {
            self.block(self.textField.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        NameEditViewController *vc = [[NameEditViewController alloc]init];
        vc.pageTitle = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(MyTextField *)textField{
    if (!_textField) {
        _textField = [[MyTextField alloc]initWithFrame:CGRectMake(0, 10, self.view.width, 44)];
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        _textField.font = [UIFont systemFontOfSize:15];
        if (self.pageTitle == 1) {
            _textField.placeholder = @"请输入原密码";
        }else if(self.pageTitle == 2){
            _textField.placeholder = @"请输入新密码";
        }
        _textField.inset = 15;
    }
    return _textField;
}
-(NSString *)title{
    if (self.pageTitle == 0) {
        return @"姓名";
    }else{
        return @"修改密码";
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textField resignFirstResponder];
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

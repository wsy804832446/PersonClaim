//
//  FeedbackViewController.m
//  KJ
//
//  Created by 王晟宇 on 16/9/28.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (nonatomic,strong)UITextView *textView;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemExtension leftButtonItem:@selector(leftAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemExtension rightButtonItem:@selector(rightAction) andTarget:self andTitleName:@"提交"];
    [self.view addSubview:self.textView];
    // Do any additional setup after loading the view.
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 10, self.view.width, self.view.height-350-74)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.text = @"请输入你的意见或建议";
    
    }
    return _textView;
}
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请输入你的意见或建议"]) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"请输入你的意见或建议";
    }
}
-(NSString *)title{
    return @"意见反馈";
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
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

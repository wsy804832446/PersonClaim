//
//  AccidentAddressTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/1.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccidentAddressTableViewCell : UITableViewCell
@property (nonatomic,copy)void(^btnClickBlock)(void);
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtDetail;

@property (strong, nonatomic) IBOutlet UIButton *btnMap;
- (IBAction)actionMap:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblPlaceHolder;
@property (strong, nonatomic) IBOutlet UIView *lblLine;


-(void)configCellWithAddress:(NSString *)address;
@end

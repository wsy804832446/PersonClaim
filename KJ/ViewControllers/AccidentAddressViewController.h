//
//  AccidentAddressViewController.h
//  KJ
//
//  Created by 王晟宇 on 16/10/21.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseViewController.h"

@interface AccidentAddressViewController : BaseViewController
@property (nonatomic,copy)void(^selectAddressBlock)(NSString *address);
@end

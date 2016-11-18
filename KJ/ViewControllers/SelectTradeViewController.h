//
//  SelectTradeViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/18.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SelectList.h"
@interface SelectTradeViewController : BaseTableViewController
@property (nonatomic,copy)void (^SelectIdentityBlock)(SelectList *model);
@end

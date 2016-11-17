//
//  CareIdentityViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/17.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SelectList.h"
@interface CareIdentityViewController : BaseTableViewController
@property (nonatomic,copy)void (^SelectIdentityBlock)(SelectList *model);
@end

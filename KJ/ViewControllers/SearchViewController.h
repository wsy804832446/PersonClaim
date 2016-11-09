//
//  SearchViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/10/25.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SearchViewController : BaseTableViewController
@property(nonatomic,copy)void(^searchBlock)(NSString *key);
@end

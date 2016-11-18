//
//  SelectItemViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/18.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SelectItemViewController : BaseTableViewController
@property (nonatomic,copy)NSString *itemName;

@property (nonatomic,copy)void(^selectItemBlock)(ItemTypeModel *item);
@end

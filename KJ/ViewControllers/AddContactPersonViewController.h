//
//  AddContactPersonViewController.h
//  KJ
//
//  Created by 王晟宇 on 16/10/20.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseViewController.h"

@interface AddContactPersonViewController : BaseViewController
//通讯录添加联系人回调
@property(nonatomic,copy)void(^contactBlock)(NSString *name,NSString *phone);
//保存返回的联系人数组
@property(nonatomic,copy)void(^saveContactBlock)(NSMutableArray *array);
@end

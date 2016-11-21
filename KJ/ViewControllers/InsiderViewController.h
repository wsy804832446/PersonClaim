//
//  InsiderViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/21.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseViewController.h"

@interface InsiderViewController : BaseViewController
//通讯录添加联系人回调
@property(nonatomic,copy)void(^contactBlock)(NSString *name,NSString *phone);
//保存返回的询问人数组
@property(nonatomic,copy)void(^saveInsiderBlock)(NSMutableArray *array);
@end

//
//  FollowEditTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 16/10/19.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,titleType) {
    //事故所在区域
    accidentAddress = 0,
    //详细地址
    detailedAddress =1,
    //事故时间
    accidentTime = 2,
    //联系人
    contactPerson = 3,
    //事故详细信息
    detailInfo = 4,
    //影像资料
    photoInfo = 5,
    //备注信息
    remark =6
    //
};
@interface FollowEditTableViewCell : UITableViewCell
//cell标题 通过它对应cell布局
@property (nonatomic,assign)titleType title;
@end

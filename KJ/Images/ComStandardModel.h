//
//  ComStandardModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/12/6.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"

@interface ComStandardModel : MTLModel<MTLJSONSerializing>
//农村
@property (nonatomic,strong)NSDictionary *compensateStandardDTO;
//城镇
@property (nonatomic,strong)NSDictionary *spDenizenIncomeNormDTO;
@end


@interface CompensatStandard : MTLModel<MTLJSONSerializing>
//误工费
@property (nonatomic,assign)CGFloat lostIncome;
//护理费
@property (nonatomic,assign)CGFloat standardNurseFee;
//住院伙食补助
@property (nonatomic,assign)CGFloat hospitalFoodSubsidies;
//营养费
@property (nonatomic,assign)CGFloat thesePayments;
//交通费
@property (nonatomic,assign)CGFloat transportationFee;
//住宿费
@property (nonatomic,assign)CGFloat accommodationFee;
@end


@interface DenizenIncomeNorm : MTLModel<MTLJSONSerializing>
@property (nonatomic,assign)CGFloat residentNature;
//城镇人均可支配收入
@property (nonatomic,assign)CGFloat urbanDisposableIncome;
//城镇消费性支出
@property (nonatomic,assign)CGFloat urbanAverageOutlay;
//在岗职工收入标准
@property (nonatomic,assign)CGFloat urbanSalary;
//农村人均纯收入
@property (nonatomic,assign)CGFloat ruralNetIncome;
//农村工资收入
@property (nonatomic,assign)CGFloat ruralSalary;
//农村生活支出
@property (nonatomic,assign)CGFloat ruralAverageOutlay;
@end





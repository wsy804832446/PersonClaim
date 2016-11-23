//
//  EditInfoModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/2.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"
#import "SelectList.h"
#import "CityModel.h"
@interface EditInfoModel : MTLModel<MTLJSONSerializing>
//所有模块共用
  //备注
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *userCode;
  //影像资料
@property(nonatomic,strong)NSMutableArray *imageArray;
  //完成情况
@property(nonatomic,strong)ItemTypeModel *finishFlag;

//事故基本信息
  //地址
@property(nonatomic,copy)NSString *address;
  //联系人
@property(nonatomic,copy)NSArray *contactPersonArray;
  //事故日期
@property(nonatomic,copy)NSString *accidentDate;
  //事故详细信息
@property(nonatomic,copy)NSString *detailInfo;

//事故处理情况
  //事故处理人
@property(nonatomic,copy)NSString *dealName;
  //处理结果
@property(nonatomic,copy)NSString *dealResult;
  //事故处理时间
@property(nonatomic,copy)NSString *dealDate;
  //联系人
@property(nonatomic,copy)NSArray *dealContactPersonArray;

//医疗探视
  //医院
@property(nonatomic,strong)NSMutableArray *hosArray;
  //诊断
@property(nonatomic,strong)NSMutableArray *diaArray;
  //护理人
@property(nonatomic,strong)NSMutableArray *carePeopleArray;
  //已发生医疗费
@property(nonatomic,assign)CGFloat feePass;


//收入情况(误工情况)
  //行业
@property(nonatomic,strong)SelectList *tradeModel;
  //入职时间
@property(nonatomic,copy)NSString *takingWorkDate;
  //离职时间
@property(nonatomic,copy)NSString *offWorkDate;
  //月收入
@property(nonatomic,assign)CGFloat monthIncome;
  //单位名称
@property(nonatomic,copy)NSString *UnitName;
  //单位地址
@property(nonatomic,copy)NSString *UnitAddress;
  //在职情况
@property(nonatomic,strong)ItemTypeModel *jobState;
  //劳动合同
@property(nonatomic,strong)ItemTypeModel *labourContract;
  //收入发放形式
@property(nonatomic,strong)ItemTypeModel *getMoney;
  //社保
@property(nonatomic,strong)ItemTypeModel *socialSecurity;
  //实际休息天数(误工)
@property(nonatomic,assign)NSInteger restDays;
  //收入减少金额(误工)
@property(nonatomic,assign)CGFloat incomeDecreases;
;
  //联系人
@property(nonatomic,copy)NSArray *IncomeContactPersonArray;

//死亡信息
  //死亡原因
@property(nonatomic,strong)SelectList *deathReason;
  //参与度
@property(nonatomic,copy)NSString *lnvolvement;
  //死亡日期
@property(nonatomic,copy)NSString *deathDate;
  //死亡地点
@property(nonatomic,copy)NSString *deathAddress;


//户籍信息
  //户籍地
@property(nonatomic,strong)CityModel *household;
  //父亲
@property(nonatomic,strong)ItemTypeModel *fatherExt;
  //母亲
@property(nonatomic,strong)ItemTypeModel *matherExt;
  //户籍类型
@property(nonatomic,strong)SelectList *householdType;
  //子女数量
@property(nonatomic,copy)NSString *sonCount;
  //兄弟数量
@property(nonatomic,copy)NSString *bratherCount;
  //是否户籍地居住
@property(nonatomic,strong)ItemTypeModel *addressBeTrue;
  //被询问人
@property(nonatomic,copy)NSArray *insiderPersonArray;
  //开始居住时间
@property(nonatomic,copy)NSString *liveStartDate;
  //结束居住时间
@property(nonatomic,copy)NSString *liveEndDate;
  //连续居住年限
  //居住地址
@property(nonatomic,copy)NSString *houseAddress;




//被扶养人
  //被扶养人
@property (nonatomic,strong) NSArray *upBringArray;
  //伤残赔偿系数
@property (nonatomic,copy)NSString *ratio;
  //抚养费金额
@property (nonatomic,copy)NSString *maintenance;

@end

@interface imageModel : MTLModel
@property (nonatomic,copy)NSString *imgName;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,copy)NSString *imgBase64;
@property (nonatomic,assign)BOOL isUpload;
@end

//
//  BaseTableViewController.h
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
//  页数索引
@property (nonatomic, assign)   NSInteger pageNO;
//  每页显示多少条
@property (nonatomic, assign)   NSInteger pageSize;
//  是否还有没有显示的数据
@property (nonatomic, assign, readonly)   BOOL isEndForLoadmore;
//  数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong, readonly) UITableView *tableView;

//  开启头部刷新
@property (nonatomic, assign)   BOOL isOpenHeaderRefresh;
//  开启脚部刷新
@property (nonatomic, assign)   BOOL isOpenFooterRefresh;
//  根据tableview样式创建tableview
- (id)initWithTableViewStyle:(UITableViewStyle)tableViewStyle;

//  头部刷新请求（子类需要重新）
- (void)headerRequestWithData;
//  脚部刷新请求（子类需要重新）
- (void)footerRequestWithData;
@end

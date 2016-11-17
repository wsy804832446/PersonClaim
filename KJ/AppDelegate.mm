//
//  AppDelegate.m
//  PersonClaim
//
//  Created by 王晟宇 on 16/9/27.
//  Copyright © 2016年 jingyoutimes. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SMS_SDK/SMSSDK.h"
#import "SelectCityViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "SelectList.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1.0];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //开启百度地图功能
    [self StartBaiduMap];
    //开启手机验证码功能
    [self StartSMSSdk];
    LoginViewController *loginVc = [[LoginViewController alloc]init];
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
    self.window.rootViewController =Nav;
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"e909557cf2d3d41a1e786e91809d1ed2"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"e909557cf2d3d41a1e786e91809d1ed2"];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    //拉取城市数据保存到本地
    NSArray *cityArray =[CommUtil readDataWithFileName:localCity];
    if (cityArray.count == 0) {
        [self getCity];
    }
    //拉取选择信息数据保存到本地
    NSArray *selectListArray =[CommUtil readDataWithFileName:localSelectArry];
    if (selectListArray.count == 0) {
         [self getSelectList];
    }
    return YES;
}
-(void)getSelectList{
    [[NetWorkManager shareNetWork]getSelectListWithCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        if ([response.responseCode isEqual:@"1"]) {
            NSMutableArray *selectListArray = [NSMutableArray array];
            for (NSDictionary *dic in response.dataDic[@"dictList"]) {
                SelectList *model = [MTLJSONAdapter modelOfClass:[SelectList class] fromJSONDictionary:dic error:NULL];
                [selectListArray addObject:model];
            }
             [CommUtil saveData:selectListArray andSaveFileName:localSelectArry];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        
    }];
}
-(void)getCity{
    [[NetWorkManager shareNetWork]getCityListWithSearchCode:@"" andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        if ([response.responseCode isEqual:@"1"]) {
            //无层级城市model
            NSMutableArray *cityArr = [NSMutableArray array];
            for (NSDictionary *dic in response.dataArray) {
                CityModel *model = [MTLJSONAdapter modelOfClass:[CityModel class]fromJSONDictionary:dic error:NULL];
                [cityArr addObject:model];
            }
            [CommUtil saveData:cityArr andSaveFileName:localCity];
            //整理城市层级
            CityModel *countryModel;
            CityModel *provinceModel;
            for (int i=0; i<cityArr.count; i++) {
                CityModel *model = cityArr[i];
                if ([model.level isEqual:@"1"]){
                    countryModel = model;
                }else if ([model.level isEqual:@"2"]) {
                    provinceModel = model;
                    [countryModel.array addObject:provinceModel];
                }else if ([model.level isEqual:@"3"]){
                    [provinceModel.array addObject:model];
                }
            }
            [CommUtil saveData:countryModel andSaveFileName:@"cityList"];
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        
    }];
}
-(void)StartBaiduMap{
    BMKMapManager* mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:@"ETH27K88aVOlzRgFbCTIfEYq4RE83Bbf"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
-(void)StartSMSSdk{
    [SMSSDK registerApp:@"17927d6ff7e1e"
             withSecret:@"66df3cad6a7620c88c140df170e6b145"];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

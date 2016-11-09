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
@interface AppDelegate ()<CLLocationManagerDelegate>

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
    [self OpenLocation];
    //拉取城市数据保存到本地
    [[NetWorkManager shareNetWork]getCityListWithSearchCode:@"" andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        if ([response.responseCode isEqual:@"1"]) {
            CityModel *countryModel;
            CityModel *provinceModel;
            for (int i=0; i<response.dataArray.count; i++) {
                 CityModel *model = [MTLJSONAdapter modelOfClass:[CityModel class] fromJSONDictionary:response.dataArray[i] error:NULL];
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
    return YES;
}
-(void)OpenLocation{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"允许人伤跟踪系统在您使用该应用时，访问您的位置吗?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *call = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //定位功能可用，开始定位
                CLLocationManager * locationManger = [[CLLocationManager alloc] init];
                locationManger.delegate = self;
                [locationManger startUpdatingLocation];
            }];
            [alert addAction:cancel];
            [alert addAction:call];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"打开定位服务来允许人伤跟踪系统确定您的位置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *call = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alert addAction:cancel];
            [alert addAction:call];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
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

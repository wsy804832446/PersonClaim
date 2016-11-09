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
@interface AppDelegate ()<CLLocationManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:3.0];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //开启百度地图功能
//    [self StartBaiduMap];
    [self StartSMSSdk];
    LoginViewController *loginVc = [[LoginViewController alloc]init];
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
    self.window.rootViewController =Nav;
    return YES;
}
-(void)isOpenLocation{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            CLLocationManager * locationManger = [[CLLocationManager alloc] init];
            locationManger.delegate = self;
            [locationManger startUpdatingLocation];
        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
    }
}
-(void)Alert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"允许xxx在您使用该应用时，访问您的位置吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SelectCityViewController *vc = [[SelectCityViewController alloc]init];
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    
}
//-(void)StartBaiduMap{
//    BMKMapManager* mapManager = [[BMKMapManager alloc]init];
//    BOOL ret = [mapManager start:@"ETH27K88aVOlzRgFbCTIfEYq4RE83Bbf"  generalDelegate:nil];
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }
//}
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

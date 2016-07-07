//
//  AppDelegate.m
//  高德地图
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 Mr.wu. All rights reserved.
//

#import "AppDelegate.h"
#import "PinViewController.h"
#import "lineOfPointVC.h"
#import "AddressViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    /*******************************************
     *         ios8.0以后需请求用户授权           *
     *       通过创建CLLocationManager实现       *
     ******************************************/
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    
    //自定义大头针注释图
//    self.window.rootViewController= [[PinViewController alloc] init];
    
    ///两点间地图画线
    //1. 编写代码在地图上画出当前位置到指定目标位置的线条, 自定义两个大头针注释图，左边是个文本框，右边是一个按钮，当点击大头针时在文本框里显示位置具体信息(国家、省份、城市、街道)，点击按钮时文本框里显示具体经纬度信息。
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[lineOfPointVC alloc] init]];
//    self.window.rootViewController = nav;
    
    //2 . 写一个路线搜索demo，包含界面信息如下：起始输入框，目标输入框，查询按钮。默认情况下地图显示当前位置信息(效果：有个闪动点)。输入起始地址，目标地址，点击查询按钮，地图显示两地址之间的路径并用系统大头针标注，路线颜色为绿色。点击大头针时弹出注释图，左边显示一个风景缩略图，右边显示当前风景点的简单描述(注：描述自己随意写)。点击缩略图时弹出一个视图控制器，包括一组可左右滑动的图片，最下方是一个黑色半透明的文本框，展示当前风景点详情(注：风景点详情自己随意写)。
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[AddressViewController alloc] init]];
    self.window.rootViewController = nav;
    
    return YES;
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


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            
            if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];///
            }
            break;
            
        default:
            break;
    }
}



@end

//
//  AppDelegate.h
//  高德地图
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 Mr.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong ,nonatomic) CLLocationManager *locationManager;

@end


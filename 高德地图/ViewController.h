//
//  ViewController.h
//  高德地图
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 Mr.wu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>


@interface ViewController : UIViewController<MAMapViewDelegate>

@property (nonatomic,strong)MAMapView  *mapView;///高德地图对象

@property (nonatomic,strong)MAPointAnnotation *pointAnnotation;///定义一个大头针


@end


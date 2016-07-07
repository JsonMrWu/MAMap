//
//  PinViewController.h
//  高德地图
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 Mr.wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "empty.h"
#import "myAnnotationView.h"
#import "myPointAnnotation.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface PinViewController : UIViewController<MAMapViewDelegate,myAnnotationViewDelegate,AMapSearchDelegate>


@property (nonatomic,strong)MAMapView *mapview;///高德地图对象


@property (nonatomic,strong)NSString *name;


@property (nonatomic,strong)CLGeocoder *geocoder;


@property (nonatomic,strong)empty *emp;


@property (nonatomic,strong)myPointAnnotation *myPointAnnotataion;

@property (nonatomic,strong)MAPointAnnotation *pointAnnitation;

@property (nonatomic,strong)AMapSearchAPI *searchAPI;
@property (nonatomic,strong)AMapReGeocodeSearchRequest *geo;///


@property (nonatomic,assign)CLLocationCoordinate2D coord;////用于检测
@end

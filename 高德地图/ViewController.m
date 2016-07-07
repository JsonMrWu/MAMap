//
//  ViewController.m
//  高德地图
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 Mr.wu. All rights reserved.
//

/**   使用高德地图
 *1、下载高德地图 4.0 登录开发者账号 申请 key*
 *2、导入系统库13个库文件*
 *3、导入头文件<CoreLocation/CoreLocation.h> 获取系统授权 *
 *4、导入系统文件<MAMapKit/MAMapKit.h><AMapFoundationKit/AMapFoundationKit.h> 创建高德地图对象*
 *5、配置用户 key：[AMapServices sharedServices].apiKey = KeyPath*
    ** 创建一个 pch 文件
     * New File->Other->PCH File->定义宏->Builed Setting->prefix header->./高德地图/FrameWork/PrefixHeader.pch 路径*
 *6、实例化高德地图对象，设代理*
 *7、设置跟随用户的模式 （三种：不动，跟随，跟随和方向）setUserTrackingMode*
 *8、显示当前位置 showsUserLocation*
 *9、定位位置更新成功 didUpdateUserLocation 失败 didFailToLocateUserWithError*
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ///aa6542edbc54e887c520805607f13aa3
    
    
    
    
    [AMapServices sharedServices].apiKey = APIKEY;///配置用户 key
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate =self;
    [self.view addSubview:self.mapView];
    
    /**  高德地图常用属性
     *1、试图模式 mapType  
            * MAMapTypeStandard   // 普通地图
            * MAMapTypeSatellite  // 卫星地图
            * MAMapTypeStandardNight // 夜间视图
     *2、 交通状况 showTraffic
     *3、高德地图 logo 显示位置 logoCenter  CGRectGetWidth获取试图宽
     *4、设置指南针开关 showsCompass
     *5、设置是否显示比例尺 showsScale
     *6、设置缩放手势 zoomEnabled
     *7、设置滑动手势 scrollEnabled
     *8、设置旋转手势 rotateEnabled
     *9、设置倾斜手势 rotateCameraEnabled
     */
    self.mapView.mapType = MAMapTypeStandardNight;/// 试图模式
    self.mapView.showTraffic = YES;/// 显示交通
    self.mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-50, CGRectGetHeight(self.view.bounds)-30);/// 设置中心点
    self.mapView.showsCompass = YES;/// 关闭指南针
    self.mapView.showsScale = YES;/// 显示比例尺
    self.mapView.zoomEnabled = YES;/// 缩放手势
    self.mapView.scrollEnabled = YES;///滑动手势
    self.mapView.rotateEnabled = YES;/// 旋转手势
    self.mapView.rotateCameraEnabled = YES;///设置倾斜手势
    
    /// 设置跟随用户的模式
    /// 随用户的位置和角度移动
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    self.mapView.showsUserLocation = YES;/// 显示当前位置
    
    self.pointAnnotation = [[MAPointAnnotation alloc] init];
    //[self.mapView addAnnotation:self.pointAnnotation];
}


#pragma mark -- 试图已经显示 --
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
#if 0
    /// 设置跟随用户的模式
    /// 随用户的位置和角度移动
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    self.mapView.showsUserLocation = YES;/// 显示当前位置
#endif
#if 0
    //设置地图显示区域(比如：宜达互联公司地址)
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(22.534191,114.024867);
    MACoordinateSpan span = MACoordinateSpanMake(0.005, 0.005);
    [self.mapView setRegion:MACoordinateRegionMake(coord, span) animated:YES];
    
    //添加大头针
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coord;
    annotation.title = @"宜达互联";
    annotation.subtitle = @"泰然九路14号泰安轩A座1101室";
    [self.mapView addAnnotation:annotation];//添加大头针(此时会回调mapView:viewForAnnotation:方法)
#endif

}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01);
    [self.mapView setRegion:MACoordinateRegionMake(coordinate, span) animated:YES];
    NSLog(@"%f,%f",coordinate.latitude,coordinate.longitude);
    
    self.pointAnnotation.coordinate = coordinate;
    self.pointAnnotation.title = [NSString stringWithFormat:@"%f",coordinate.latitude];
    self.pointAnnotation.subtitle = [NSString stringWithFormat:@"%f",coordinate.longitude];
    [self.mapView addAnnotation:self.pointAnnotation];
}

-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error : %@",[error localizedDescription]);
}

////根据anntation生成对应的View
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        MAPinAnnotationView *pinAnnotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinAnnotation"];
        if (!pinAnnotationView) {
            pinAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinAnnotation"];
        }
        pinAnnotationView.image = [UIImage imageNamed:@"大头针40*40"];
        pinAnnotationView.canShowCallout=YES;///设置起跑弹出
        pinAnnotationView.animatesDrop = NO;///标注动画显示
        pinAnnotationView.draggable = NO;///不可拖拽
        
       return pinAnnotationView;
    }
    return nil;
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

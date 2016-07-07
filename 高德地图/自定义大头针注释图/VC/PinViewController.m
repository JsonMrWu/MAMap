//
//  PinViewController.m
//  高德地图
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 Mr.wu. All rights reserved.
//

#import "PinViewController.h"


@interface PinViewController ()
{
    NSString *str;
}
@end

@implementation PinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [AMapServices sharedServices].apiKey = APIKEY;///配置 key
    self.mapview = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapview.delegate =self;
    [self.view addSubview:self.mapview];
    self.mapview.showsUserLocation = YES;
    
    self.geocoder = [[CLGeocoder alloc] init];
    _pointAnnitation = [[MAPointAnnotation alloc]init];
    
    // 初始化索检对象
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
    
    //逆编码请求
    self.geo = [[AMapReGeocodeSearchRequest alloc] init];
    

}
#pragma mark --- 位置更新成功调用的方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (self.coord.latitude == userLocation.location.coordinate.latitude && self.coord.longitude == userLocation.coordinate.longitude) {
        return;
    }
    
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01);
    MACoordinateRegion coordinateRegion = MACoordinateRegionMake(coordinate, span);
    [self.mapview setRegion:coordinateRegion animated:YES];
    
    self.coord = coordinate;//////////////
#if 0
    //创建一个地理编码      使用系统的反编码---地址不对
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray*arr, NSError * _Nullable error) {
        CLPlacemark *placemark = [arr lastObject];
        //NSLog(@"%@",placemark.name);
        
        self.emp = [[empty alloc] init];
        self.emp.address = placemark.name;
        self.emp.coordinate = placemark.location.coordinate;
    }];
#endif
    
    //地理逆编码
    self.geo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    self.geo.radius = 2000;
    //发送地理编码
        // 回调 - onReGeocodeSearchDone response 方法
    [self.searchAPI AMapReGoecodeSearch:self.geo];
    
    
    if (![str isEqualToString:self.emp.address]) {
        self.emp = [[empty alloc] init];
        self.emp.coordinate = coordinate;
        self.emp.address = str;
    }
    
    
    _pointAnnitation.coordinate = coordinate;
    [self.mapview addAnnotation:_pointAnnitation];///添加大头针
}

#pragma mark --- 定位失败调用的方法
-(void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error
{
    NSLog(@"error : %@",[error localizedDescription]);
}
#pragma mark --- MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    /*
     * 如果传过来的是我们自定义的大头针就执行 if 里边的语句，否则就执行下边的自定义一个大头针弹出视图
     *这方法是下边点击大头针时 执行
     */
    if ([annotation isKindOfClass:[myPointAnnotation class]]) {
        
        myAnnotationView *annotationView = [[myAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"custermAnnotation" frame:CGRectMake(0, 0, 200, 60) Info:self.emp];
        annotationView.delegated =self;
        
        return annotationView;
    }
    /**
     * 创建自定义图片大头针
     */
    static NSString *indentifier = @"annotation";
    MAAnnotationView *newAnnotation = [mapView dequeueReusableAnnotationViewWithIdentifier:indentifier];
    if (!newAnnotation) {
        
        newAnnotation = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:indentifier];
        newAnnotation.canShowCallout = NO;///********* 禁止弹出泡弹出
        newAnnotation.image = [UIImage imageNamed:@"大头针"];
    }
    return newAnnotation;
}
/**
 * @brief 当选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param views 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /// 防止多次点击，所以添加一个类
    /*
     * 如果这个大头针弹出视图 与 系统的一样，则执行 if 中的语句（首次点击是一样的，所以执行 if 语句）
     */
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        /*
         * 如果这个自定义的大头针的经纬度和点击的大头针是一样的，则直接返回，防止同一大头针多次点击
         */
        if (self.myPointAnnotataion.coordinate.latitude == view.annotation.coordinate.latitude
        && self.myPointAnnotataion.coordinate.longitude == view.annotation.coordinate.longitude)
        {
            return;
        }
        
        self.myPointAnnotataion = [[myPointAnnotation alloc] init];
        self.myPointAnnotataion.coordinate = view.annotation.coordinate;
        
        // 调用上面 - mapView viewForAnnotation 方法
        [self.mapview addAnnotation:self.myPointAnnotataion];
        
        /**
         * @brief 当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
         */
        [self.mapview setCenterCoordinate:self.myPointAnnotataion.coordinate animated:YES];
    }
}
/**
 * @brief 当取消选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param views 取消选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    [self.mapview removeAnnotation:self.myPointAnnotataion];
    self.myPointAnnotataion = nil;
}


/**
 *  逆地理编码查询回调函数
 *
 *  @param request  发起的请求，具体字段参考 AMapReGeocodeSearchRequest 。
 *  @param response 响应结果，具体字段参考 AMapReGeocodeSearchResponse 。
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode) {
        
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        //
        str = response.regeocode.formattedAddress;
        }
}



#pragma mark -- --myAnnotationViewDelegate--
-(void)myAnnotationClicked:(myAnnotationView *)view
{
    if (view.emp) {
        
        static BOOL isAdress = YES;
        if (isAdress) {
            view.label.text = [NSString stringWithFormat:@"纬度:%f \n经度:%f",self.emp.coordinate.latitude,self.emp.coordinate.longitude];
            isAdress = NO;
        }else{
            view.label.text = self.emp.address;
            isAdress = YES;
        }
    }
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

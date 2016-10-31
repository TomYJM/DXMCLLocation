//
//  ViewController.m
//  DXMCLLocation
//
//  Created by YANGJINMING on 15/11/12.
//  Copyright © 2015年 YANGJINMING. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "ShowSearchVC.h"
#import "LocationTitleBtn.h"
@interface ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,ShowSearchVCDelegate,UIGestureRecognizerDelegate> {
    MKMapRect _routeRect;
    BOOL isFirst;
    CLLocation* _currentLocation;
    //定位管理对象
    CLLocationManager *locationManager;
    //位置附近信息数组
    NSArray *mapitems;
    //当前位置信息地名
    NSString *currentLocationName;
    //三角图标
    LocationTitleBtn *drawView;
}
//地图view
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//屏幕中间位置图标
@property (weak, nonatomic) IBOutlet UIImageView *locationImageV;
//中间位置信息按钮
@property (weak, nonatomic) IBOutlet UIButton *locationTitleBtn;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self initlocationManager];
    
    self.mapView.delegate = self;
    isFirst = YES;
    self.mapView.showsUserLocation = NO;
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)initSubViews {
    
    self.locationTitleBtn.titleEdgeInsets = UIEdgeInsetsMake(-4, 0, 4, 0);
    [self.locationTitleBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];
}
- (void)initlocationManager {
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        locationManager=[[CLLocationManager alloc] init];
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=10;
        [locationManager startUpdatingLocation];//开启定位
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    // 如果是iOS 8系统
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.mapView.region.center.latitude, self.mapView.region.center.longitude);
    
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta = 0.01;
    theSpan.longitudeDelta = 0.01;
    MKCoordinateRegion theRegion;
    theRegion.center = coordinate;
    theRegion.span = theSpan;
    [self.mapView setRegion:theRegion animated:YES];
    
    // 开始定位
    [locationManager startUpdatingLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Customer 
- (IBAction)resetUserLocation:(id)sender {
    // 开始定位
    [locationManager startUpdatingLocation];
}
#pragma mark CLLocationManagerDelegate<br>/**<br>* 获取经纬度<br>*/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //获取地球地理坐标
    CLLocation *userLocation = [locations firstObject];
    if  (userLocation.coordinate.latitude == 0.0f || userLocation.coordinate.longitude == 0.0f) return;
    
    //转换成火星坐标显示在mapview上
    userLocation = [userLocation locationMarsFromEarth];
    if (!(userLocation.coordinate.latitude == self.mapView.region.center.latitude && userLocation.coordinate.longitude == self.mapView.region.center.longitude)) {
        [UIView animateWithDuration:0.35f animations:^{
            self.mapView.centerCoordinate = userLocation.coordinate;
            _currentLocation = userLocation;
        } completion:^(BOOL finished) {
            if (finished) {
                [locationManager stopUpdatingLocation];
            }
        }];
    }
}
/**
 *定位失败，回调此方法
 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code]==kCLErrorDenied) {
        //        NSLog(@"访问被拒绝");
    }
    if ([error code]==kCLErrorLocationUnknown) {
        //        NSLog(@"无法获取位置信息");
    }
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated  {
    
    //获取火星地图中间坐标的地理坐标
    CLLocationCoordinate2D centerCoordinate = self.mapView.region.center;
    //火星坐标转换成地球坐标 反地理编码获取位置信息 目前还未实现
    CLLocation *location = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    //CLGeocoder反地理编码，通过地理坐标获取当前位置详细信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __weak ViewController *VC = self;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) { 
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks firstObject];
            [self getLocalSearchResponseWithLocationName:placeMark.name ViewController:VC completionHandler:^(NSArray *mapItems) {
                mapitems = mapItems;

            }];
        }
    }];
}
- (void)getLocalSearchResponseWithLocationName:(NSString *)name ViewController:(ViewController *)VC completionHandler:(void(^)(NSArray *mapItems))handler {
    //显示当前位置信息
    [VC.locationTitleBtn setTitle:[NSString stringWithFormat:@"我从%@上车",name] forState:UIControlStateNormal];
    currentLocationName = name;
    //建立附近位置搜索请求
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = name;
    request.region = VC.mapView.region;
    
    //请求LocalSearch搜索附近结果
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *r, NSError *e) {
        handler(r.mapItems);
        
    }];
}
#pragma mark - 跳转到显示地图附近信息界面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShowSearchVC *showVC = segue.destinationViewController;
    showVC.delegate = self;
    showVC.showArray = mapitems;
    showVC.currentRegion = self.mapView.region;
    showVC.currentName = currentLocationName;
}
#pragma mark - ShowSearchVCDelegate
- (void)getSelectLocation:(MKMapItem *)mapItem {
    currentLocationName = mapItem.name;
    _currentLocation = mapItem.placemark.location;
    [self.mapView setRegion:MKCoordinateRegionMake(mapItem.placemark.location.coordinate, MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
}
@end

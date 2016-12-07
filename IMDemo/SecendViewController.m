//
//  SecendViewController.m
//  IMDemo
//
//  Created by 田耀琦 on 16/11/10.
//  Copyright © 2016年 田耀琦. All rights reserved.
//

#import "SecendViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "CustomAnnotationView.h"
#import "SearchViewController.h"
#import "NaviViewController.h"
#import <MapKit/MapKit.h>
@interface SecendViewController () <MAMapViewDelegate,AMapSearchDelegate,UITextFieldDelegate>
{
    MAMapView *_mapView;
    MAUserLocation *_userLocation;
    MAPointAnnotation *_pointAnnotation;
    CLLocationManager *_manager;
    AMapSearchAPI *_searchAPI;
    UITextField *_searchTF;
    NSArray *_arr;
    AMapPOI *_poi;
    CLGeocoder *_geocoder;
}

@end

@implementation SecendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMapView];
    
    [self drawPolyline];
    
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    //  搜索
   // [self initialSearchAPI];
    [self setSearchUI];
     // 导航
//    [self initialViewNavi];
    UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    naviBtn.frame = CGRectMake(15, App_HEIGHT - 100, 64, 44);
    [naviBtn setTitle:@"导航" forState:UIControlStateNormal];
    [naviBtn addTarget:self action:@selector(naviController) forControlEvents:UIControlEventTouchUpInside ];
    naviBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:naviBtn];
}
- (void)setMapView {
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, App_WIDTH, App_HEIGHT - 200)];
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    //设置底图种类为
    [_mapView setMapType:MAMapTypeStandard];
    
    _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, 450);
    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22); //设置指南针位置
    
    _mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);  //设置比例尺位置
    
     _mapView.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    //self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _pointAnnotation = [[MAPointAnnotation alloc] init];
//    _pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);

    _pointAnnotation.title = @"www";
    _pointAnnotation.subtitle = @"1111";
    
    _pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 117.483010);
    
    [_mapView addAnnotation:_pointAnnotation];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _mapView.mapType = MAMapTypeStandard;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"1.png"];
        annotationView.imageP = [UIImage imageNamed:@"1.png"];
        //         annotationView.calloutView.image = [UIImage imageNamed:@"1.png"];
//        annotationView.calloutView.title = @"我的";
//        annotationView.calloutView.subtitle = @"haha";
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}
#pragma mark ---- 绘制折线图
- (void)drawPolyline {
    CLLocationCoordinate2D commonPolylineCoords[4];
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.44095;
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:4];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    
    return nil;
}
#pragma mark ---- 实时定位 -----
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        _userLocation = userLocation;
        _pointAnnotation.coordinate = userLocation.coordinate;
//        [_mapView reloadMap];
        
    }
}


// 创建搜素框
- (void)setSearchUI {
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(15, App_HEIGHT - 190, 150, 44)];
    _searchTF.placeholder = @"请输入关键词";
    _searchTF.delegate = self;
    _searchTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_searchTF];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(170, App_HEIGHT - 190, 60, 44);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:searchBtn];
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.block = ^(AMapPOI *poi) {
        NSLog(@" ===== Block ====== ");
        _poi = poi;
        textField.text = poi.name;
        
    };
    [self.navigationController pushViewController:searchVC animated:NO];
}
- (void)searchBtn {
    CLLocationCoordinate2D coordinate =
    CLLocationCoordinate2DMake(_poi.location.latitude, _poi.location.longitude);
    _pointAnnotation.coordinate = coordinate;
    _pointAnnotation.title = _poi.name;
    _pointAnnotation.subtitle = _poi.address;
}
#pragma mark ----- 周边搜索 ------

#pragma mark ----- 导航1 -------
- (void)initialViewNavi {
    _geocoder = [[CLGeocoder alloc] init];
    [_geocoder geocodeAddressString:@"东方体育中心" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        MKPlacemark *mkPlaceMark = [[MKPlacemark alloc] initWithPlacemark:placeMark];
        [_geocoder geocodeAddressString:@"上海迪士尼" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *placeMark1 = [placemarks firstObject];
            MKPlacemark *mkPlaceMark1 = [[MKPlacemark alloc] initWithPlacemark:placeMark1];
            NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
            MKMapItem *mapItem1=[MKMapItem mapItemForCurrentLocation];//当前位置
//            MKMapItem *mapItem1=[[MKMapItem alloc]initWithPlacemark:mkPlaceMark];
            MKMapItem *mapItem2=[[MKMapItem alloc]initWithPlacemark:mkPlaceMark1];
            [MKMapItem openMapsWithItems:@[mapItem1,mapItem2] launchOptions:options];
        }];
    }];
}

#pragma mark ---- 路线规划 -----
- (void)naviController {
    NaviViewController *navc = [[NaviViewController alloc] init];
    [self.navigationController pushViewController:navc animated:NO];
}

@end

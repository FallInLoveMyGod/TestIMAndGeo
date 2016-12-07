//
//  NaviViewController.m
//  IMDemo
//
//  Created by 51jk on 2016/12/6.
//  Copyright © 2016年 田耀琦. All rights reserved.
//

#import "NaviViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
@interface NaviViewController () <AMapNaviDriveViewDelegate,AMapNaviDriveManagerDelegate>
{
    AMapNaviPoint *_startPoint;
    AMapNaviPoint *_endPoint;
}
@property (nonatomic ,strong)AMapNaviDriveView *mapNaviDriveView;
@property (nonatomic ,strong)AMapNaviDriveManager *naviManager;
@property (nonatomic ,strong)MAMapView *mapView;
@end

@implementation NaviViewController
- (AMapNaviDriveView *)mapNaviDriveView {
    if (!_mapNaviDriveView) {
        _mapNaviDriveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.frame];
        _mapNaviDriveView.delegate = self;
        _mapNaviDriveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _mapNaviDriveView;
}
- (AMapNaviDriveManager *)naviManager {
    if (!_naviManager) {
        _naviManager = [[AMapNaviDriveManager alloc] init];
        _naviManager.delegate = self;
    }
    return _naviManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapNaviDriveView];
    [self.naviManager addDataRepresentative:self.mapNaviDriveView];
    [self initProperties];
    [self.naviManager calculateDriveRouteWithStartPoints:@[_startPoint] endPoints:@[_endPoint] wayPoints:nil
    drivingStrategy:17];
    
}
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    NSDictionary *dic =  driveManager.naviRoutes;
    NSLog(@" == %@",dic);
    //算路成功后开始GPS导航
    [self.naviManager startGPSNavi];
}
#pragma mark ---- 路线规划 -------
- (void)initProperties
{
    _startPoint = [AMapNaviPoint locationWithLatitude:39.990998878 longitude:116.47876655];
    _endPoint   = [AMapNaviPoint locationWithLatitude:39.9087654 longitude:116.32988677];
}

@end

//
//  LYLocationUtil.m
//  LYLocation
//
//  Created by admin on 2018/7/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LYLocationUtil.h"
#import <UIKit/UIKit.h>

@interface LYLocationUtil()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManger;
@property (copy, nonatomic) LYLocationResuleBlock locationResultBlock;
@property (copy, nonatomic) LYLocationResuleBlock locateOnceResultBlock;

@end

@implementation LYLocationUtil

+ (instancetype)sharedLocationUtil
{
    static LYLocationUtil *sharedLocationUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationUtil = [[LYLocationUtil alloc] init];
    });
    
    return sharedLocationUtil;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.locationManger = [[CLLocationManager alloc] init];
        self.locationManger.delegate = self;
        self.locationManger.distanceFilter = kCLDistanceFilterNone;
//        self.locationManger.distanceFilter = 1;
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManger.pausesLocationUpdatesAutomatically = NO;
        if (@available(iOS 8.0, *))
        {
            //请求一直定位
            [self.locationManger requestAlwaysAuthorization];
            //请求使用中定位
            [self.locationManger requestWhenInUseAuthorization];
        }
        if (@available(iOS 9.0, *))
        {
            self.locationManger.allowsBackgroundLocationUpdates = YES;
        }
        if (@available(iOS 11.0, *))
        {
            self.locationManger.showsBackgroundLocationIndicator = YES;
        }
//        if ([CLLocationManager locationServicesEnabled])
//        {
//            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
//            {
//                NSLog(@"用户禁止定位权限");
//            }
//        }else {
//            NSLog(@"定位服务已关闭");
//        }
    }
    
    return self;
}

#pragma mark - func

+ (void)startUpdateLocationAlwaysWith:(LYLocationResuleBlock)locationResultBlock
{
    [[self sharedLocationUtil] startUpdateLocationAlwaysWith:locationResultBlock];
}

- (void)startUpdateLocationAlwaysWith:(LYLocationResuleBlock)locationResultBlock
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        NSLog(@"定位权限未开");
        return;
    }
    
    self.locationResultBlock = locationResultBlock;
    [self.locationManger startUpdatingLocation];
}

+ (void)startLocateOnceWith:(LYLocationResuleBlock)locateOnceResultBlock
{
    [[self sharedLocationUtil] startLocateOnceWith:locateOnceResultBlock];
}

- (void)startLocateOnceWith:(LYLocationResuleBlock)locateOnceResultBlock
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        NSLog(@"定位权限未开");
        return;
    }
    
    if (@available(iOS 9.0, *))
    {
        self.locateOnceResultBlock = locateOnceResultBlock;
        [self.locationManger requestLocation];
    }
}

//+ (void)startUpdateLocationWhenInUseWith:(LYLocationResuleBlock)locationResultBlock
//{
//    [[self sharedLocationUtil] startUpdateLocationWhenInUseWith:locationResultBlock];
//}
//
//- (void)startUpdateLocationWhenInUseWith:(LYLocationResuleBlock)locationResultBlock
//{
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
//    {
//        NSLog(@"定位权限未开");
//        return;
//    }
//
//    self.locateOnceResultBlock = locateOnceResultBlock;
//    [self.locationManger requestLocation];
//}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{    
    !self.locationResultBlock ? : self.locationResultBlock(manager, locations);
    !self.locateOnceResultBlock ? : self.locateOnceResultBlock(manager, locations);
    self.locateOnceResultBlock = nil;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        // 用户还未决定
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定");
            
            break;
        }
        // 访问受限
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
        // 定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:
        {
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled])
            {
                NSLog(@"定位开启，但被拒");
            }else
            {
                NSLog(@"定位关闭，不可用, 请在设置中打开定位服务选项");
            }
//            NSLog(@"被拒");
            break;
        }
        // 获取前后台定位授权
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获取前后台定位授权");
            break;
        }
        // 获得前台定位授权
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台定位授权");
            break;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"error:%@", error);
}

@end

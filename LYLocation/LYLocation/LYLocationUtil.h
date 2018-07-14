//
//  LYLocationUtil.h
//  LYLocation
//
//  Created by admin on 2018/7/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LYLocationResuleBlock)(CLLocationManager *locationManager, NSArray<CLLocation *> *updateLocations);

@interface LYLocationUtil : NSObject

+ (void)startUpdateLocationAlwaysWith:(LYLocationResuleBlock)locationResultBlock;

+ (void)startLocateOnceWith:(LYLocationResuleBlock)locateOnceResultBlock API_AVAILABLE(ios(9.0));

@end

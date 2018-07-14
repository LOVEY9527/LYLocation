//
//  ViewController.m
//  LYLocation
//
//  Created by admin on 2018/7/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ViewController.h"
#import "LYLocationUtil.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [LYLocationUtil startUpdateLocationAlwaysWith:^(CLLocationManager *locationManager, NSArray<CLLocation *> *updateLocations) {
        __block NSString *text = @"";
        [updateLocations enumerateObjectsUsingBlock:^(CLLocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            text = [text stringByAppendingFormat:@"\n %@", [obj description]];
        }];
        self.textLabel.text = text;
        NSLog(@"updateLocations:%@", text);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

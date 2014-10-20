//
//  SHMapViewController.m
//  Scavenger Hunt
//
//  Created by Raymond Qiu on 8/23/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "SHMapViewController.h"

#import <GoogleMaps/GoogleMaps.h>
#import "BadgeManager.h"
#import "Badge.h"
#define IS_IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

CGFloat handBookTitleHeight = 100;  //for view switching use -by zinsser
CGPoint tableViewCenter;           //for view switching use -by zinsser
CGFloat yDistanceNeedToMove;        //for view switching use -by zinsser
CGPoint handBookTitleOrigin;               //for view switching use -by zinsser

@implementation SHMapViewController {
}
@synthesize map;
- (void)viewDidLoad {
    self.locationManager = [[CLLocationManager alloc] init];

    [self.locationManager startUpdatingLocation];
    if(IS_IOS_8_OR_LATER){
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    // Creates a marker in the center of the map.
    [map setMyLocationEnabled:YES];
    map.settings.myLocationButton = YES;
    self.view = map;
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = map;
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    //GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
    //[mapView_ animateToCameraPosition:camera];
}

-(void) viewDidAppear:(BOOL)animated{
    CLLocationCoordinate2D target =
    CLLocationCoordinate2DMake(map.myLocation.coordinate.latitude, map.myLocation.coordinate.longitude);
    [map animateToLocation: target];
    [map animateToZoom:17];
}



@end

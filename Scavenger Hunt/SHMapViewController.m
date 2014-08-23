//
//  SHMapViewController.m
//  Scavenger Hunt
//
//  Created by Raymond Qiu on 8/23/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "SHMapViewController.h"

#import <GoogleMaps/GoogleMaps.h>

CGPoint mapCenter,badgeTableCenter; //for view switching use -by zinsser

@implementation SHMapViewController {
    //GMSMapView *mapView_;
}
@synthesize map = mapView_;
- (void)viewDidLoad {
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
    mapView_.myLocationEnabled = YES;
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
    mapView_.settings.myLocationButton = YES;
    [mapView_ animateToCameraPosition:camera];

}
-(void) viewDidAppear:(BOOL)animated{
    CLLocationCoordinate2D target =
    CLLocationCoordinate2DMake(mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude);
    [mapView_ animateToLocation: target];
    [mapView_ animateToZoom:17];
    
    /*******************Zinsser's PanGestureContrl*******************/
    mapCenter = mapView_.center;
    badgeTableCenter = _badgeTable.center;
    UIPanGestureRecognizer *mainPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mainMove:)];
    [mainPan setMaximumNumberOfTouches:1];
    [mainPan setMinimumNumberOfTouches:1];
    [self.badgeTable addGestureRecognizer:mainPan];
    [self.badgeTable.panGestureRecognizer setMinimumNumberOfTouches:20];
   
    
}

-(void) mainMove:(id)sender
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint mapPresentCenter = mapView_.center;
    CGPoint badgeTablePresentCenter = _badgeTable.center;
    
    mapPresentCenter = CGPointMake(mapPresentCenter.x, mapPresentCenter.y+translatedPoint.y*0.5);
    badgeTablePresentCenter = CGPointMake(badgeTablePresentCenter.x, badgeTablePresentCenter.y+translatedPoint.y);
    [mapView_ setCenter:mapPresentCenter];
    [_badgeTable setCenter:badgeTablePresentCenter];
}



/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"myLocation"]) {
        CLLocation *location = [object myLocation];
        //...
        NSLog(@"Location, %@,", location);
        
        CLLocationCoordinate2D target =
        CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        
        [mapView_ animateToLocation:target];
        [mapView_ animateToZoom:17];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:0 context:nil];
}
- (void)dealloc {
    [mapView_ removeObserver:self forKeyPath:@"myLocation"];
}*/

@end

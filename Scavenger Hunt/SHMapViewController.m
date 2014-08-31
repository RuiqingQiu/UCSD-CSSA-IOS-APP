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

CGFloat handBookTitleHeight = 100;  //for view switching use -by zinsser
CGPoint badgeTableCenter;           //for view switching use -by zinsser
CGFloat yDistanceNeedToMove;        //for view switching use -by zinsser
CGPoint handBookTitleOrigin;               //for view switching use -by zinsser

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
    
    for(int i = 0; i < 5; i++) {
        NSLog(@"%@", ((Badge*)[[BadgeManager sharedBadgeManager].badgeList objectAtIndex:i]).image);
        
    }
    //[_Image1 setImage: [UIImage imageNamed:@"UC_Sea_ovt.png"]];
    //[_Image2 setImage:((Badge*)[[BadgeManager sharedBadgeManager].badgeList objectAtIndex:1]).image];
}

-(void) viewDidAppear:(BOOL)animated{
    CLLocationCoordinate2D target =
    CLLocationCoordinate2DMake(mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude);
    [mapView_ animateToLocation: target];
    [mapView_ animateToZoom:17];
    
    /*******************Zinsser's PanGestureContrl*******************/
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGRect tmpFrame = _badgeTable.frame;
        tmpFrame.size.width = screenRect.size.width;
        tmpFrame.size.height = screenRect.size.height - handBookTitleHeight;
        _badgeTable.frame = tmpFrame;
    }
    
    yDistanceNeedToMove = _badgeTable.frame.origin.y - handBookTitleHeight;
    badgeTableCenter = _badgeTable.center;
    handBookTitleOrigin = _handBookTitle.frame.origin;
    UIPanGestureRecognizer *mainPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mainMove:)];
    [mainPan setMaximumNumberOfTouches:1];
    [mainPan setMinimumNumberOfTouches:1];
    [self.badgeTable addGestureRecognizer:mainPan];
    [self.badgeTable.panGestureRecognizer requireGestureRecognizerToFail:mainPan];
    
    UIPanGestureRecognizer * mainPanRev = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mainMoveRev:)];
    [mainPanRev setMaximumNumberOfTouches:1];
    [mainPanRev setMinimumNumberOfTouches:1];
    [self.handBookTitle addGestureRecognizer:mainPanRev];
    
    [mapView_.superview bringSubviewToFront:mapView_];
    [_badgeTable.superview bringSubviewToFront:_badgeTable];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [[BadgeManager sharedBadgeManager].badgeList count];
}

-(CGFloat) tableView: (UITableView* ) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frame.size.height/2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    
    cell.textLabel.text = ((Badge*)[[BadgeManager sharedBadgeManager].badgeList objectAtIndex:indexPath.row]).name;
    
    cell.imageView.image = ((Badge*)[[BadgeManager sharedBadgeManager].badgeList objectAtIndex:indexPath.row]).image;
    
    
    return cell;
    
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

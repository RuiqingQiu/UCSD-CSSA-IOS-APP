//
//  Annotation.m
//  Scavenger Hunt
//
//  Created by Ruiqing Qiu on 10/18/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize title,subtitle,coordinate, image_url;

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location image_url:(NSString*)url{
    self = [super init];
    if(self){
        title = newTitle;
        coordinate = location;
        image_url = url;
    }
    return self;
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

-(MKAnnotationView*)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    //All annotation is map_avatar.png
    annotationView.image = [UIImage imageNamed:@"map_avatar.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    /*if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        CalloutView *calloutView = (CalloutView *)[[[NSBundle mainBundle] loadNibNamed:@"callOutView" owner:self options:nil] objectAtIndex:0];
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
        [calloutView.calloutLabel setText:[(MyLocation*)[view annotation] title]];
        [calloutView.btnYes addTarget:self
                               action:@selector(checkin)
                     forControlEvents:UIControlEventTouchUpInside];
        calloutView.userInteractionEnabled = YES;
        view.userInteractionEnabled = YES;
        [view addSubview:calloutView];
    }*/
    NSLog(@"here");
    
}
@end

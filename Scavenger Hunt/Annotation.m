//
//  Annotation.m
//  Scavenger Hunt
//
//  Created by Ruiqing Qiu on 10/18/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize title,subtitle,coordinate;

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location{
    self = [super init];
    if(self){
        title = newTitle;
        coordinate = location;
    }
    return self;
}

-(MKAnnotationView*)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"rsz_icon1.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}
@end

//
//  Annotation.h
//  Scavenger Hunt
//
//  Created by Ruiqing Qiu on 10/18/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//Custom class for annotation
@interface Annotation : NSObject<MKAnnotation>
//用属性实现协议里面的方法，同时提供类外的接口
@property(nonatomic,copy)NSString *title,*subtitle;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location;
-(MKAnnotationView*)annotationView;
@end


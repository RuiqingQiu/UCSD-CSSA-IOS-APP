//
//  Annotation.h
//  Scavenger Hunt
//
//  Created by Ruiqing Qiu on 10/18/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MapViewController.h"
//Custom class for annotation
@interface Annotation : NSObject<MKAnnotation>
//用属性实现协议里面的方法，同时提供类外的接口
@property(nonatomic,copy)NSString *title,*subtitle, *image_url, *user_id;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location image_url:(NSString *) url user_id:(NSString*)m_user_id;
-(MKAnnotationView*)annotationView;
-(UIImage *) getImageFromURL:(NSString *)fileURL;
@end


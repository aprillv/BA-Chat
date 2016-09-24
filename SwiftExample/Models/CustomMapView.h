//
//  CustomMapView.h
//  BAChat
//
//  Created by April on 9/23/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SMCalloutView.h"

@interface CustomMapView : MKMapView

@property (nonatomic, strong) SMCalloutView *calloutView;
@end

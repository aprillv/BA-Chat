//
//  MKMapView+ZoomLevel.h
//  BAChat
//
//  Created by April on 9/22/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
- (NSUInteger)getCurrentZoomLevel;
@end

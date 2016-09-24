//
//  CustomMapView.m
//  BAChat
//
//  Created by April on 9/23/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

#import "CustomMapView.h"
@interface MKMapView (UIGestureRecognizer)

// this tells the compiler that MKMapView actually implements this method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end
@implementation CustomMapView

-(void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(camera)]) {
        [self setShowsBuildings:YES];
        MKMapCamera *newCamera = [[self camera] copy];
        
        if (newCamera.pitch != 0) {
            [newCamera setCenterCoordinate: region.center];
            [newCamera setPitch: newCamera.pitch];
            [newCamera setHeading: newCamera.heading];
            
            
            CLLocation *locA = [[CLLocation alloc] initWithLatitude: region.center.latitude-(region.span.latitudeDelta/2) longitude: region.center.longitude-(region.span.longitudeDelta/2)];
            
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:region.center.latitude+(region.span.latitudeDelta/2) longitude: region.center.longitude+(region.span.longitudeDelta/2)];
            
            CLLocationDistance distance = [locA distanceFromLocation:locB];
            CGFloat la =distance / tan(M_PI*(newCamera.pitch/180.0));
            [newCamera setAltitude: la];
            [self setCamera:newCamera animated:animated];
            //            NSLog(@"fasdfa distance %@ %f %f", newCamera, distance,  la);
        }else{
            [super setRegion:region animated:animated];
        }
        
    }else{
        [super setRegion:region animated:animated];
    }
}
// override UIGestureRecognizer's delegate method so we can prevent MKMapView's recognizer from firing
// when we interact with UIControl subclasses inside our callout view.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]])
        return NO;
    else
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}

// Allow touches to be sent to our calloutview.
// See this for some discussion of why we need to override this: https://github.com/nfarina/calloutview/pull/9
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *calloutMaybe = [self.calloutView hitTest:[self.calloutView convertPoint:point fromView:self] withEvent:event];
    if (calloutMaybe) return calloutMaybe;
    
    return [super hitTest:point withEvent:event];
}

@end

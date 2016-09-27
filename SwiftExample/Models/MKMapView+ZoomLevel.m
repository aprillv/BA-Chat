// MKMapView+ZoomLevel.m
#import "MKMapView+ZoomLevel.h"

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

@implementation MKMapView (ZoomLevel)

#pragma mark -
#pragma mark Map conversion methods

- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(NSUInteger)zoomLevel
{
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    NSInteger zoomExponent = 20 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}

#pragma mark -
#pragma mark Public methods

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated
{
    // clamp large numbers to 28
    zoomLevel = MIN(zoomLevel, 28);
    
    // use the zoom level to compute the region
    MKCoordinateSpan span = [self coordinateSpanWithMapView:self centerCoordinate:centerCoordinate andZoomLevel:zoomLevel];
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    
    // set the region like normal
    [self setRegion:region animated:animated];
}

- (NSUInteger)getCurrentZoomLevel {
    // get longitude of right edge and left edge;
    CLLocationDegrees longitudeMax = self.region.center.longitude + self.region.span.longitudeDelta /2.0;
    CLLocationDegrees longitudeMin = self.region.center.longitude - self.region.span.longitudeDelta /2.0;
    
    // calc get longitude delta in pixel
    double longitudeMaxInPixel = [self longitudeToPixelSpaceX:longitudeMax];
    double longitudeMinInPixel = [self longitudeToPixelSpaceX:longitudeMin];
    double scaledMapWidth = longitudeMaxInPixel - longitudeMinInPixel;
    
    // calc zoom scale
    double mapSizeInPixels = self.bounds.size.width;
    double zoomScale = scaledMapWidth / mapSizeInPixels;
    NSUInteger zoomLevel = 20 - log2(zoomScale);
    
    return (zoomLevel > 0)? zoomLevel : 0;
}

- (BOOL)mapViewRegionDidChangeFromUserInteraction
{
    UIView *view = self.subviews.firstObject;
    mapChangedFromUserTapInteraction2=NO;
    //  Look through gesture recognizers to determine whether this region change is from user interaction
    for(UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        
        if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateEnded) {
            if ([recognizer class] == [UITapGestureRecognizer class]) {
                UITapGestureRecognizer *d = (UITapGestureRecognizer *)recognizer;
                if (d.numberOfTouches==1 || d.numberOfTouches==2) {
                    return NO;
                }
            }else if([[NSString stringWithFormat:@"%@", [recognizer class]] isEqualToString:@"_MKUserInteractionGestureRecognizer"]){
                mapChangedFromUserTapInteraction2=YES;
                return NO;
            }
            
            return YES;
        }
    }
    
    return NO;
}


-(BOOL)mapChangedFromUserTapInteraction{
    return mapChangedFromUserTapInteraction2;
}
static BOOL mapChangedFromUserTapInteraction2 = NO;


@end

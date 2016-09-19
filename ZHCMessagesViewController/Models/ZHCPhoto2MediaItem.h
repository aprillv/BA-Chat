//
//  ZHCPhoto2MediaItem.h
//  SwiftExample
//
//  Created by LvApril on 9/14/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

#import "ZHCMediaItem.h"

@interface ZHCPhoto2MediaItem : ZHCMediaItem
@property (copy, nonatomic, nullable) NSURL *imageURL;
@property (copy, nonatomic, nullable) UIImage *imageData;
@property (copy, nonatomic, nullable) NSString *lat;
@property (copy, nonatomic, nullable) NSString *lng;
/**
 *  Initializes and returns a photo media item object having the given image.
 *
 *  @param image The image for the photo media item. This value may be `nil`.
 *
 *  @return An initialized `ZHCPhotoMediaItem`.
 *
 *  @discussion If the image must be dowloaded from the network,
 *  you may initialize a `ZHCPhotoMediaItem` object with a `nil` image.
 *  Once the image has been retrieved, you can then set the image property.
 */
- (instancetype)initWithImage:(nullable NSURL *)imageURL;

- (instancetype)initWithData:(nullable NSData *)imageData;
@end

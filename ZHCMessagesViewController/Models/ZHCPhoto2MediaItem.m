//
//  ZHCPhoto2MediaItem.m
//  SwiftExample
//
//  Created by LvApril on 9/14/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

#import "ZHCPhoto2MediaItem.h"
#import "ZHCMessagesMediaPlaceholderView.h"
#import "ZHCMessagesMediaViewBubbleImageMasker.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZHCPhoto2MediaItem()
@property (strong, nonatomic) UIImageView *cachedImageView;

@end

@implementation ZHCPhoto2MediaItem

#pragma mark - Initialization

- (instancetype)initWithImage:(NSURL *)images
{
    self = [super init];
    if (self) {
        _imageURL = [images copy];
        _cachedImageView = nil;
    }
    return self;
}

- (instancetype)initWithData:(UIImage *)imageData
{
    self = [super init];
    if (self) {
        _imageData = [imageData copy];
        _cachedImageView = nil;
    }
    return self;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedImageView = nil;
}


#pragma mark - Setters

- (void)setImage:(NSURL *)imageurl
{
    _imageURL = [imageurl copy];
    _cachedImageView = nil;
}

-(void)setImageData:(UIImage *)imageData{
    _imageData = [imageData copy];
    _cachedImageView = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedImageView = nil;
}


#pragma mark - ZHCMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.imageURL == nil) {
        return nil;
    }
    
    if (self.cachedImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
    
        UIImageView *imageView = [[UIImageView alloc] init];
        //let a = UIColor(red: 0.9016, green: 0.9016, blue: 0.92, alpha:  1)
        imageView.backgroundColor = [UIColor colorWithRed:0.9016 green:0.9016 blue:0.92 alpha:1];
        
        [imageView sd_setImageWithURL:self.imageURL placeholderImage:nil];
        
        
        imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [ZHCMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        self.cachedImageView = imageView;
    }
    
    if (self.imageData != nil ){
        UIImageView *t = (UIImageView *)self.cachedImageView;
        [t setImage:self.imageData];
    }
    
    return self.cachedImageView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

- (NSString *)mediaDataType
{
    return (NSString *)kUTTypeJPEG;
}


- (id)mediaData
{
    return UIImageJPEGRepresentation(self.cachedImageView.image, 1);
}


#pragma mark - NSObject

- (NSUInteger)hash
{
    return super.hash ^ self.imageURL.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: image=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.imageURL, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _imageURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.imageURL forKey:NSStringFromSelector(@selector(image))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    ZHCPhoto2MediaItem *copy = [[ZHCPhoto2MediaItem allocWithZone:zone] initWithImage:self.imageURL];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}
@end


//
//  ZHCVideoMediaItem.m
//  ZHChat
//
//  Created by aimoke on 16/8/18.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCVideoMediaItem.h"
#import "ZHCMessagesMediaPlaceholderView.h"
#import "ZHCMessagesMediaViewBubbleImageMasker.h"
#import "UIImage+ZHCMessages.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZHCVideoMediaItem()

@property (strong, nonatomic) UIImageView *cachedVideoImageView;

@end


@implementation ZHCVideoMediaItem


#pragma mark - Initialization

- (instancetype)initWithFileURL:(NSURL *)fileURL isReadyToPlay:(BOOL)isReadyToPlay
{
    self = [super init];
    if (self) {
        _fileURL = [fileURL copy];
        _isReadyToPlay = isReadyToPlay;
        _cachedVideoImageView = nil;
    }
    return self;
}

-(void)setFileFirstPageURL:(NSURL *)fileFirstPageURL{
    _fileFirstPageURL = [fileFirstPageURL copy];
    if (self.fileFirstPageURL != nil) {
        [((UIImageView *)self.mediaView) sd_setImageWithURL:self.fileFirstPageURL placeholderImage:nil];
        
        UIImage *playIcon = [[UIImage zhc_defaultPlayImage] zhc_imageMaskedWithColor:[UIColor whiteColor]];
        UIImageView* cc = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        cc.contentMode = UIViewContentModeScaleAspectFit;
        cc.image = playIcon;
        cc.center = self.mediaView.center;
        [self.mediaView addSubview:cc];
        
    }
}

-(void)setFileFirstPageImage:(UIImage *)fileFirstPageImage{
    _fileFirstPageImage = [fileFirstPageImage copy];
    if (self.fileFirstPageImage != nil) {
        [((UIImageView *)self.mediaView) setImage:fileFirstPageImage];
        
        UIImage *playIcon = [[UIImage zhc_defaultPlayImage] zhc_imageMaskedWithColor:[UIColor whiteColor]];
        UIImageView* cc = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        cc.contentMode = UIViewContentModeScaleAspectFit;
        cc.image = playIcon;
        cc.center = self.mediaView.center;
        [self.mediaView addSubview:cc];
        
    }
}


- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedVideoImageView = nil;
}

#pragma mark - Setters

- (void)setFileURL:(NSURL *)fileURL
{
    _fileURL = [fileURL copy];
    _cachedVideoImageView = nil;
}

- (void)setIsReadyToPlay:(BOOL)isReadyToPlay
{
    _isReadyToPlay = isReadyToPlay;
    _cachedVideoImageView = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedVideoImageView = nil;
}

#pragma mark - ZHCMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.fileURL == nil || !self.isReadyToPlay) {
        return nil;
    }
    
    if (self.cachedVideoImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        UIImage *playIcon = [[UIImage zhc_defaultPlayImage] zhc_imageMaskedWithColor:[UIColor whiteColor]];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        if (self.fileFirstPageURL != nil) {
            [imageView sd_setImageWithURL:self.fileFirstPageURL placeholderImage:nil];
            
        }else if(self.fileFirstPageImage != nil) {
            [imageView setImage:self.fileFirstPageImage];
        }
        
        UIImageView* cc = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        cc.image = playIcon;
        cc.contentMode = UIViewContentModeScaleAspectFit;
        cc.center = imageView.center;
        [imageView addSubview:cc];
        
        [ZHCMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        self.cachedVideoImageView = imageView;
    }
    
    return self.cachedVideoImageView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (![super isEqual:object]) {
        return NO;
    }
    
    ZHCVideoMediaItem *videoItem = (ZHCVideoMediaItem *)object;
    
    return [self.fileURL isEqual:videoItem.fileURL]
    && self.isReadyToPlay == videoItem.isReadyToPlay;
}

- (NSUInteger)hash
{
    return super.hash ^ self.fileURL.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: fileURL=%@, isReadyToPlay=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.fileURL, @(self.isReadyToPlay), @(self.appliesMediaViewMaskAsOutgoing)];
}


#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _fileURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileURL))];
        _isReadyToPlay = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isReadyToPlay))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.fileURL forKey:NSStringFromSelector(@selector(fileURL))];
    [aCoder encodeBool:self.isReadyToPlay forKey:NSStringFromSelector(@selector(isReadyToPlay))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    ZHCVideoMediaItem *copy = [[[self class] allocWithZone:zone] initWithFileURL:self.fileURL
                                                                   isReadyToPlay:self.isReadyToPlay];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end

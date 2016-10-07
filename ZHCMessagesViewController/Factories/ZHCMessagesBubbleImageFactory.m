//
//  ZHCMessagesBubleImageFactory.m
//  ZHChat
//
//  Created by aimoke on 16/8/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCMessagesBubbleImageFactory.h"
#import "UIImage+ZHCMessages.h"
#import "UIColor+ZHCMessages.h"
#import "ZHCMessagesBubbleImage.h"

@interface ZHCMessagesBubbleImageFactory ()

@property (strong, nonatomic, readonly) UIImage *bubbleImage;

@property (assign, nonatomic, readonly) UIEdgeInsets capInsets;

@property (assign, nonatomic, readonly) BOOL isRightToLeftLanguage;
@end

@implementation ZHCMessagesBubbleImageFactory

#pragma mark - Initialization
-(instancetype)initWithBubbleImage:(UIImage *)bubbleImage capInsets:(UIEdgeInsets)capInsets layoutDirection:(UIUserInterfaceLayoutDirection)layoutDirection
{
    NSParameterAssert(bubbleImage != nil);
    self = [super init];
    if (self) {
        _bubbleImage = bubbleImage;
        _capInsets = capInsets;
        _layOutDirection = layoutDirection;
    }
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, capInsets)) {
        _capInsets = [self zhc_centerPointEdgeInsetsForImageSize:bubbleImage.size];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithBubbleImage:[UIImage zhc_getBubbleCommpactImage]
                           capInsets:UIEdgeInsetsZero
                     layoutDirection:[UIApplication sharedApplication].userInterfaceLayoutDirection];
}


#pragma mark Public
-(ZHCMessagesBubbleImage *)outgoingMessagesBubbleImageWithColor:(UIColor *)color
{
    return [self zhc_messagesBubbleImageWithColor:color flippedForIncoming:NO ^ self.isRightToLeftLanguage];
}


-(ZHCMessagesBubbleImage *)incomingMessagesBubbleImageWithColor:(UIColor *)color
{
    return [self zhc_messagesBubbleImageWithColor:color flippedForIncoming:YES ^ self.isRightToLeftLanguage];
}

#pragma mark - Private
- (BOOL)isRightToLeftLanguage
{
    return (self.layOutDirection == UIUserInterfaceLayoutDirectionRightToLeft);
}


-(UIEdgeInsets)zhc_centerPointEdgeInsetsForImageSize:(CGSize)imageSize
{
    CGPoint center = CGPointMake(imageSize.width/2.0, imageSize.height/2.0);
    return UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
}


-(ZHCMessagesBubbleImage *)zhc_messagesBubbleImageWithColor:(UIColor *)color flippedForIncoming:(BOOL)flippedForIncoming
{
    UIImage *nolmalBubble = [self.bubbleImage zhc_imageMaskedWithColor:color];
    UIImage *hightlighttBubble = [self.bubbleImage zhc_imageMaskedWithColor:[color zhc_colorByDarkeningColorWithValue:0.12]];
    
   // NSParameterAssert(color != nil);
   // UIImage *nolmalBubble = [self.bubbleImage zhc_imageMaskedWithColor:color];
    //UIImage *hightlighttBubble = [self.bubbleImage zhc_imageMaskedWithColor:[color zhc_colorByDarkeningColorWithValue:0.12]];
    if (flippedForIncoming) {
        nolmalBubble = [self zhc_horizontallyFlippedImageFromImage:nolmalBubble];
        hightlighttBubble = [self zhc_horizontallyFlippedImageFromImage:hightlighttBubble];
    }
    nolmalBubble = [self zhc_stretchableImageFromImage:nolmalBubble withCapInsets:self.capInsets];
    hightlighttBubble = [self zhc_stretchableImageFromImage:hightlighttBubble withCapInsets:self.capInsets];
    
    
    return [[ZHCMessagesBubbleImage alloc]initWithMessageBubbleImage:nolmalBubble highlightedImage:hightlighttBubble];
}


- (UIImage *)zhc_horizontallyFlippedImageFromImage:(UIImage *)image
{
    return [UIImage imageWithCGImage:image.CGImage
                               scale:image.scale
                         orientation:UIImageOrientationUpMirrored];
}

- (UIImage *)zhc_stretchableImageFromImage:(UIImage *)image withCapInsets:(UIEdgeInsets)capInsets
{
   // capInsets.left += 10;
   // capInsets.right += 10;
   // capInsets.top += 10;
    //capInsets.bottom += 10;
//    return image;
    image =  [image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
//    image = [self imageWithBorderFromImage: image];
    return image;
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0);
    CGContextStrokeRect(context, rect);
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}


@end

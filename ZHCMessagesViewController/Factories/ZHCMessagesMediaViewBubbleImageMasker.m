//
//  ZHCMessagesMediaViewBubbleImageMasker.m
//  ZHChat
//
//  Created by aimoke on 16/8/15.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCMessagesMediaViewBubbleImageMasker.h"
#import "ZHCMessagesBubbleImageFactory.h"

@implementation ZHCMessagesMediaViewBubbleImageMasker

#pragma mark - Initialization
-(instancetype)init
{
    return [self initWithBubbleImageFactory:[[ZHCMessagesBubbleImageFactory alloc] init]];
}

-(instancetype)initWithBubbleImageFactory:(ZHCMessagesBubbleImageFactory *)bubbleImageFactory
{
    NSParameterAssert(bubbleImageFactory != nil);
    self = [super init];
    if (self) {
        _bubbleImageFactory = bubbleImageFactory;
    }
    return self;
}

#pragma mark - View masking

- (void)applyOutgoingBubbleImageMaskToMediaView:(UIView *)mediaView
{
    ZHCMessagesBubbleImage *bubbleImageData = [self.bubbleImageFactory outgoingMessagesBubbleImageWithColor:[UIColor whiteColor]];
//    mediaView.layer.borderColor = [UIColor blackColor].CGColor;
//    mediaView.layer.borderWidth = 1.0f;
    [self zhc_maskView:mediaView withImage:[bubbleImageData messageBubbleImage]];
}

- (void)applyIncomingBubbleImageMaskToMediaView:(UIView *)mediaView
{
//    mediaView.layer.borderColor = [UIColor blackColor].CGColor;
//    mediaView.layer.borderWidth = 1.0f;
    ZHCMessagesBubbleImage *bubbleImageData = [self.bubbleImageFactory incomingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    [self zhc_maskView:mediaView withImage:[bubbleImageData messageBubbleImage]];
}


+ (void)applyBubbleImageMaskToMediaView:(UIView *)mediaView isOutgoing:(BOOL)isOutgoing
{
    ZHCMessagesMediaViewBubbleImageMasker *masker = [[ZHCMessagesMediaViewBubbleImageMasker alloc] init];
    
    if (isOutgoing) {
        [masker applyOutgoingBubbleImageMaskToMediaView:mediaView];
    }
    else {
        [masker applyIncomingBubbleImageMaskToMediaView:mediaView];
    }
}



#pragma mark - Private

- (void)zhc_maskView:(UIView *)view withImage:(UIImage *)image
{
    NSParameterAssert(view != nil);
    NSParameterAssert(image != nil);
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame,2.0f, 2.0f);
//    imageViewMask.layer.borderColor = [UIColor redColor].CGColor;
//    imageViewMask.layer.borderWidth = 2.0;
    view.layer.mask = imageViewMask.layer;
}

@end

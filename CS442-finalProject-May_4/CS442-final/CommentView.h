//
//  CommentView.h
//  CS442-final
//
//  Created by T on 5/2/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "CoordinateConverter.h"

@interface CommentView : UIView

@property(strong,nonatomic)  CoordinateConverter *coordinateConverter;

- (id)initWithComment:(Comment *)comment frame:(CGRect)frame coordinateConverter:(CoordinateConverter *)coordinateConverter fontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight screenSize:(CGSize)screenSize /*scale:(CGFloat) scale*/;
- (void)refreshFrameOriginWithScale:(CGFloat)scale offset:(CGPoint)offset;
//- (void)setZoomScale:(CGFloat)scale;
-(BOOL)inSpeechBubbleRect:(CGPoint)pt;

@end

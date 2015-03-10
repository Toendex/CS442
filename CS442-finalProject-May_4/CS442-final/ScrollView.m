//
//  ScrollView.m
//  CS442-final
//
//  Created by T on 5/3/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        UISwipeGestureRecognizer *gr=gestureRecognizer;
        if((gr.direction==UISwipeGestureRecognizerDirectionRight || gr.direction==UISwipeGestureRecognizerDirectionLeft) && self.zoomScale!=1.0)
            return NO;
        return YES;
    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        UISwipeGestureRecognizer *gr=otherGestureRecognizer;
        if((gr.direction==UISwipeGestureRecognizerDirectionRight || gr.direction==UISwipeGestureRecognizerDirectionLeft) && self.zoomScale!=1.0)
            return NO;
        return YES;
    }
    return NO;
}

@end

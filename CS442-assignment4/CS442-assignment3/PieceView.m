//
//  PieceView.m
//  CS442-assignment3
//
//  Created by T on 5/7/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "PieceView.h"

@implementation PieceView {
    CGColorRef _color;
}

- (id)initWithFrame:(CGRect)frame color:(CGColorRef)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _color=color;
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)setColor:(CGColorRef)color
{
    _color=color;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    if(_color!=nil)
        CGContextSetFillColorWithColor(context, _color);
    else
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextAddEllipseInRect(context, self.bounds);
    CGContextFillPath(context);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

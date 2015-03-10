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
    NSString *_imagePath;
}

- (id)initWithFrame:(CGRect)frame imagePath:(NSString *)imagePath
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imagePath=imagePath;
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, self.bounds);
    CGContextClip(context);
    CGContextDrawImage(context, self.bounds, [UIImage imageNamed:_imagePath].CGImage);
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

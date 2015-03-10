//
//  BoardView.m
//  CS442-assignment3
//
//  Created by T on 5/7/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "BoardView.h"

@implementation BoardView {
    NSInteger _rows;
    NSInteger _cols;
    CGFloat _slotDiameter;
}

- (id)initWithFrame:(CGRect)frame rows:(NSInteger)rows cols:(NSInteger)cols slotDiameter:(CGFloat)diameter
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _rows=rows;
        _cols=cols;
        _slotDiameter=diameter;
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextAddRect(context, self.bounds);
    CGFloat width=self.bounds.size.width;
    CGFloat height=self.bounds.size.height;
    width/=(_cols+1);
    height/=(_rows+1);
    for (int r=1; r<=_rows; r++) for (int c=1; c<=_cols; c++) {
        CGContextAddEllipseInRect(context, CGRectMake(width*c-_slotDiameter/2.0, height*r-_slotDiameter/2.0,
                                                      _slotDiameter, _slotDiameter));
    }
    CGContextEOFillPath(context);
    CGContextRestoreGState(context);
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

//
//  GrayView.m
//  CS442-final
//
//  Created by T on 4/30/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "GrayView.h"

@implementation GrayView {
    NSMutableArray *path;
    NSMutableArray *imgPts;
    CGPoint tPoint;
    BOOL ifHasTPoint;
}

- (id)initWithFrame:(CGRect)frame converter:(CoordinateConverter *)coordinateConverter
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        path=[[NSMutableArray alloc] init];
        imgPts=[[NSMutableArray alloc] init];
        _coordinateConverter=coordinateConverter;
        ifHasTPoint=false;
    }
    return self;
}

-(void)setDelegate:(id<GrayViewDelegate>)delegate;
{
    _delegate=delegate;
}

-(void)drawRect:(CGRect)rect
{
    if([path count]<1)
        return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    UIBezierPath *currPath = [UIBezierPath bezierPath];
    currPath.lineWidth=5;
    currPath.lineJoinStyle=kCGLineJoinRound;
    currPath.lineCapStyle=kCGLineCapRound;
    NSValue *z=path[0];
    [currPath moveToPoint:z.CGPointValue];
    for (int i=1; i<[path count]; i++) {
        z=path[i];
        [currPath addLineToPoint:z.CGPointValue];
        [currPath moveToPoint:z.CGPointValue];
    }
    [currPath stroke];
    
    if(ifHasTPoint) {
        CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
        CGContextAddEllipseInRect(context, CGRectMake(tPoint.x-5, tPoint.y-5, 10, 10));
        CGContextFillPath(context);
    }
    
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



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt1=[[touches anyObject] locationInView:self];
    [path addObject:[NSValue valueWithCGPoint:pt1]];
    CGPoint pt2=[self.delegate locateInImgView:touches];
    CGPoint imgPt=[self.coordinateConverter calculateImgPixelPoint:pt2];
    [imgPts addObject:[NSValue valueWithCGPoint:imgPt]];
//    NSLog(@"%f, %f",imgPt.x,imgPt.y);
//    ifHasTPoint=false;
    
    NSInteger n=0;
    float xTotal=0;
    float yTotal=0;
    for (int i=0; i<[imgPts count]; i++) {
        NSValue *z=imgPts[i];
        if(z.CGPointValue.x<0 || z.CGPointValue.y<0)
            continue;
        n++;
        xTotal+=z.CGPointValue.x;
        yTotal+=z.CGPointValue.y;
    }
    if(n!=0) {
        CGPoint medianPoint;
        medianPoint.x=xTotal/n;
        medianPoint.y=yTotal/n;
        tPoint=[self.coordinateConverter calculateScreenPoint:[self.coordinateConverter calculateImgViewPoint:medianPoint]];
        ifHasTPoint=true;
    }
    
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt1=[[touches anyObject] locationInView:self];
    [path addObject:[NSValue valueWithCGPoint:pt1]];
    CGPoint pt2=[self.delegate locateInImgView:touches];
    CGPoint imgPt=[self.coordinateConverter calculateImgPixelPoint:pt2];
    [imgPts addObject:[NSValue valueWithCGPoint:imgPt]];
//    NSLog(@"%f, %f",imgPt.x,imgPt.y);
//    ifHasTPoint=false;
    
    
    NSInteger n=0;
    float xTotal=0;
    float yTotal=0;
    for (int i=0; i<[imgPts count]; i++) {
        NSValue *z=imgPts[i];
        if(z.CGPointValue.x<0 || z.CGPointValue.y<0)
            continue;
        n++;
        xTotal+=z.CGPointValue.x;
        yTotal+=z.CGPointValue.y;
    }
    if(n!=0) {
        CGPoint medianPoint;
        medianPoint.x=xTotal/n;
        medianPoint.y=yTotal/n;
        tPoint=[self.coordinateConverter calculateScreenPoint:[self.coordinateConverter calculateImgViewPoint:medianPoint]];
        ifHasTPoint=true;
    }
    
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSInteger n=0;
    float xTotal=0;
    float yTotal=0;
    for (int i=0; i<[imgPts count]; i++) {
        NSValue *z=imgPts[i];
        if(z.CGPointValue.x<0 || z.CGPointValue.y<0)
            continue;
        n++;
        xTotal+=z.CGPointValue.x;
        yTotal+=z.CGPointValue.y;
    }
    if(n==0) {
        [path removeAllObjects];
        [imgPts removeAllObjects];
    }
    else {
        CGPoint medianPoint;
        medianPoint.x=xTotal/n;
        medianPoint.y=yTotal/n;
        tPoint=[self.coordinateConverter calculateImgViewPoint:medianPoint];
        ifHasTPoint=true;
        [self.delegate locateAtImgPoint:medianPoint];
    }
    [self setNeedsDisplay];
    
}

@end
//
//  CommentView.m
//  CS442-final
//
//  Created by T on 5/2/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView {
    CGPoint theRealPoint;
    BOOL ifExistRealPoint;
    Comment *theComment;
    CGFloat theFontSize;
    CGFloat theMaxWidth;
    CGFloat theMaxHeight;
    CGSize theScreenSize;
    NSMutableAttributedString *attributedText;
    CGRect textRect;
    CGFloat strokeWidth;
    CGFloat borderRadius;
    CGFloat HEIGHTOFPOPUPTRIANGLE;
    CGFloat WIDTHOFPOPUPTRIANGLE;
    CGFloat space;
    CGFloat arrowOffset;
    CGFloat arrowAngle;
    int orientation;  //0=bottom; 1=left; 2=up; 3=right
    CGRect rectField;
//    CGFloat zoomScale;
}

- (id)initWithComment:(Comment *)comment frame:(CGRect)frame coordinateConverter:(CoordinateConverter *)coordinateConverter fontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight screenSize:(CGSize)screenSize /*scale:(CGFloat) scale*/
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _coordinateConverter=coordinateConverter;
        self.userInteractionEnabled=NO;
        self.backgroundColor=[UIColor clearColor];
        theComment=comment;
        theFontSize=fontSize;
        theMaxWidth=maxWidth;
        theMaxHeight=maxHeight;
        theScreenSize=screenSize;
        ifExistRealPoint=false;
//        zoomScale=scale;
        
        //refresh RealPoint
        CGPoint imgPoint=CGPointMake([theComment.xCoordinate floatValue], [theComment.yCoordinate floatValue]);
        theRealPoint=[_coordinateConverter calculateImgViewPoint:imgPoint];
        ifExistRealPoint=true;
        
        [self refreshTextSizeInDrawWithText:theComment.text fontSize:fontSize maxWidth:maxWidth maxHeight:maxHeight];
        [self refreshSpeechBubbleParametersWithScreenSize:screenSize];
    }
    return self;
}

-(void)refreshTextSizeInDrawWithText:(NSString *)text fontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    theFontSize=fontSize;
    theMaxWidth=maxWidth;
    theMaxHeight=maxHeight;
    attributedText=[[NSMutableAttributedString alloc] initWithString:text];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedText length])];
    UIFont *font=[UIFont fontWithName:@"Helvetica" size:fontSize];
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attributedText length])];
    textRect=[attributedText boundingRectWithSize:CGSizeMake(maxWidth,maxHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    textRect.size.height=ceil(textRect.size.height);
}

-(void)refreshSpeechBubbleParametersWithScreenSize:(CGSize)screenSize
{
    theScreenSize=screenSize;
    strokeWidth=2;
    borderRadius=5;
    space=5;
    
    CGPoint imgPoint=CGPointMake([theComment.xCoordinate floatValue], [theComment.yCoordinate floatValue]);
    CGPoint screenPoint=[_coordinateConverter calculateScreenPoint:[_coordinateConverter calculateImgViewPoint:imgPoint]];
    
    HEIGHTOFPOPUPTRIANGLE=10+(arc4random()%((int)ceil(textRect.size.height*0.3+textRect.size.width*2)))*0.05;
    WIDTHOFPOPUPTRIANGLE=5+textRect.size.height*0.03+textRect.size.width*0.07;
    WIDTHOFPOPUPTRIANGLE=(WIDTHOFPOPUPTRIANGLE>textRect.size.width)?(textRect.size.width):WIDTHOFPOPUPTRIANGLE;
    WIDTHOFPOPUPTRIANGLE=(WIDTHOFPOPUPTRIANGLE>textRect.size.height)?(textRect.size.height):WIDTHOFPOPUPTRIANGLE;
    CGFloat robustParameter=2;
    CGFloat totalHeight=HEIGHTOFPOPUPTRIANGLE+textRect.size.height+space*2+strokeWidth*2+robustParameter;
    CGFloat totalWidth=textRect.size.width+space*2+strokeWidth*2+robustParameter;
    NSInteger x=((arc4random()%150)-75);
    arrowOffset=(textRect.size.width+space*2-borderRadius*2-WIDTHOFPOPUPTRIANGLE)*x/200.0f;
    arrowOffset=(abs(arrowOffset)*2+WIDTHOFPOPUPTRIANGLE>textRect.size.height)?(0):(arrowOffset);
//    NSLog(@"text:%@, totalWidth=%f, totalHeight:%f, o.x=%f, o.y=%f, screen.width=%f, screen.height=%f",theComment.text,totalWidth,totalHeight,screenPoint.x,screenPoint.y,screenSize.width,screenSize.height);
    arrowAngle=(arc4random()%100)*(M_PI/2.0)/100.0-M_PI/4.0;
    CGFloat totalXLeftOffset=-tan(arrowAngle)*HEIGHTOFPOPUPTRIANGLE-arrowOffset;
    int orientations[4];
    for (int i=0; i<4; i++) {
        orientations[i]=1;
    }
    if(screenPoint.x+(totalWidth/2.0f)-totalXLeftOffset > screenSize.width ||
       screenPoint.x-(totalWidth/2.0f)-totalXLeftOffset < 0 ||
       screenPoint.y+totalHeight > screenSize.height) {
        orientations[0]=0;
    }
    if(screenPoint.y+(totalHeight/2.0f)-totalXLeftOffset > screenSize.height ||
       screenPoint.y-(totalHeight/2.0f)-totalXLeftOffset < 0 ||
       screenPoint.x-totalWidth < 0) {
        orientations[1]=0;
    }
    if(screenPoint.x+(totalWidth/2.0f)+totalXLeftOffset > screenSize.width ||
       screenPoint.x-(totalWidth/2.0f)+totalXLeftOffset < 0 ||
       screenPoint.y-totalHeight < 0) {
        orientations[2]=0;
    }
    if(screenPoint.y+(totalHeight/2.0f)+totalXLeftOffset > screenSize.height ||
       screenPoint.y-(totalHeight/2.0f)+totalXLeftOffset < 0 ||
       screenPoint.x+totalWidth > screenSize.width) {
        orientations[3]=0;
    }
    assert(orientations[0]+orientations[1]+orientations[2]+orientations[3]>0);
    int oIndex=arc4random()%4;
    for (int i=0; i<4; i++) {
        if(orientations[oIndex]!=0)
            break;
        oIndex++;
        oIndex%=4;
    }
    orientation=oIndex;  //0=bottom; 1=left; 2=up; 3=right
    
//    NSLog(@"text:%@ (%d,%d,%d,%d)",theComment.text,orientations[0],orientations[1],orientations[2],orientations[3]);

}

- (void)refreshFrameOriginWithScale:(CGFloat)scale offset:(CGPoint)offset
{
    CGPoint imgPoint=CGPointMake([theComment.xCoordinate floatValue], [theComment.yCoordinate floatValue]);
    CGPoint imgViewPoint=[_coordinateConverter calculateImgViewPoint:imgPoint];
    imgViewPoint.x*=scale;
    imgViewPoint.y*=scale;
    CGRect frame=self.frame;
    frame.origin.x=imgViewPoint.x-theRealPoint.x;
    frame.origin.y=imgViewPoint.y-theRealPoint.y;
    self.frame=frame;
}

//- (void)setZoomScale:(CGFloat)scale
//{
//    zoomScale=scale;
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)doZoomCTM:(CGContextRef)context xScale:(CGFloat)xScale yScale:(CGFloat)yScale origin:(CGPoint)origin
{
    CGContextTranslateCTM(context, origin.x, origin.y);
    CGContextScaleCTM(context, xScale, yScale);
    CGContextTranslateCTM(context, -origin.x, -origin.y);
}

-(void)doRotateCTM:(CGContextRef)context angle:(CGFloat)angle origin:(CGPoint)origin
{
    CGContextTranslateCTM(context, origin.x, origin.y);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, -origin.x, -origin.y);
}

-(void)drawRect:(CGRect)rect
{
    if(!ifExistRealPoint)
        return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    
//    [self doZoomCTM:context xScale:1.0/zoomScale yScale:1.0/zoomScale origin:theRealPoint];
    [self doRotateCTM:context angle:M_PI_2*orientation origin:theRealPoint];
    
    CGFloat rectXOffset=theRealPoint.x+arrowOffset;
    CGFloat totalXOffset=tan(arrowAngle)*HEIGHTOFPOPUPTRIANGLE;
    CGFloat totalYOffset=0;
    CGFloat rectHeight=textRect.size.height+HEIGHTOFPOPUPTRIANGLE+space*2+strokeWidth*2;
    CGFloat rectWidth=textRect.size.width+space*2+strokeWidth*2;
    if(orientation%2==1) {
        rectWidth=textRect.size.height+space*2+strokeWidth*2;
        rectHeight=textRect.size.width+HEIGHTOFPOPUPTRIANGLE+space*2+strokeWidth*2;
    }
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:1].CGColor);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] colorWithAlphaComponent:1].CGColor);
    
    // Draw and fill the bubble
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,
                         totalXOffset + rectXOffset - rectWidth / 2.0f  + borderRadius + strokeWidth + 0.5f,
                         totalYOffset + theRealPoint.y + strokeWidth + HEIGHTOFPOPUPTRIANGLE + 0.5f);
    CGContextAddLineToPoint(context,
                            totalXOffset + theRealPoint.x - rectWidth / 2.0f  + round(rectWidth / 2.0f - WIDTHOFPOPUPTRIANGLE / 2.0f) + 0.5f,
                            totalYOffset + theRealPoint.y + HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f);
    CGContextAddLineToPoint(context,
                            theRealPoint.x - rectWidth / 2.0f  + round(rectWidth / 2.0f) + 0.5f,
                            theRealPoint.y + strokeWidth + 0.5f);
    CGContextAddLineToPoint(context,
                            totalXOffset + theRealPoint.x - rectWidth / 2.0f  + round(rectWidth / 2.0f + WIDTHOFPOPUPTRIANGLE / 2.0f) + 0.5f,
                            totalYOffset + theRealPoint.y + HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f);
    CGContextAddArcToPoint(context,
                           totalXOffset + rectXOffset - rectWidth / 2.0f  + rectWidth - strokeWidth - 0.5f,
                           totalYOffset + theRealPoint.y + strokeWidth + HEIGHTOFPOPUPTRIANGLE + 0.5f,
                           totalXOffset + rectXOffset - rectWidth / 2.0f  + rectWidth - strokeWidth - 0.5f,
                           totalYOffset + theRealPoint.y + rectHeight - strokeWidth - 0.5f,
                           borderRadius - strokeWidth);
    CGContextAddArcToPoint(context,
                           totalXOffset + rectXOffset - rectWidth / 2.0f  + rectWidth - strokeWidth - 0.5f,
                           totalYOffset + theRealPoint.y + rectHeight - strokeWidth - 0.5f,
                           round(totalXOffset + rectXOffset - rectWidth / 2.0f  + rectWidth / 2.0f + WIDTHOFPOPUPTRIANGLE / 2.0f) - strokeWidth + 0.5f,
                           totalYOffset + theRealPoint.y + rectHeight - strokeWidth - 0.5f,
                           borderRadius - strokeWidth);
    CGContextAddArcToPoint(context,
                           totalXOffset + rectXOffset - rectWidth / 2.0f  + strokeWidth + 0.5f,
                           totalYOffset + theRealPoint.y + rectHeight - strokeWidth - 0.5f,
                           totalXOffset + rectXOffset - rectWidth / 2.0f  + strokeWidth + 0.5f,
                           totalYOffset + theRealPoint.y + HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f, borderRadius - strokeWidth);
    CGContextAddArcToPoint(context,
                           totalXOffset + rectXOffset - rectWidth / 2.0f  + strokeWidth + 0.5f,
                           totalYOffset + theRealPoint.y + strokeWidth + HEIGHTOFPOPUPTRIANGLE + 0.5f,
                           totalXOffset + rectXOffset - rectWidth / 2.0f  + rectWidth - strokeWidth - 0.5f,
                           totalYOffset + theRealPoint.y + HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f, borderRadius - strokeWidth);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    [self doRotateCTM:context angle:-M_PI_2*orientation origin:theRealPoint];
    
    switch (orientation) {
        case 0:
            textRect.origin.x=totalXOffset + rectXOffset - rectWidth / 2.0f  + strokeWidth + space + 0.5f;
            textRect.origin.y=theRealPoint.y+HEIGHTOFPOPUPTRIANGLE+space+strokeWidth;
            rectField=CGRectMake(totalXOffset + rectXOffset - rectWidth / 2.0f  + strokeWidth,
                                 theRealPoint.y+HEIGHTOFPOPUPTRIANGLE + strokeWidth,
                                 textRect.size.width + 2 * space,
                                 textRect.size.height + 2 * space);
            break;
        case 2:
            textRect.origin.x=-totalXOffset + theRealPoint.x - arrowOffset - rectWidth / 2.0f  + strokeWidth + space + 0.5f;
            textRect.origin.y=theRealPoint.y-rectHeight+space+strokeWidth;
            rectField=CGRectMake(-totalXOffset + theRealPoint.x - arrowOffset - rectWidth / 2.0f+strokeWidth+0.5f,
                                 theRealPoint.y-rectHeight+strokeWidth,
                                 textRect.size.width + 2 * space,
                                 textRect.size.height + 2 * space);
            break;
        case 1:
            textRect.origin.x=theRealPoint.x-HEIGHTOFPOPUPTRIANGLE-space-strokeWidth-textRect.size.width;
            textRect.origin.y=theRealPoint.y-(rectWidth/2.0f)+arrowOffset+totalXOffset+space+strokeWidth;
            rectField=CGRectMake(theRealPoint.x-HEIGHTOFPOPUPTRIANGLE-strokeWidth-2*space-textRect.size.width,
                                 theRealPoint.y-(rectWidth/2.0f)+arrowOffset+totalXOffset+strokeWidth,
                                 textRect.size.width + 2 * space,
                                 textRect.size.height + 2 * space);
            break;
        case 3:
            textRect.origin.x=theRealPoint.x+HEIGHTOFPOPUPTRIANGLE+space+strokeWidth;
            textRect.origin.y=theRealPoint.y-(rectWidth/2.0f)-arrowOffset-totalXOffset+space+strokeWidth;
            rectField=CGRectMake(theRealPoint.x+HEIGHTOFPOPUPTRIANGLE + strokeWidth,
                                 theRealPoint.y-(rectWidth/2.0f)-arrowOffset-totalXOffset + strokeWidth,
                                 textRect.size.width + 2 * space,
                                 textRect.size.height + 2 * space);
            
            break;
    }
    [attributedText drawWithRect:textRect options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    
//    CGContextSetFillColorWithColor(context, [[UIColor greenColor] colorWithAlphaComponent:0.5].CGColor);
//    CGContextFillRect(context, rectField);
    
    // Draw a clipping path for the fill
    //    CGContextBeginPath(context);
    //    CGContextMoveToPoint(context, borderRadius + strokeWidth + 0.5f, round((rectHeight + HEIGHTOFPOPUPTRIANGLE) * 0.50f) + 0.5f);
    //    CGContextAddArcToPoint(context, rectWidth - strokeWidth - 0.5f, round((rectHeight + HEIGHTOFPOPUPTRIANGLE) * 0.50f) + 0.5f, rectWidth - strokeWidth - 0.5f, rectHeight - strokeWidth - 0.5f, borderRadius - strokeWidth);
    //    CGContextAddArcToPoint(context, rectWidth - strokeWidth - 0.5f, rectHeight - strokeWidth - 0.5f, round(rectWidth / 2.0f + WIDTHOFPOPUPTRIANGLE / 2.0f) - strokeWidth + 0.5f, rectHeight - strokeWidth - 0.5f, borderRadius - strokeWidth);
    //    CGContextAddArcToPoint(context, strokeWidth + 0.5f, rectHeight - strokeWidth - 0.5f, strokeWidth + 0.5f, HEIGHTOFPOPUPTRIANGLE + strokeWidth + 0.5f, borderRadius - strokeWidth);
    //    CGContextAddArcToPoint(context, strokeWidth + 0.5f, round((rectHeight + HEIGHTOFPOPUPTRIANGLE) * 0.50f) + 0.5f, rectWidth - strokeWidth - 0.5f, round((rectHeight + HEIGHTOFPOPUPTRIANGLE) * 0.50f) + 0.5f, borderRadius - strokeWidth);
    //    CGContextClosePath(context);
    //    CGContextClip(context);
    
    
    CGContextRestoreGState(context);
}

-(BOOL)inSpeechBubbleRect:(CGPoint)pt
{
    return CGRectContainsPoint(rectField, pt);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

@end

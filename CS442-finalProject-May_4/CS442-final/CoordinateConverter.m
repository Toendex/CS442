//
//  CoordinateConverter.m
//  CS442-final
//
//  Created by T on 5/2/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "CoordinateConverter.h"

@implementation CoordinateConverter

-(CGPoint)calculateScreenPoint:(CGPoint)imgViewPt
{
    CGPoint screenPoint;
    UIScrollView *scrollView=[self.delegate getScrollView];
    CGPoint offset=[scrollView contentOffset];
    CGFloat scale=[scrollView zoomScale];
    screenPoint.x=imgViewPt.x*scale-offset.x+scrollView.frame.origin.x;
    screenPoint.y=imgViewPt.y*scale-offset.y+scrollView.frame.origin.y;
//    NSLog(@"scale:%f", scale);
//    NSLog(@"offset:(%f,%f)", offset.x, offset.y);
//    NSLog(@"(%f,%f)", scrollView.frame.origin.x, scrollView.frame.origin.y);
    return screenPoint;
}

-(CGPoint)calculateImgViewPoint:(CGPoint)imgPt
{
    CGPoint imgViewPt;
    UIImageView *imgView=[self.delegate getImageView];
    CGSize imgSize=imgView.image.size;
    CGSize imgViewSize=imgView.bounds.size;
    CGFloat imgRatio=imgSize.height/imgSize.width;
    CGFloat imgViewRatio=imgViewSize.height/imgViewSize.width;
    CGFloat heightMid=imgViewSize.height/2.0;
    CGFloat widthMid=imgViewSize.width/2.0;
    if (imgRatio==imgViewRatio) {
        imgViewPt.x=imgPt.x*imgViewSize.width/imgSize.width;
        imgViewPt.y=imgPt.y*imgViewSize.height/imgSize.height;
    }
    else if (imgRatio<imgViewRatio) {
        CGFloat realImgWidth=imgViewSize.width;
        CGFloat realImgHeight=imgSize.height*realImgWidth/imgSize.width;
        imgViewPt.x=imgPt.x*imgViewSize.width/imgSize.width;
        imgViewPt.y=(imgViewSize.height/2.0)+((imgPt.y-(imgSize.height/2.0))*imgViewSize.width/imgSize.width);
    }
    else if (imgRatio>imgViewRatio) {
        CGFloat realImgHeight=imgViewSize.height;
        CGFloat realImgWidth=imgSize.width*realImgHeight/imgSize.height;
        imgViewPt.x=(imgViewSize.width/2.0)+((imgPt.x-(imgSize.width/2.0))*imgViewSize.height/imgSize.height);
        imgViewPt.y=imgPt.y*imgViewSize.height/imgSize.height;
    }
    return imgViewPt;
}

-(CGPoint)calculateImgPixelPoint:(CGPoint)imgViewPt
{
    CGPoint imgPt;
    UIImageView *imgView=[self.delegate getImageView];
    CGSize imgSize=imgView.image.size;
    CGSize imgViewSize=imgView.bounds.size;
    CGFloat imgRatio=imgSize.height/imgSize.width;
    CGFloat imgViewRatio=imgViewSize.height/imgViewSize.width;
    CGFloat heightMid=imgViewSize.height/2.0;
    CGFloat widthMid=imgViewSize.width/2.0;
    if (imgRatio==imgViewRatio) {
        imgPt.x=imgViewPt.x*imgSize.width/imgViewSize.width;
        imgPt.y=imgViewPt.y*imgSize.height/imgViewSize.height;
    }
    else if (imgRatio<imgViewRatio) {
        CGFloat realImgWidth=imgViewSize.width;
        CGFloat realImgHeight=imgSize.height*realImgWidth/imgSize.width;
        if (imgViewPt.x<=(widthMid-realImgWidth/2.0) || imgViewPt.x>=(widthMid+realImgWidth/2.0) ||
            imgViewPt.y<=(heightMid-realImgHeight/2.0) || imgViewPt.y>=(heightMid+realImgHeight/2.0)) {
            imgPt.x=imgPt.y=-1;
        }
        else {
            imgPt.x=imgViewPt.x*imgSize.width/imgViewSize.width;
            imgPt.y=(imgSize.height/2.0)+((imgViewPt.y-(imgViewSize.height/2.0))*imgSize.width/imgViewSize.width);
        }
    }
    else if (imgRatio>imgViewRatio) {
        CGFloat realImgHeight=imgViewSize.height;
        CGFloat realImgWidth=imgSize.width*realImgHeight/imgSize.height;
        if (imgViewPt.x<=(widthMid-realImgWidth/2.0) || imgViewPt.x>=(widthMid+realImgWidth/2.0) ||
            imgViewPt.y<=(heightMid-realImgHeight/2.0) || imgViewPt.y>=(heightMid+realImgHeight/2.0)) {
            imgPt.x=imgPt.y=-1;
        }
        else {
            imgPt.x=(imgSize.width/2.0)+((imgViewPt.x-(imgViewSize.width/2.0))*imgSize.height/imgViewSize.height);
            imgPt.y=imgViewPt.y*imgSize.height/imgViewSize.height;
        }
    }
    return imgPt;
}

@end

//
//  CoordinateConverter.h
//  CS442-final
//
//  Created by T on 5/2/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoordinateConvertDelegate;

@interface CoordinateConverter : NSObject

@property(weak,nonatomic) id<CoordinateConvertDelegate> delegate;

-(CGPoint)calculateScreenPoint:(CGPoint)imgViewPt;
-(CGPoint)calculateImgViewPoint:(CGPoint)imgPt;
-(CGPoint)calculateImgPixelPoint:(CGPoint)imgViewPt;

@end

@protocol CoordinateConvertDelegate <NSObject>
-(UIImageView*)getImageView;
-(UIScrollView*)getScrollView;
@end

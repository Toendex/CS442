//
//  GrayView.h
//  CS442-final
//
//  Created by T on 5/1/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoordinateConverter.h"

@protocol GrayViewDelegate;

@interface GrayView : UIView

@property(weak,nonatomic) id<GrayViewDelegate> delegate;
@property(strong,nonatomic)  CoordinateConverter *coordinateConverter;

-(void)setDelegate:(id<GrayViewDelegate>)delegate;
- (id)initWithFrame:(CGRect)frame converter:(CoordinateConverter *)coordinateConverter;

@end


@protocol GrayViewDelegate <NSObject>
-(void)locateAtImgPoint:(CGPoint)imgPoint;
-(CGPoint)locateInImgView:(NSSet *)touches;
@end

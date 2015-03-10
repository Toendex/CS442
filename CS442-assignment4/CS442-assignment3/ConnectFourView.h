//
//  ConnectFourView.h
//  CS442-assignment3
//
//  Created by T on 5/7/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardView.h"
#import "PieceView.h"

@protocol ConnectFourDelegate;

@interface ConnectFourView : UIView

@property (weak) id<ConnectFourDelegate> delegate;
@property BOOL ifAnimating;

- (id)initWithFrame:(CGRect)frame rows:(NSInteger)rows cols:(NSInteger)cols slotDiameter:(CGFloat)diameter;
- (void)addToColumn:(NSUInteger)column row:(NSUInteger)row withColor:(CGColorRef)color withAnimate:(BOOL)ifDoAnimate;
- (void)reset;

@end

@protocol ConnectFourDelegate<NSObject>

-(void)columnTapped:(NSUInteger)column;
-(void)didEndMove;

@end

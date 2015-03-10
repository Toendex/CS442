//
//  PieceView.h
//  CS442-assignment3
//
//  Created by T on 5/7/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieceView : UIView

- (id)initWithFrame:(CGRect)frame color:(CGColorRef)color;
-(void)setColor:(CGColorRef)color;
@end

//
//  BoardView.h
//  CS442-assignment3
//
//  Created by T on 5/7/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardView : UIView

- (id)initWithFrame:(CGRect)frame rows:(NSInteger)rows cols:(NSInteger)cols slotDiameter:(CGFloat)diameter imagePath:(NSString *)imagePath;

@end

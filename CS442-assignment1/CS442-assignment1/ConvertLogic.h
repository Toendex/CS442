//
//  ConvertLogic.h
//  CS442-assignment1
//
//  Created by T on 3/8/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertLogic : NSObject

- (void) act:(int)type Orientation:(int)orientation Value:(double)value;

@end

typedef enum{UpToDown, DownToUp} Orientation;

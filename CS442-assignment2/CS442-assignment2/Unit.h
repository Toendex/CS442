//
//  Unit.h
//  CS442-assignment2
//
//  Created by T on 3/25/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Unit : NSObject

@property NSString* name;
@property id parameters;
@property double mValue;

-(id)initWithName:(NSString *)name parameters:(id) parameters;
-(id)initWithName:(NSString *)name parameters:(NSArray *)parameters value:(double)value;
-(double)toBase:(double)value;
-(double)toThis:(double)baseValue;

-(double)toBase2;
-(void)toThis2:(double)baseValue;

@end

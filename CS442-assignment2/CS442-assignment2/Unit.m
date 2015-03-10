//
//  Unit.m
//  CS442-assignment2
//
//  Created by T on 3/25/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "Unit.h"

@implementation Unit

-(id)init {
    return [self initWithName:nil parameters:nil value:0];
}

-(id)initWithName:(NSString *)name parameters:(NSArray *)parameters {
    return [self initWithName:name parameters:parameters value:0];
}

-(id)initWithName:(NSString *)name parameters:(NSArray *)parameters value:(double)value {
    self=[super init];
    if(self) {
        _name=name;
        _parameters=parameters;
        _mValue=value;
    }
    return self;
}

-(double)toBase:(double)value {
    double r=0;
    if ([_parameters isKindOfClass:[NSNumber class]]) {
        double c=[(NSNumber*)_parameters floatValue];
        r=value*c;
    }
    else if([_parameters isKindOfClass:[NSArray class]]) {
        double a=[(NSNumber*)[(NSArray*)_parameters objectAtIndex:0] floatValue];
        double b=[(NSNumber*)[(NSArray*)_parameters objectAtIndex:1] floatValue];
        r=value*a+b;
    }
    return r;
}

-(double)toThis:(double)baseValue {
    double r=0;
    if ([_parameters isKindOfClass:[NSNumber class]]) {
        double c=[(NSNumber*)_parameters floatValue];
        r=baseValue/c;
    }
    else if([_parameters isKindOfClass:[NSArray class]]) {
        double a=[(NSNumber*)[(NSArray*)_parameters objectAtIndex:0] floatValue];
        double b=[(NSNumber*)[(NSArray*)_parameters objectAtIndex:1] floatValue];
        r=(baseValue-b)/a;
    }
    return r;
}

-(double)toBase2 {
    return [self toBase:_mValue];
}

-(void)toThis2:(double)baseValue {
    [self setMValue:[self toThis:baseValue]];
}

@end

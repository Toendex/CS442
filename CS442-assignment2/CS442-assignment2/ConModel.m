//
//  ConModel.m
//  CS442-assignment2
//
//  Created by T on 3/25/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "ConModel.h"

@implementation ConModel {
    NSDictionary *data;
    NSArray *categories;
    NSMutableArray *units;
}

+(id)sharedSingleton:(NSString *)filename {
    static ConModel * sharedS=nil;
    @synchronized(self) {
        if (sharedS==nil) {
            sharedS=[[ConModel alloc] init];
            [sharedS readPlist:filename];
        }
    }
    return sharedS;
}

-(void)readPlist:(NSString *)filename {
    NSString *path=[[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    data=[NSDictionary dictionaryWithContentsOfFile:path];
    categories=[data valueForKey:@"Categories"];
    units=[[NSMutableArray alloc] init];
//    NSDictionary *baseType=[data valueForKey:@"Base_Types"];
    for (int i=0;i<[categories count];i++) {
        NSDictionary *dic=[data valueForKey:(NSString*)[categories objectAtIndex:i]];
        NSMutableArray *array=[[NSMutableArray alloc] init];
        for (id key in dic) {
//            rif([key isEqualToString:[baseType valueForKey:[categories objectAtIndex:i]]])
            Unit *unit=[[Unit alloc] initWithName:key parameters:[dic valueForKey:key] value:1];
            [array addObject:unit];
        }
        [units addObject:array];
        [self setValuesForCategoryIndex:i baseOnChangedIndex:0];
    }
}

-(NSInteger)numOfCategories {
    return [categories count];
}

-(NSInteger)numOfUnits:(NSInteger)index {
    return [(NSDictionary*)[units objectAtIndex:index] count];
}

-(NSString *)getCategoryName:(NSInteger)index {
    return (NSString *)[categories objectAtIndex:index];
}

-(NSString *)getUnitName:(NSInteger)index ofCategory:(NSInteger)indexofCategory {
    return [(Unit *)[(NSArray *)[units objectAtIndex:indexofCategory] objectAtIndex:index] name];
}

- (double)getUnitValue:(NSInteger)index ofCategory:(NSInteger)indexofCategory {
    return [(Unit *)[(NSArray *)[units objectAtIndex:indexofCategory] objectAtIndex:index] mValue];
}

-(void)changeValue:(double)value ofIndex:(NSInteger)index OfCategory:(NSInteger)indexofCategory {
    [[[units objectAtIndex:indexofCategory] objectAtIndex:index] setMValue:value];
    [self setValuesForCategoryIndex:indexofCategory baseOnChangedIndex:index];
}

-(void)setValuesForCategoryIndex:(NSInteger)categoryIndex baseOnChangedIndex:(NSInteger)changedIndex {
    NSArray* array=[units objectAtIndex:categoryIndex];
    double base=[[array objectAtIndex:changedIndex] toBase2];
    for (int i=0;i<[array count];i++) {
        if(i==changedIndex)
            continue;
        [[array objectAtIndex:i] toThis2:base];
    }
}



@end

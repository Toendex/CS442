//
//  ConModel.h
//  CS442-assignment2
//
//  Created by T on 3/25/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Unit.h"

@interface ConModel : NSObject

+ (id)sharedSingleton:(NSString *)filename;

- (void)readPlist:(NSString *)filename;
- (NSInteger)numOfCategories;
- (NSInteger)numOfUnits:(NSInteger)index;
- (NSString*)getCategoryName:(NSInteger)index;
- (NSString*)getUnitName:(NSInteger)index ofCategory:(NSInteger)indexofCategory;
- (double)getUnitValue:(NSInteger)index ofCategory:(NSInteger)indexofCategory;
- (void)setValuesForCategoryIndex:(NSInteger)categoryIndex baseOnChangedIndex:(NSInteger)changedIndex;
- (void)changeValue:(double)value ofIndex:(NSInteger)index OfCategory:(NSInteger)indexofCategory;
@end

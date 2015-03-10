//
//  Img.h
//  CS442-final
//
//  Created by T on 4/1/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import <Parse/Parse.h>

@interface PostModel : NSObject

@property (strong, atomic) NSMutableArray *posts;
@property (strong, nonatomic) NSMutableArray *strs;

+ (id)sharedSingleton;

- (void)readPosts;
- (void)removeObjectAtIndex:(NSInteger)index;
- (Post *)postAtIndex:(NSInteger)index;
- (NSInteger)count;

@end

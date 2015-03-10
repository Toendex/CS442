//
//  Img.m
//  CS442-final
//
//  Created by T on 4/1/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel

+(id)sharedSingleton {
    static PostModel * sharedS=nil;
    @synchronized(self) {
        if (sharedS==nil) {
            sharedS=[[PostModel alloc] init];
            [sharedS readPosts];
        }
    }
    return sharedS;
}

- (void)readPosts {
//    _strs=[@[@"IMG_0002.JPG",
//             @"IMG_0249.JPG",
//             @"IMG_0257.JPG",
//             @"IMG_0236.JPG",
//             @"IMG_0287.JPG",
//             @"IMG_0293.jpg"] mutableCopy];
//    _posts=[[NSMutableArray alloc] init];
//    for(int i=0;i<[_strs count];i++) {
//        [_posts addObject:[Post tempInitWithImageName:[_strs objectAtIndex:i]]];
//    }
    _posts=[[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    NSArray *pts=[query findObjects];
    for (PFObject *obj in pts) {
        Post *p=[Post initWithPFPostObject:obj];
        if(p)
            [_posts insertObject:p atIndex:0];
    }
}

- (void)removeObjectAtIndex:(NSInteger)index {
    [_posts removeObjectAtIndex:index];
}

-(Post *)postAtIndex:(NSInteger)index {
    return [_posts objectAtIndex:index];
}

-(NSInteger)count {
    return [_posts count];
}

@end

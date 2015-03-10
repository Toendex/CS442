//
//  Post.h
//  CS442-final
//
//  Created by T on 4/8/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol PostDelegate;

@interface Post : NSObject

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSMutableArray *imgs;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *contentText;
@property (strong, nonatomic) NSDate *date;
@property (weak, atomic) id<PostDelegate> delegate;
@property (strong, nonatomic) NSString *ID;

-(void)addImage:(UIImage *)image;
-(NSInteger)imageCount;
-(UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath;
-(void)doPost;
//+(Post *)tempInitWithImageName:(NSString *)imgName;
+(Post *)initWithPFPostObject:(PFObject *)postObject;

@end

@protocol PostDelegate <NSObject>

-(void)didEndPost;
-(void)setProgress:(float)percentDone;

@end
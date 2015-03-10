//
//  Game.h
//  CS442-assignment3
//
//  Created by T on 5/7/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Game : NSObject

//-(void)setToInit;
-(id)initWithRows:(int)rows cols:(int)cols isFirstPlayer:(BOOL)isFirstPlayer;
-(int)addPieceToColumn:(NSUInteger)column usr:(PFUser *)usr;
-(BOOL)ifEnd;
-(int)nowTurn;
-(int)winner;
-(PFUser *)player:(int)index;
-(PFUser *)creator;
-(NSArray *)gameSteps;
-(NSArray *)gameMatrix;
-(BOOL)joinToGame:(PFUser *)usr;

-(id)initWithPFObject:(PFObject *)game;
-(void)saveInBackgroundWithBlock:(void(^)(BOOL succeeded, NSError *error))block;
@end

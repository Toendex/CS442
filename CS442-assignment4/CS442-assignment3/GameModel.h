//
//  GameModel.h
//  CS442-assignment4
//
//  Created by T on 5/8/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Game.h"

@interface GameModel : NSObject

-(void)doQueryInBackground:(void(^)())block;

-(NSInteger)numOfArrays;
-(NSUInteger)countOfArray:(NSInteger)indexOfArray;
-(Game *)objectAtIndexPath:(NSIndexPath *)indexPath;
-(void)addNewGame:(Game *)game ifFirstPlayer:(BOOL)ifFirstPlayer;
-(void)removeAll;
-(Game *)getAvailableGame;
//-(void)didStepOnGame:(Game *)game;

@end

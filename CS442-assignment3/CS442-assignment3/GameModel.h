//
//  GameModel.h
//  CS442-assignment3
//
//  Created by T on 5/7/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject

-(id)initWithRows:(NSInteger)rows cols:(NSInteger)cols;
-(int)addPieceToColumn:(NSUInteger)column;
-(BOOL)ifEnd;
-(int)nowTurn;
-(int)winner;
-(void)reset;
-(BOOL)ifAvaliableAtColumn:(NSUInteger)column;
-(NSMutableArray *)avaliableColumns;
@end

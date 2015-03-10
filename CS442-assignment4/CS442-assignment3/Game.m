//
//  Game.m
//  CS442-assignment3
//
//  Created by T on 5/7/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "Game.h"

@implementation Game {
    PFObject *_game;
    int _rows;
    int _cols;
    int _nowTurn;
    BOOL _ifEnd;
    int _winner;
    NSMutableArray *_gameMatrix;
    NSMutableArray *_lastIndexsInEachColum;
    NSMutableArray *_gameSteps;
    PFUser *_firstPlayer;
    PFUser *_secondPlayer;
    PFUser *_creator;
    //0=no;1=first_player;2=second_player
    //1=first_player;2=second_player;
}

//-(void)setToInit
//{
//    _gameMatrix=[NSMutableArray array];
//    int rows=[_game[@"rows"] intValue];
//    int cols=[_game[@"cols"] intValue];
//    for (int r=0; r<rows; r++) {
//        NSMutableArray *row=[NSMutableArray array];
//        for (int c=0; c<cols; c++) {
//            [row addObject:[NSNumber numberWithInt:-1]];
//        }
//        [_gameMatrix addObject:row];
//    }
//    _lastIndexsInEachColum=[NSMutableArray array];
//    for (int c=0; c<cols; c++) {
//        [_lastIndexsInEachColum addObject:[NSNumber numberWithInt:-1]];
//    }
//    _gameSteps=[NSMutableArray array];
//}

-(id)initWithRows:(int)rows cols:(int)cols isFirstPlayer:(BOOL)isFirstPlayer
{
    if (self=[super init]) {
        _gameMatrix=[NSMutableArray array];
        for (int r=0; r<rows; r++) {
            NSMutableArray *row=[NSMutableArray array];
            for (int c=0; c<cols; c++) {
                [row addObject:[NSNumber numberWithInt:-1]];
            }
            [_gameMatrix addObject:row];
        }
        _lastIndexsInEachColum=[NSMutableArray array];
        for (int c=0; c<cols; c++) {
            [_lastIndexsInEachColum addObject:[NSNumber numberWithInt:-1]];
        }
        _rows=rows;
        _cols=cols;
        _nowTurn=1;
        _ifEnd=NO;
        _winner=-1;
        _game=[PFObject objectWithClassName:@"Game"];
        _creator=[PFUser currentUser];
        _gameSteps=[NSMutableArray array];
        if(isFirstPlayer) {
            _firstPlayer=[PFUser currentUser];
            _secondPlayer=nil;
        }
        else {
            _firstPlayer=nil;
            _secondPlayer=[PFUser currentUser];
        }
    }
    return self;
}

-(int)addPieceToColumn:(NSUInteger)column usr:(PFUser *)usr
{
    assert(usr!=nil);
    assert(column>=0 && column<_cols);
    if(([self player:_nowTurn]!=nil && ![[usr objectId] isEqualToString:[[self player:_nowTurn] objectId]]) ||
       ([self player:_nowTurn]==nil && [[usr objectId] isEqualToString:[[self player:(3-_nowTurn)] objectId]]))
        return -1;
    if(_ifEnd)
        return -1;
    int lastIndex=[[_lastIndexsInEachColum objectAtIndex:column] intValue];
    if(lastIndex>=(_rows-1)) {
        return -1;
    }
    int newLastIndex=lastIndex+1;
    [[_gameMatrix objectAtIndex:newLastIndex] replaceObjectAtIndex:column withObject:[NSNumber numberWithInt:_nowTurn]];
    [_lastIndexsInEachColum replaceObjectAtIndex:column withObject:[NSNumber numberWithInt:newLastIndex]];
    [_gameSteps addObject:[NSNumber numberWithUnsignedInteger:column]];
    _ifEnd=[self ifCauseEndAtRow:newLastIndex column:column];
    if(_ifEnd)
        _winner=_nowTurn;
    else {
        _ifEnd=[self ifFull];
        if(_ifEnd)
            _winner=-1;
    }
    _nowTurn=3-_nowTurn;
    return newLastIndex;
}

-(BOOL)ifFull
{
    for (int r=0; r<_rows; r++) for (int c=0; c<_cols; c++) {
        if ([[[_gameMatrix objectAtIndex:r] objectAtIndex:c] intValue]!=1 &&
            [[[_gameMatrix objectAtIndex:r] objectAtIndex:c] intValue]!=2)
            return NO;
    }
    return YES;
}

-(BOOL)ifCauseEndAtRow:(NSUInteger)row column:(NSUInteger)column
{
    int turn=[[[_gameMatrix objectAtIndex:row] objectAtIndex:column] intValue];
    assert(turn!=-1);
    int n;
    n=1;
    for (int r=row-1; r>-1; r--) {
        if([[[_gameMatrix objectAtIndex:r] objectAtIndex:column] intValue]!=turn)
            break;
        n++;
    }
    if(n>=4)
        return YES;
    
    n=0;
    for (int c=0; c<_cols; c++) {
        if([[[_gameMatrix objectAtIndex:row] objectAtIndex:c] intValue]==turn) {
            n++;
            if(n>=4)
                return YES;
        }
        else
            n=0;
    }
    
    n=0;
    int x=row-column;
    for (int r=0; r<_rows; r++) {
        int c=r-x;
        if(c<0 || c>=_cols)
            continue;
        if([[[_gameMatrix objectAtIndex:r] objectAtIndex:c] intValue]==turn) {
            n++;
            if(n>=4)
                return YES;
        }
        else
            n=0;
    }
    
    n=0;
    int y=row+column;
    for (int r=0; r<_rows; r++) {
        int c=y-r;
        if(c<0 || c>=_cols)
            continue;
        if([[[_gameMatrix objectAtIndex:r] objectAtIndex:c] intValue]==turn) {
            n++;
            if(n>=4)
                return YES;
        }
        else
            n=0;
    }

    return NO;
}

-(BOOL)ifEnd
{
    return _ifEnd;
}

-(int)nowTurn
{
    return _nowTurn;
}

-(int)winner
{
    return _winner;
}

-(PFUser *)player:(int)index
{
    if(index==1)
        return _firstPlayer;
    if(index==2)
        return _secondPlayer;
    return nil;
}

-(PFUser *)creator
{
    return _creator;
}

-(NSArray *)gameSteps
{
    return _gameSteps;
}

-(NSArray *)gameMatrix
{
    return _gameMatrix;
}

-(BOOL)joinToGame:(PFUser *)usr
{
    if(_firstPlayer==nil) {
        _firstPlayer=usr;
        return YES;
    }
    else if(_secondPlayer==nil) {
        _secondPlayer=usr;
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - Parse interface

-(id)initWithPFObject:(PFObject *)game
{
    if (self=[super init]) {
        _game=game;
        _rows=[_game[@"rows"] intValue];
        _cols=[_game[@"cols"] intValue];
        _gameSteps=_game[@"gameSteps"];
        if(_game[@"firstPlayer"]!=[NSNull null])
            _firstPlayer=_game[@"firstPlayer"];
        else
            _firstPlayer=nil;
        if(_game[@"secondPlayer"]!=[NSNull null])
            _secondPlayer=_game[@"secondPlayer"];
        else
            _secondPlayer=nil;
        
        _nowTurn=[_game[@"nowTurn"] intValue];
        _ifEnd=[_game[@"ifEnd"] boolValue];
        _winner=[_game[@"winner"] intValue];
        _gameMatrix=[NSMutableArray array];
        _creator=_game[@"creator"];
        for (int r=0; r<_rows; r++) {
            NSMutableArray *row=[NSMutableArray array];
            for (int c=0; c<_cols; c++) {
                [row addObject:[NSNumber numberWithInt:-1]];
            }
            [_gameMatrix addObject:row];
        }
        _lastIndexsInEachColum=[NSMutableArray array];
        for (int c=0; c<_cols; c++) {
            [_lastIndexsInEachColum addObject:[NSNumber numberWithInt:-1]];
        }
        int turn=1;
        for (int i=0; i<[_gameSteps count]; i++) {
            int column=[[_gameSteps objectAtIndex:i] intValue];
            int lastIndex=[[_lastIndexsInEachColum objectAtIndex:column] intValue];
            if(lastIndex>=([_game[@"rows"] intValue]-1)) {
                NSLog(@"in initWithPFObject in Game: this should not happened!");
                return nil;
            }
            int newLastIndex=lastIndex+1;
            [[_gameMatrix objectAtIndex:newLastIndex] replaceObjectAtIndex:column withObject:[NSNumber numberWithInt:turn]];
            [_lastIndexsInEachColum replaceObjectAtIndex:column withObject:[NSNumber numberWithInt:newLastIndex]];
            turn=3-turn;
        }
    }
    return self;
}

-(void)saveInBackgroundWithBlock:(void(^)(BOOL succeeded, NSError *error))block
{
    _game[@"rows"]=[NSNumber numberWithInt:_rows];
    _game[@"cols"]=[NSNumber numberWithInt:_cols];
    _game[@"nowTurn"]=[NSNumber numberWithInt:_nowTurn];
    _game[@"ifEnd"]=[NSNumber numberWithBool:_ifEnd];
    _game[@"winner"]=[NSNumber numberWithInt:_winner];
    _game[@"gameSteps"]=_gameSteps;
    _game[@"creator"]=_creator;
    if(_firstPlayer!=nil)
        _game[@"firstPlayer"]=_firstPlayer;
    else
        _game[@"firstPlayer"]=[NSNull null];
    if(_secondPlayer!=nil)
        _game[@"secondPlayer"]=_secondPlayer;
    else
        _game[@"secondPlayer"]=[NSNull null];
    PFUser *nowTurnPlayer=[self player:_nowTurn];
    if(nowTurnPlayer!=nil)
        _game[@"nowTurnPlayer"]=nowTurnPlayer;
    else
        _game[@"nowTurnPlayer"]=[NSNull null];
    [_game saveInBackgroundWithBlock:block];
}


@end

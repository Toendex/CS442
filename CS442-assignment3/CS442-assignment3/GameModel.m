//
//  GameModel.m
//  CS442-assignment3
//
//  Created by T on 5/7/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel {
    NSInteger _rows;
    NSInteger _cols;
    NSMutableArray *_gameMatrix;     //0=no;1=first_player;2=second_player
    NSMutableArray *_lastIndexsInEachColum;
    int _turn;                       //1=first_player;2=second_player;
    BOOL _ifEnd;
    int _winner;
}

-(id)initWithRows:(NSInteger)rows cols:(NSInteger)cols
{
    if (self=[super init]) {
        _rows=rows;
        _cols=cols;
        _turn=1;
        _winner=-1;
        _gameMatrix=[NSMutableArray array];
        _lastIndexsInEachColum=[NSMutableArray array];
        for (int r=0; r<_rows; r++) {
            NSMutableArray *row=[NSMutableArray array];
            for (int c=0; c<_cols; c++) {
                [row addObject:[NSNumber numberWithInt:-1]];
            }
            [_gameMatrix addObject:row];
        }
        for (int c=0; c<_cols; c++) {
            [_lastIndexsInEachColum addObject:[NSNumber numberWithInt:-1]];
        }
        _ifEnd=NO;
    }
    return self;
}

-(int)addPieceToColumn:(NSUInteger)column
{
    assert(column>=0 && column<_cols);
    NSNumber *lastIndex=[_lastIndexsInEachColum objectAtIndex:column];
    if(_ifEnd || [lastIndex intValue]>=(_rows-1)) {
        return -1;
    }
    NSNumber *newLastIndex=[NSNumber numberWithInt:([lastIndex intValue]+1)];
    [[_gameMatrix objectAtIndex:[newLastIndex unsignedIntegerValue]] replaceObjectAtIndex:column withObject:[NSNumber numberWithInt:_turn]];
    [_lastIndexsInEachColum replaceObjectAtIndex:column withObject:newLastIndex];
    _ifEnd=[self ifCauseEndAtRow:[newLastIndex unsignedIntegerValue] column:column];
    if(_ifEnd)
        _winner=_turn;
    else {
        _ifEnd=[self ifFull];
        if(_ifEnd)
            _winner=-1;
    }
    _turn=(3-_turn);
    return [newLastIndex intValue];
}

-(BOOL)ifFull
{
    for (int r=0; r<_rows; r++) for (int c=0; c<_cols; c++) {
        if ([[[_gameMatrix objectAtIndex:r]objectAtIndex:c] intValue]!=1 &&
            [[[_gameMatrix objectAtIndex:r]objectAtIndex:c] intValue]!=2)
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
    return _turn;
}

-(int)winner
{
    return _winner;
}

-(void)reset
{
    _turn=1;
    _winner=-1;
    for (int r=0; r<_rows; r++) {
        for (int c=0; c<_cols; c++) {
            [[_gameMatrix objectAtIndex:r] replaceObjectAtIndex:c withObject:[NSNumber numberWithInt:-1]];
        }
    }
    for (int c=0; c<_cols; c++) {
        [_lastIndexsInEachColum replaceObjectAtIndex:c withObject:[NSNumber numberWithInt:-1]];
    }
    _ifEnd=NO;
}

-(BOOL)ifAvaliableAtColumn:(NSUInteger)column
{
    NSNumber *lastIndex=[_lastIndexsInEachColum objectAtIndex:column];
    if([lastIndex intValue]>=(_rows-1)) {
        return NO;
    }
    return YES;
}

-(NSMutableArray *)avaliableColumns
{
    NSMutableArray *avaliableColumns=[NSMutableArray array];
    for (int c=0; c<_cols; c++) {
        if([self ifAvaliableAtColumn:c]) {
            [avaliableColumns addObject:[NSNumber numberWithInt:c]];
        }
    }
    return avaliableColumns;
}

@end

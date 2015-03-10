//
//  GameView.m
//  CS442-assignment3
//
//  Created by T on 5/7/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "ConnectFourView.h"

@implementation ConnectFourView {
    BoardView *_boardView;
    NSMutableArray *_pieceViews;
    NSInteger _rows;
    NSInteger _cols;
    CGFloat _slotDiameter;
    NSMutableArray *_gestureRecognizeViews;
}

- (id)initWithFrame:(CGRect)frame rows:(NSInteger)rows cols:(NSInteger)cols slotDiameter:(CGFloat)diameter boardImagePath:(NSString *)boardImagePath
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _ifAnimating=NO;
        _rows=rows;
        _cols=cols;
        _slotDiameter=diameter;
        _pieceViews=[NSMutableArray array];
        _gestureRecognizeViews=[NSMutableArray array];
        _boardView=[[BoardView alloc]initWithFrame:self.bounds rows:_rows cols:_cols slotDiameter:_slotDiameter imagePath:boardImagePath];
        self.backgroundColor=[UIColor blackColor];
        [self addSubview:_boardView];
        [self addGestureRecognizeViews];
    }
    return self;
}

-(void)addGestureRecognizeViews
{
    CGFloat width=self.bounds.size.width/(_cols+1);
    CGFloat height=self.bounds.size.height;
    for (int c=1; c<=_cols; c++) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(width*c-_slotDiameter/2.0, 0,
                                                            _slotDiameter, height)];
        view.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(columnTapped:)];
        tap.numberOfTouchesRequired=1;
        tap.numberOfTapsRequired=1;
        [view addGestureRecognizer:tap];
        [self addSubview:view];
        [_gestureRecognizeViews addObject:view];
    }
}

-(void)columnTapped:(UIGestureRecognizer *)gestureRecognizer
{
    if(_ifAnimating)
        return;
    NSUInteger index=[_gestureRecognizeViews indexOfObject:[gestureRecognizer view]];
    [self.delegate columnTapped:index];
}

- (void)addToColumn:(NSUInteger)column row:(NSUInteger)row withImagePath:(NSString *)imagePath
{
    CGFloat width=self.bounds.size.width/(_cols+1);
    CGFloat height=self.bounds.size.height/(_rows+1);
    PieceView *piece=[[PieceView alloc] initWithFrame:CGRectMake((column+1)*width-_slotDiameter/2.0, -_slotDiameter,
                                                                 _slotDiameter, _slotDiameter) imagePath:imagePath];
    [_pieceViews addObject:piece];
    [self insertSubview:piece belowSubview:_boardView];
    _ifAnimating=YES;
    [UIView animateWithDuration:0.6 animations:^{
            piece.center=CGPointMake((column+1)*width, (_rows-row)*height);
        } completion:^(BOOL finished) {
            _ifAnimating=NO;
            [self.delegate didEndMove];
    }];
}

-(void)reset
{
    _ifAnimating=NO;
    for(PieceView *piece in _pieceViews) {
        [piece removeFromSuperview];
    }
    [_pieceViews removeAllObjects];
}

//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef context=UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
//    CGContextAddRect(context, self.bounds);
//    CGContextFillPath(context);
////    CGContextDrawImage(context, self.bounds, [UIImage imageNamed:@"black_background.jpg"].CGImage);
//    CGContextRestoreGState(context);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

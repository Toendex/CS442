//
//  ImageViewController.m
//  CS442-final
//
//  Created by T on 4/1/14.
//  Copyright (c) 2014 T. All rights reserved.
//

#import "ImageViewController.h"
#import "GrayView.h"
#import "ScrollView.h"
#import "ImageView.h"

@interface ImageViewController ()

@end

@implementation ImageViewController {
    ImageView *imageView;
    ScrollView *scrollView;
    GrayView *grayVIew;
    UIInterfaceOrientation orientation;
    CGPoint commentCoordinate;
    CommentModel *commentModel;
    NSMutableArray *commentViews;
    CoordinateConverter *coordinateConverter;
    NSInteger numOfCommentsEachTime;
    NSInteger currentPage;
    UITextView *textView;
    NSMutableArray *nums;
    UITableView *numTableView;
    int currentImgIndex;
    BOOL ifNeedResetWhenViewWillAppear;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    numOfCommentsEachTime=3;
    currentPage=-1;
    currentImgIndex=0;
    
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    self.navigationController.navigationBar.hidden=YES;
    
    NSArray *imageArray=self.post.imgs;
    UIImage *image=[imageArray objectAtIndex:currentImgIndex];
    scrollView=[[ScrollView alloc] initWithFrame:self.view.bounds];
    imageView=[[ImageView alloc] initWithFrame:scrollView.frame];
    [imageView setImage:image];
    scrollView.userInteractionEnabled=YES;
    imageView.userInteractionEnabled=YES;
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [scrollView addSubview:imageView];
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 50.0;
    [self.view addSubview:scrollView];
    orientation = [UIApplication sharedApplication].statusBarOrientation;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note){
                                                      CGRect b=self.view.bounds;
                                                      UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
                                                      if(o==orientation)
                                                          return;
                                                      orientation=o;
                                                      if([scrollView zoomScale]!=1.0) {
//                                                          NSLog(@"%f,%f",imageView.frame.size.width, imageView.frame.size.height);
                                                          [scrollView zoomToRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) animated:YES];
                                                      }
                                                      [self resetScreenOffset];
                                                  }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapBegin:)];
    [scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapBegin)];
    [doubleTap setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *doubleFingerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleFingerTapBegin)];
    [doubleFingerTap setNumberOfTouchesRequired:2];
    [imageView addGestureRecognizer:doubleFingerTap];
    
    UISwipeGestureRecognizer *swipeToNextImg = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToNextImg)];
    swipeToNextImg.numberOfTouchesRequired=1;
    swipeToNextImg.direction=UISwipeGestureRecognizerDirectionLeft;
    swipeToNextImg.delegate=scrollView;
    [imageView addGestureRecognizer:swipeToNextImg];
    
    UISwipeGestureRecognizer *swipeToPreviousImg = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToPreviousImg)];
    swipeToPreviousImg.numberOfTouchesRequired=1;
    swipeToPreviousImg.direction=UISwipeGestureRecognizerDirectionRight;
    swipeToPreviousImg.delegate=scrollView;
    [imageView addGestureRecognizer:swipeToPreviousImg];
    
    UIPanGestureRecognizer *doubleFingerPan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(doubleFingerPan)];
    doubleFingerPan.minimumNumberOfTouches=2;
    doubleFingerPan.maximumNumberOfTouches=2;
    [scrollView addGestureRecognizer:doubleFingerPan];
    
    UISwipeGestureRecognizer *doubleFingerSwipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(commentPageUp)];
    doubleFingerSwipeUp.numberOfTouchesRequired=2;
    doubleFingerSwipeUp.direction=UISwipeGestureRecognizerDirectionUp;
    doubleFingerSwipeUp.delegate=scrollView;
    [scrollView addGestureRecognizer:doubleFingerSwipeUp];
    
    UISwipeGestureRecognizer *doubleFingerSwipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(commentPageDown)];
    doubleFingerSwipeDown.numberOfTouchesRequired=2;
    doubleFingerSwipeDown.direction=UISwipeGestureRecognizerDirectionDown;
    doubleFingerSwipeDown.delegate=scrollView;
    [scrollView addGestureRecognizer:doubleFingerSwipeDown];
    
    coordinateConverter=[[CoordinateConverter alloc] init];
    coordinateConverter.delegate=self;
    
    commentViews=[NSMutableArray array];
    commentModel=[[CommentModel alloc] initWithPostID:self.post.ID];
    [commentModel readComments];
    [self generateCommentViewsWithImgIndex:currentImgIndex];
    [self pageCommentViewsInSequence:YES withHidden:YES];
    
    self.navigationItem.title=[NSString stringWithFormat:@"%d / %d",currentImgIndex+1,self.post.imageCount];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    NSString *title=self.post.title;
    if([title isEqualToString:@""])
        title=@"--  < No Title >  --";
    NSString *contentText=self.post.contentText;
    if([contentText isEqualToString:@""])
        contentText=@"--  < No Content >  --";
    textView.text=[NSString stringWithFormat:@"Title:\n\t%@\n\nContent:\n\t%@\n\n\n\t-- By  %@   -- At  %@", title, contentText, @"Anonymous", [dateFormatter stringFromDate:self.post.date]];
    textView.backgroundColor=[UIColor whiteColor];
    textView.editable=NO;
    textView.hidden=YES;
    textView.alpha=0;
    [self.view addSubview:textView];
    
    nums=[NSMutableArray array];
    for (int i=50; i>0; i--) {
        [nums addObject:[NSNumber numberWithInt:i]];
    }
    numTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    numTableView.delegate=self;
    numTableView.dataSource=self;
    [numTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NumCell"];
    numTableView.hidden=YES;
    numTableView.alpha=0;
    [self.view addSubview:numTableView];
    
    ifNeedResetWhenViewWillAppear=YES;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    CGRect b=self.view.bounds;
//    NSLog(@"%f, %f, %f, %f",b.size.height, b.size.width, b.origin.x, b.origin.y);
//    scrollView.bounds=self.view.bounds;
//    imageView.bounds=self.view.bounds;
//}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.navigationController.navigationBarHidden==YES)
        [self.navigationController setToolbarHidden:YES];
    else
        [self.navigationController setToolbarHidden:NO];
    if (ifNeedResetWhenViewWillAppear) {
        [self resetScreenOffset];
        ifNeedResetWhenViewWillAppear=NO;
    }
    [numTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:([nums count]-numOfCommentsEachTime) inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

-(void)resetScreenOffset
{
    scrollView.frame=self.view.frame;
    imageView.frame=self.view.frame;
    scrollView.bounds=self.view.bounds;
    imageView.bounds=self.view.bounds;
    CGFloat toolBarHeight=self.navigationController.toolbar.bounds.size.height;
    CGFloat textViewHeight=150;
    [textView setFrame:CGRectMake(0, self.view.bounds.size.height-textViewHeight-toolBarHeight, self.view.bounds.size.width, textViewHeight)];
    CGFloat numTableViewHeight=200;
    CGFloat numTableViewWidth=60;
    [numTableView setFrame:CGRectMake(self.view.bounds.size.width-numTableViewWidth, self.view.bounds.size.height-numTableViewHeight-toolBarHeight, numTableViewWidth, numTableViewHeight)];
    CGPoint offset=[scrollView contentOffset];
    for(CommentView *commentView in commentViews) {
        //        CGRect frame=commentView.frame;
        //        frame.origin.x=offset.x;
        //        frame.origin.y=offset.y;
        //        [commentView setFrame:frame];
        [commentView refreshFrameOriginWithScale:scrollView.zoomScale offset:scrollView.contentOffset];
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)generateCommentViewsWithImgIndex:(int)imgIndex
{
    CGSize screenSize=[[UIScreen mainScreen] bounds].size;
    for(CommentView *commentView in commentViews)
        [commentView removeFromSuperview];
    [commentViews removeAllObjects];
    for(Comment *comment in commentModel.comments) {
        if([comment.indexOfImg intValue]!=imgIndex)
            continue;
        CommentView *ctv=[[CommentView alloc] initWithComment:comment frame:scrollView.frame coordinateConverter:coordinateConverter fontSize:14 maxWidth:140 maxHeight:100 screenSize:screenSize/*scale:scrollView.zoomScale*/];
        [commentViews addObject:ctv];
    }
}

-(void)pageCommentViewsInSequence:(BOOL)ifInSequence withHidden:(BOOL)ifHidden
{
    int maxPage=(int)ceil([commentViews count]/(double)numOfCommentsEachTime);
    if(ifInSequence) {
        if(currentPage>=maxPage-1)
            return;
        currentPage++;
    }
    else {
        
        if(currentPage<=0)
            return;
        currentPage--;
    }
    NSMutableArray *oldCommentViews=[NSMutableArray array];
    for (id view in [scrollView subviews])
        if([view isKindOfClass:[CommentView class]])
            [oldCommentViews addObject:view];
    int maxI=[commentViews count]-numOfCommentsEachTime*currentPage;
    maxI=(maxI>numOfCommentsEachTime)?numOfCommentsEachTime:maxI;
    NSMutableArray *newCommentViews=[NSMutableArray array];
    for (int i=0; i<maxI; i++) {
        CommentView *ctv=[commentViews objectAtIndex:currentPage*numOfCommentsEachTime+i];
        [scrollView addSubview:ctv];
        [ctv setHidden:ifHidden];
        ctv.alpha=0;
        [newCommentViews addObject:ctv];
    }
    [UIView animateWithDuration:1.0 animations:^{
            for(CommentView *commentView in oldCommentViews) {
                CGRect frame=commentView.frame;
                if(ifInSequence)
                    frame.origin.y=frame.origin.y-[[UIScreen mainScreen] bounds].size.height;
                else
                    frame.origin.y=frame.origin.y+[[UIScreen mainScreen] bounds].size.height;
                commentView.frame=frame;
            }

        } completion:^(BOOL finished) {
            for(CommentView *commentView in oldCommentViews) {
                [commentView removeFromSuperview];
                CGRect frame=commentView.frame;
                if(ifInSequence)
                    frame.origin.y=frame.origin.y+[[UIScreen mainScreen] bounds].size.height;
                else
                    frame.origin.y=frame.origin.y-[[UIScreen mainScreen] bounds].size.height;
                commentView.frame=frame;
            }
    }];
    [UIView animateWithDuration:0.7 delay:0.3 options:UIViewAnimationOptionCurveLinear  animations:^{
            for(CommentView *commentView in newCommentViews) {
                commentView.alpha=1;
            }
        } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GestureRecognizer call-backs

-(void)doubleTapBegin
{
//    if([scrollView zoomScale]==1)
//        return;
//    NSLog(@"%f, %f",imageView.frame.size.width,imageView.frame.size.height);
//    [scrollView zoomToRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) animated:YES];
}

-(void)doubleFingerTapBegin
{
    //    CGFloat xcenter = imageView.center.x;
    //    CGFloat ycenter = imageView.center.y;
    //    [scrollView scrollRectToVisible:CGRectMake(xcenter-scrollView.frame.size.width/2, ycenter-scrollView.frame.size.height/2, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
    CGRect frame=imageView.frame;
    CGRect bounds=imageView.bounds;
    if( self.navigationController.navigationBar.hidden==YES) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [self.navigationController setToolbarHidden:NO animated:YES];
        //        self.navigationController.navigationBar.hidden=NO;
    }
    else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [self.navigationController setToolbarHidden:YES animated:YES];
        textView.hidden=YES;
        textView.alpha=0;
        numTableView.hidden=YES;
        numTableView.alpha=0;
        //        self.navigationController.navigationBar.hidden=YES;
    }
    imageView.frame=frame;
    imageView.bounds=bounds;
}

-(void)singleTapBegin:(UITapGestureRecognizer *)sender
{
//    NSLog(@"test!");
    if([self commentsHidden] || currentPage==-1 || ((NSInteger)[commentViews count])==0)
        return;
    int maxPage=(int)ceil([commentViews count]/(double)numOfCommentsEachTime);
    NSMutableArray *oldCommentViews=[NSMutableArray array];
    int maxI=[commentViews count]-numOfCommentsEachTime*currentPage;
    maxI=(maxI>numOfCommentsEachTime)?numOfCommentsEachTime:maxI;
    for (int i=maxI-1; i>-1; i--) {
        CommentView *ctv=[commentViews objectAtIndex:currentPage*numOfCommentsEachTime+i];
        CGPoint pt=[sender locationInView:ctv];
        if([ctv inSpeechBubbleRect:pt]) {
//            NSLog(@"YES!");
            [ctv removeFromSuperview];
            [scrollView addSubview:ctv];
            [ctv setNeedsDisplay];
        }
    }
}

-(void)doubleFingerPan
{
//    NSLog(@"Pan2!");
}

-(void)commentPageUp
{
    if([self commentsHidden])
        return;
//    NSLog(@"UP");
    [self pageCommentViewsInSequence:YES withHidden:NO];
}

-(void)commentPageDown
{
    if([self commentsHidden])
        return;
//    NSLog(@"DOWN");
    [self pageCommentViewsInSequence:NO withHidden:NO];
}

-(void)swipeToNextImg
{
    if(currentImgIndex >= [self.post imageCount]-1)
        return;
    currentImgIndex++;
    UIImage *image=[self.post.imgs objectAtIndex:currentImgIndex];
    [imageView setImage:image];
//    NSLog(@"%f,%f",imageView.frame.size.width, imageView.frame.size.height);
    if(scrollView.zoomScale!=1.0)
        [scrollView zoomToRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) animated:NO];
    currentPage=-1;
    [self generateCommentViewsWithImgIndex:currentImgIndex];
    [self pageCommentViewsInSequence:YES withHidden:[self commentsHidden]];
    self.navigationItem.title=[NSString stringWithFormat:@"%d / %d",currentImgIndex+1,self.post.imageCount];
}

-(void)swipeToPreviousImg
{
    if(currentImgIndex <= 0)
        return;
    currentImgIndex--;
    UIImage *image=[self.post.imgs objectAtIndex:currentImgIndex];
    [imageView setImage:image];
//    NSLog(@"%f,%f",imageView.frame.size.width, imageView.frame.size.height);
    if(scrollView.zoomScale!=1.0)
        [scrollView zoomToRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) animated:NO];
    currentPage=-1;
    [self generateCommentViewsWithImgIndex:currentImgIndex];
    [self pageCommentViewsInSequence:YES withHidden:[self commentsHidden]];
    self.navigationItem.title=[NSString stringWithFormat:@"%d / %d",currentImgIndex+1,self.post.imageCount];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UIScrollViewDelegate

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // return which subview we want to zoom
    return imageView;
}

//-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
//{
//    for(CommentView *commentView in commentViews) {
//        [commentView setZoomScale:scale];
//        [commentView refreshRealPoint];
//        [commentView setNeedsDisplay];
//    }
//}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    for(CommentView *commentView in commentViews) {
//        CGRect frame=commentView.frame;
//        frame.origin.x=offset.x;
//        frame.origin.y=offset.y;
//        [commentView setFrame:frame];
        [commentView refreshFrameOriginWithScale:scrollView.zoomScale offset:scrollView.contentOffset];

    }
}

//-(void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
//
//    
//    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? \
//    
//    scrollView.contentSize.width/2 : xcenter;
//    
//    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? \
//    
//    scrollView.contentSize.height/2 : ycenter;
//    
//    [imageView setCenter:CGPointMake(xcenter, ycenter)];
//}


//-(void) selectLocation:(UITapGestureRecognizer *)sender {
//    NSLog(@"~!");
//}

- (IBAction)startAddComment:(id)sender {
    if(grayVIew) {
        [grayVIew removeFromSuperview];
        grayVIew=nil;
        self.navigationBarLeftButtom.title=@"Comment";
        return;
    }
    grayVIew=[[GrayView alloc] initWithFrame:self.view.bounds converter:coordinateConverter];
    grayVIew.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.35];
    grayVIew.delegate=self;
    [self.view addSubview:grayVIew];
    self.navigationBarLeftButtom.title=@"Cancel";
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectLocation:)];
//    [grayVIew addGestureRecognizer:singleTap];
}

- (IBAction)hideShowText:(id)sender {
    if(textView.hidden==YES) {
        [UIView animateWithDuration:0.5 animations:^{
            textView.hidden=NO;
            textView.alpha=1;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            textView.alpha=0;
        } completion:^(BOOL finished) {
            textView.hidden=YES;
        }];
    }
}

- (IBAction)hideShowComments:(id)sender {
    if([self.hideShowButton.title isEqual:@"Show"]) {
        for(CommentView *ctv in commentViews)
            [ctv setHidden:NO];
        self.hideShowButton.title=@"Hide";
    }
    else {
        for(CommentView *ctv in commentViews)
            [ctv setHidden:YES];
        self.hideShowButton.title=@"Show";
    }
}

- (IBAction)hideShowCommentNumSelection:(id)sender {
    if(numTableView.hidden==YES) {
        [UIView animateWithDuration:0.5 animations:^{
            numTableView.hidden=NO;
            numTableView.alpha=1;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            numTableView.alpha=0;
        } completion:^(BOOL finished) {
            numTableView.hidden=YES;
        }];
    }
}

-(BOOL)commentsHidden
{
    if ([self.hideShowButton.title isEqual:@"Show"])
        return YES;
    return NO;
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toEditComment"])
    {
//        NSLog(@"done");
        AddCommentViewController *avc=segue.destinationViewController;
        avc.post=self.post;
        avc.coordinate=commentCoordinate;
        avc.indexOfImg=[NSNumber numberWithInt:currentImgIndex];
    }
}

#pragma mark - GrayViewDelegate / CoordinateConverterDelegate

-(UIImageView *)getImageView
{
    return imageView;
}

-(UIScrollView *)getScrollView
{
    return scrollView;
}

-(void)locateAtImgPoint:(CGPoint)imgPoint
{
    [grayVIew removeFromSuperview];
    grayVIew=nil;
    commentCoordinate=imgPoint;
    self.navigationBarLeftButtom.title=@"Comment";
    [self performSegueWithIdentifier:@"toEditComment" sender:self];
}

-(CGPoint)locateInImgView:(NSSet *)touches
{
    CGPoint imgViewPoint=[[touches anyObject] locationInView:imageView];
    return imgViewPoint;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSNumber *value=[nums objectAtIndex:indexPath.item];
    if ([value intValue]==numOfCommentsEachTime) {
        [cell setSelected:YES];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%d",[value intValue]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [nums count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 23;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int num=[[nums objectAtIndex:indexPath.item] intValue];
    [self resetNumOfCommentsEachTime:num];
}

-(void)resetNumOfCommentsEachTime:(NSInteger)num
{
    if(currentPage!=-1) {
        int beginIndex=currentPage*numOfCommentsEachTime;
        currentPage=-1+beginIndex/num;
    }
    numOfCommentsEachTime=num;
    BOOL ifHidden=[self commentsHidden];
    
    
    int maxPage=(int)ceil([commentViews count]/(double)numOfCommentsEachTime);
    if(currentPage>=maxPage-1)
            return;
    currentPage++;
    NSMutableArray *oldCommentViews=[NSMutableArray array];
    for (id view in [scrollView subviews])
        if([view isKindOfClass:[CommentView class]])
            [oldCommentViews addObject:view];
    int maxI=[commentViews count]-numOfCommentsEachTime*currentPage;
    maxI=(maxI>numOfCommentsEachTime)?numOfCommentsEachTime:maxI;
    NSMutableArray *newCommentViews=[NSMutableArray array];
    for (int i=0; i<maxI; i++) {
        CommentView *ctv=[commentViews objectAtIndex:currentPage*numOfCommentsEachTime+i];
        [ctv setHidden:ifHidden];
        if([oldCommentViews containsObject:ctv])
           [oldCommentViews removeObject:ctv];
        else {
            ctv.alpha=0;
            [newCommentViews addObject:ctv];
            [scrollView addSubview:ctv];
        }
    }
    [UIView animateWithDuration:1.0 animations:^{
            for(CommentView *commentView in oldCommentViews) {
                commentView.alpha=0;
            }
        } completion:^(BOOL finished) {
            for(CommentView *commentView in oldCommentViews) {
                [commentView removeFromSuperview];
            }
    }];
    [UIView animateWithDuration:1.0 animations:^{
            for(CommentView *commentView in newCommentViews) {
                commentView.alpha=1;
            }
        } completion:^(BOOL finished) {
        
    }];

}

@end
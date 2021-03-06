//
//  BoardViewController.m
//  Chess
//
//  Created by Liu Di on 6/27/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "BoardViewController.h"

@interface BoardViewController ()

@end

@implementation BoardViewController{
    HardBot *myBoard;

}
@synthesize dragObject;
@synthesize touchOffset;
@synthesize homePosition;
@synthesize backgroud;
@synthesize isMoved;
@synthesize paths;
@synthesize filePath;
@synthesize space1;
@synthesize space2;
@synthesize space3;
@synthesize space4;
@synthesize space5;
@synthesize space6;
@synthesize space7;
@synthesize space8;
@synthesize space9;
@synthesize space10;
@synthesize space11;
@synthesize space12;
@synthesize space13;
@synthesize space14;
@synthesize space15;
@synthesize space16;
@synthesize space17;
@synthesize space18;
@synthesize space19;
@synthesize space20;
@synthesize space21;
@synthesize space22;
@synthesize space23;
@synthesize space24;
@synthesize space25;
@synthesize space26;
@synthesize space27;
@synthesize space28;
@synthesize space29;
@synthesize space30;
@synthesize space31;
@synthesize space32;
//@synthesize myBoard;
@synthesize X, Y, isTouched;
@synthesize tempPiece;
@synthesize isTapped;

@synthesize rook;
@synthesize knight;
@synthesize bishop;
@synthesize king;
@synthesize queen;
@synthesize bishop2;
@synthesize kight2;
@synthesize rook2;
@synthesize pawn1;
@synthesize pawn2;
@synthesize pawn3;
@synthesize pawn4;
@synthesize pawn5;
@synthesize pawn6;
@synthesize pawn7;
@synthesize pawn8;

@synthesize brook;
@synthesize bknight;
@synthesize bbishop;
@synthesize bking;
@synthesize bqueen;
@synthesize bbishop2;
@synthesize bkight2;
@synthesize brook2;
@synthesize bpawn1;
@synthesize bpawn2;
@synthesize bpawn3;
@synthesize bpawn4;
@synthesize bpawn5;
@synthesize bpawn6;
@synthesize bpawn7;
@synthesize bpawn8;

@synthesize debuggingWindow;
@synthesize isDebug;
@synthesize debugInfo;
@synthesize drawPoint = _drawPoint;
@synthesize circleViews;
@synthesize availableMoves;
@synthesize isSet;
@synthesize confirmButton;
@synthesize mode1;
@synthesize isDetailPrinted;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setNeedsDisplay {
    
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTapGesture.numberOfTapsRequired = 1;
    [self.confirmButton addGestureRecognizer:singleTapGesture];
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self.view addSubview:confirmButton];
    //Debug window setup
//    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    // Hide keyboard, but show blinking cursor
//    debuggingWindow.inputView = dummyView;
    self.debuggingWindow.delegate = self;
    
    //Initialize circleViews
    circleViews = [[NSMutableArray alloc] init];
    
    
    //    UIView *mainView = view;
    //    CALayer *mainViewLayer = mainView.layer;
    //    [mainViewLayer addSublayer:dummyView.layer];
    //    [mainViewLayer addSublayer:v.layer];
    //    [mainViewLayer]
    //Basic Setup for board
    X = 0;
    Y = 0;
    isTouched = 0;
    isMoved = 0;
    isDebug = 0;
    isTapped = 0;
    availableMoves = 1;
    isDetailPrinted = 0;
    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"data.txt"];
    debugInfo = [[NSMutableString alloc] init];
    isSet = 0;
    [confirmButton setFrame:CGRectMake(80, 420, 150, 30)];
    [confirmButton addTarget:self
                      action:@selector(clickOnComfirm)
            forControlEvents:UIControlEventTouchDown];
    NSLog(@"mode is: %ld",(long)mode1);
//    if (mode1 == 1) {
//        NSLog(@"***In bot mode");
//        myBoard = [[EasyBot alloc] init];
//        [myBoard setMode:1];
//    }
//    else if (mode1 == 2) {
    if (mode1 == 1 || mode1 == 2) {
        myBoard = [[HardBot alloc] init];
    }
    else {
        myBoard = [[Board alloc] init];
        [myBoard setMode:0];
    }
    
    [myBoard setIsFirstCaller:1];
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"log.txt";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    [dateFormatter setDateFormat:@"hh:mm MM/YY"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    [myBoard setLogPath:fileAtPath];
    [[NSString stringWithFormat:@"Log recorded at:%@\n",resultString] writeToFile:[myBoard logPath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"the path for log file is at %@",[myBoard logPath]);
    
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:0] setImg:rook and:[NSMutableString stringWithString:@"rook"] and:1];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:0] setImg:knight and:[NSMutableString stringWithString:@"knight"] and:1];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:0] setImg:bishop and:[NSMutableString stringWithString:@"bishop"] and:1];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:0] setImg:king and:[NSMutableString stringWithString:@"king"] and:1];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:0] setImg:queen and:[NSMutableString stringWithString:@"queen"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:0] setImg:bishop2 and:[NSMutableString stringWithString:@"bishop2"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:0] setImg:kight2 and:[NSMutableString stringWithString:@"knight2"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:0] setImg:rook2 and:[NSMutableString stringWithString:@"rook2"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:1] setImg:pawn1 and:[NSMutableString stringWithString:@"pawn1"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:1] setImg:pawn2 and:[NSMutableString stringWithString:@"pawn2"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:1] setImg:pawn3 and:[NSMutableString stringWithString:@"pawn3"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:1] setImg:pawn4 and:[NSMutableString stringWithString:@"pawn4"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:1] setImg:pawn5 and:[NSMutableString stringWithString:@"pawn5"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:1] setImg:pawn6 and:[NSMutableString stringWithString:@"pawn6"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:1] setImg:pawn7 and:[NSMutableString stringWithString:@"pawn7"]and:1];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:1] setImg:pawn8 and:[NSMutableString stringWithString:@"pawn8"]and:1];
    
    
    
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:7] setImg:brook and:[NSMutableString stringWithString:@"brook"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:7] setImg:bknight and:[NSMutableString stringWithString:@"bknight"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:7] setImg:bbishop and:[NSMutableString stringWithString:@"bbishop"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:7] setImg:bking and:[NSMutableString stringWithString:@"bking"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:7] setImg:bqueen and:[NSMutableString stringWithString:@"bqueen"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:7] setImg:bbishop2 and:[NSMutableString stringWithString:@"bbishop2"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:7] setImg:bkight2 and:[NSMutableString stringWithString:@"bknight2"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:7] setImg:brook2 and:[NSMutableString stringWithString:@"brook2"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:6] setImg:bpawn1 and:[NSMutableString stringWithString:@"bpawn1"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:6] setImg:bpawn2 and:[NSMutableString stringWithString:@"bpawn2"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:6] setImg:bpawn3 and:[NSMutableString stringWithString:@"bpawn3"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:6] setImg:bpawn4 and:[NSMutableString stringWithString:@"bpawn4"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:6] setImg:bpawn5 and:[NSMutableString stringWithString:@"bpawn5"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:6] setImg:bpawn6 and:[NSMutableString stringWithString:@"bpawn6"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:6] setImg:bpawn7 and:[NSMutableString stringWithString:@"bpawn7"]and:2];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:6] setImg:bpawn8 and:[NSMutableString stringWithString:@"bpawn8"]and:2];
    
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:2] setImg:space1 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:2] setImg:space2 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:2] setImg:space3 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:2] setImg:space4 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:2] setImg:space5 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:2] setImg:space6 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:2] setImg:space7 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:2] setImg:space8 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:3] setImg:space9 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:3] setImg:space10 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:3] setImg:space11 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:3] setImg:space12 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:3] setImg:space13 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:3] setImg:space14 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:3] setImg:space15 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:3] setImg:space16 and:[NSMutableString stringWithString:@"empty"]and:0];
    
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:4] setImg:space17 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:4] setImg:space18 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:4] setImg:space19 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:4] setImg:space20 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:4] setImg:space21 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:4] setImg:space22 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:4] setImg:space23 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:4] setImg:space24 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:0] objectAtIndex:5] setImg:space25 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:1] objectAtIndex:5] setImg:space26 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:2] objectAtIndex:5] setImg:space27 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:3] objectAtIndex:5] setImg:space28 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:4] objectAtIndex:5] setImg:space29 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:5] objectAtIndex:5] setImg:space30 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:6] objectAtIndex:5] setImg:space31 and:[NSMutableString stringWithString:@"empty"]and:0];
    [[[[myBoard getPieceSet] objectAtIndex:7] objectAtIndex:5] setImg:space32 and:[NSMutableString stringWithString:@"empty"]and:0];
    
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
+(void)resize:(UIView*)view to:(CGSize)size withDuration:(int) duration andSnapBack:(BOOL) snapBack
{
    // Prepare the animation from the old size to the new size
    CGRect oldBounds = view.layer.bounds;
    CGRect newBounds = oldBounds;
    newBounds.size = size;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    
    // iOS
    animation.fromValue = [NSValue valueWithCGRect:oldBounds];
    animation.toValue = [NSValue valueWithCGRect:newBounds];
    
    
    if(!snapBack)
    {
        // Update the layer’s bounds so the layer doesn’t snap back when the animation completes.
        view.layer.bounds = newBounds;
    }
    
    // Add the animation, overriding the implicit animation.
    [view.layer addAnimation:animation forKey:@"bounds"];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (Piece *)getMove:(UIImageView *) iView{
    //NSLog(@"in viewcontroller get move");
    for(NSMutableArray *v in [myBoard getPieceSet]) {
        for(Piece *p in v) {
            if([[p getImage] isEqual:iView]){
                //NSLog(@"found one");
                //NSLog(@"%d  %d",[p getX],[p getY]);
                return p;
            }
        }
    }
    //NSLog(@"error cant find the piece");
    return nil;
}
- (void)setMyPoint:(CGPoint)myPoint
{
    _drawPoint = myPoint;
    [self setNeedsDisplay];
}

- (NSInteger)getTagFromPiece:(Piece *) temp{
    int tempX = [temp getX];
    int tempY = [temp getY]; /* Assuming this is initalized to the second number */
    int tempTag = [[NSString stringWithFormat:@"%d%d",tempX, tempY] intValue];
    return tempTag;
}

- (void)isMoveDrawn:(Piece *) temp {
    NSInteger tag = [self getTagFromPiece:temp];
    for (DrawCircles *i in circleViews) {
        if (i.tag == tag) {
            NSLog(@"removing object from array");
            [i removeFromSuperview];
            [circleViews removeObject:i];
            return;
        }
    }
    CGRect frame = [UIScreen mainScreen].bounds;
    DrawCircles *drawView = [[DrawCircles alloc] initWithFrame:frame];
    drawView.tag = [self getTagFromPiece:temp];
    
    [circleViews addObject:drawView];
    drawView.userInteractionEnabled = NO;
    [self.view addSubview:drawView];
    [self.view bringSubviewToFront:drawView];
    [self showAvailableMoves:temp onView:drawView];
    return;
}
- (void)handleSingleTapGesture:(UITapGestureRecognizer *)singleTapGesture{
    //    NSLog(@"handleSingleTap triggered");
    //[confirmButton imageView].image = [UIImage imageNamed:@"brook.png"];
    
    CGPoint tapPoint = [singleTapGesture locationInView:self.confirmButton];
    if (tapPoint.x > confirmButton.frame.origin.x &&
        tapPoint.x < confirmButton.frame.origin.x + confirmButton.frame.size.width &&
        tapPoint.y > confirmButton.frame.origin.y &&
        tapPoint.y < confirmButton.frame.origin.y + confirmButton.frame.size.height) {
        NSLog(@"$$$$$$$settingAlpha");
        //[confirmButton setAlpha:0.7];
        [self clickOnComfirm];
    }
    
}
- (void)handleDoubleTap: (UITapGestureRecognizer *)doubleTapGesture{
    if (doubleTapGesture.state == UIGestureRecognizerStateRecognized) {
        CGPoint tapPoint = [doubleTapGesture locationInView:self.view];
        for (UIImageView *iView in self.view.subviews) {
            //can result serious problems because it returns nil when a piece is not found
            Piece *temp = [self getMove:iView];
            if (temp != nil && [iView isMemberOfClass:[UIImageView class]] && iView != backgroud && (![[temp getName] isEqualToString:[NSMutableString stringWithFormat:@"empty"]])) {
                if (tapPoint.x > iView.frame.origin.x &&
                    tapPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                    tapPoint.y > iView.frame.origin.y &&
                    tapPoint.y < iView.frame.origin.y + iView.frame.size.height)
                {
                    NSLog(@"tap object recognized!");
                    [self isMoveDrawn:temp];
                }
            }
        }
        
        
    }
}


- (void)showAvailableMoves: (Piece *)pi onView:(DrawCircles *)drawView{
    NSLog(@"in show availabie moves %@ requiring ava moves", [pi getName]);
    for (NSMutableArray *i in [myBoard getPieceSet]) {
        for (Piece *t in i) {
            if ([t getSide] != [pi getSide]) {
                NSLog(@"#1%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                if ([myBoard validateMove:pi to:t]) {
                    NSLog(@"#2%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                    CGPoint pt = CGPointMake([[t getImage] center].x, [[t getImage] center].y);
                    //CGPoint pt = CGPointMake([t getImage].frame.origin.x, [t getImage].frame.origin.y);
                    
                    [drawView drawOnSpot:pt withSide:[pi getSide]];
                    
                }
            }
        }
    }
    return ;
}
- (void)touchesBegan: (NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        
        for (UIImageView *iView in self.view.subviews) {
            //can result serious problems because it returns nil when a piece is not found
            Piece *temp = [self getMove:iView];
            //if ([iView isMemberOfClass:[UIImageView class]] && iView != backgroud && ![iView.image isEqual:[UIImage imageNamed:@"empty.png"]] && ([myBoard terms] == [temp getSide] || isDebug == 1))
            if ([iView isMemberOfClass:[UIImageView class]] && iView != backgroud && (![[temp getName] isEqualToString:[NSMutableString stringWithFormat:@"empty"]]) && ([myBoard terms] == [temp getSide] || isDebug == 1)) {
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height)
                {
                    NSLog(@"touched!");
                    isTouched = 1;
                    tempPiece = [self getMove:iView];
                    X = [tempPiece getX];
                    Y = [tempPiece getY];
                    self.dragObject = iView;
                    self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
                                                   touchPoint.y - iView.frame.origin.y);
                    self.homePosition = CGPointMake(iView.frame.origin.x,
                                                    iView.frame.origin.y);
                    [self.view bringSubviewToFront:self.dragObject];
                    
                }
            }
        }
    }
    //    if ([touches count] == 2) {
    //        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    //
    //        for (UIImageView *iView in self.view.subviews) {
    //            Piece *temp = [self getMove:iView];
    //            if ([iView isMemberOfClass:[UIImageView class]] && iView != backgroud && (![[temp getName] isEqualToString:[NSMutableString stringWithFormat:@"empty"]]) && ([myBoard terms] == [temp getSide] || isDebug == 1)) {
    //                if (touchPoint.x > iView.frame.origin.x &&
    //                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
    //                    touchPoint.y > iView.frame.origin.y &&
    //                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height) {
    //                    [self showAvailableMoves:temp];
    //
    //                }
    //
    //            }
    //        }
    //    }
    
    
    
    
    
}
- (void)touchesMoved: (NSSet *)touches withEvent:(UIEvent *)event
{
    if (isMoved == 0 && isTouched == 1) {
        [dragObject setAlpha:0.7];
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        CGRect newDragObjectFrame = CGRectMake(touchPoint.x - touchOffset.x,
                                               touchPoint.y - touchOffset.y,
                                               self.dragObject.frame.size.width + 20,
                                               self.dragObject.frame.size.height + 20);
        self.dragObject.frame = newDragObjectFrame;
        isMoved = 1;
        
    }
    else if(isTouched == 1){
        //NSLog(@"normal moving");
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        CGRect newDragObjectFrame = CGRectMake(touchPoint.x - touchOffset.x,
                                               touchPoint.y - touchOffset.y,
                                               self.dragObject.frame.size.width,
                                               self.dragObject.frame.size.height);
        self.dragObject.frame = newDragObjectFrame;
    }
}
- (void)removeAllCircles {
    for (DrawCircles *i in circleViews) {
        [i removeFromSuperview];
    }
}

- (void) endGame {
    NSLog(@"game over");
    [self alertStatus:@"Sign in Failed." :@"Error!" :0];
}
- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"in touches end %d",[myBoard terms]);
    [dragObject setAlpha:1];
    //switcher for iterating
    //int switcher = 0;
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if (isTouched == 1 && isMoved == 1) {
        for (UIImageView *iView in self.view.subviews) {
            //enmu for 35 times wired
            if ([iView isMemberOfClass:[UIImageView class]] && iView != backgroud && ![iView.image isEqual:[tempPiece getImage].image] ) {
                //NSLog(@"%d",k++);
                //NSLog(@"touchend succ");
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height )
                {
                    Piece *t = [self getMove:iView];
                    //[myBoard isChecked];
                    //NSLog(@"after checking check %d",[myBoard isInCheck]);
                    [myBoard addRelativeValue];
                    [myBoard checkStatus];
                    
                    if ([myBoard isInCheck] != 0) {
                        if ( [myBoard isPermaChecked]) {
                            [self endGame];
                        }
                    }
//                    if ([[tempPiece getName] rangeOfString:@"king"].location != NSNotFound) {
//                        if ([myBoard kingCanCastle:tempPiece to:t]) {
//                            [myBoard castlingMove:tempPiece to:t];
//                        }
//                    }
                     if ([myBoard setMove:tempPiece to:t and:isDebug]) {
                        [[NSString stringWithFormat:@"%@(%d,%d) momved to %@(%d,%d)\n",[tempPiece getName],[tempPiece getX],[tempPiece getY],[t getName],[t getX],[t getY]] writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

                        [self removeAllCircles];
                    }
                }
            }
        }
        isMoved = 0;
        isTouched = 0;
        self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y,
                                           self.dragObject.frame.size.width - 20,
                                           self.dragObject.frame.size.height - 20);
    }
}

- (IBAction)clickOnComfirm {
    if (isDebug == 0) {
        [myBoard changeTerms];
    }
}

-(void) showAllValues:(DrawValues *)iView{
    for (NSMutableArray *i in [myBoard getPieceSet]) {
        for (Piece *t in i) {
//                NSLog(@"#1%@(%d,%d) approved",[t getName],[t getX],[t getY]);
//                    NSLog(@"#2%@(%d,%d) approved",[t getName],[t getX],[t getY]);
                    CGPoint pt = CGPointMake([[t getImage] center].x, [[t getImage] center].y);
                    //CGPoint pt = CGPointMake([t getImage].frame.origin.x, [t getImage].frame.origin.y);
            [myBoard addRelativeValue];
            [iView drawOnSpot:pt withValues:[t getRelativeValue]];
            
                
            
        }
    }
    return ;
}


//Use “.” in front of the location of aixes, type “move” command to force pieces move. For instance “move.0.0.2.2“ means move piece(0,0) to (2,2), it doesn’t go through any piece specific rules checking.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.debuggingWindow) {
        if ([debuggingWindow.text rangeOfString:@"move"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X2;
            [scanner scanInt:&X2];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y2;
            [scanner scanInt:&Y2];
            NSLog(@"%d %d to %d %d",X1,Y1,X2,Y2);
            [myBoard debugMove:[myBoard getPieceAt:X1 with:Y1] to:[myBoard getPieceAt:X2 with:Y2]];
            
        }
        if ([debuggingWindow.text rangeOfString:@"istakenm"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X2;
            [scanner scanInt:&X2];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y2;
            [scanner scanInt:&Y2];
            Piece *p = [myBoard getPieceAt:X1 with:Y1];
            Piece *t = [myBoard getPieceAt:X2 with:Y2];
            NSLog(@"is taken in move returns %d",[myBoard isTakenInMove:p to:t]);
        }
        else if ([debuggingWindow.text rangeOfString:@"debug mode off"].location != NSNotFound) {
            isDebug = 0;
        }
        else if ([debuggingWindow.text rangeOfString:@"debug mode on"].location != NSNotFound) {
            isDebug = 1;
        }
        else if ([debuggingWindow.text rangeOfString:@"detail on"].location != NSNotFound) {
            isDetailPrinted = 1;
        }
        else if ([debuggingWindow.text rangeOfString:@"detail off"].location != NSNotFound) {
            isDetailPrinted = 0;
        }
        else if ([debuggingWindow.text rangeOfString:@"no think"].location != NSNotFound) {
            myBoard.ifThink = 0;
        }
        else if ([debuggingWindow.text rangeOfString:@"yes think"].location != NSNotFound) {
            myBoard.ifThink = 1;
        }
        else if ([debuggingWindow.text rangeOfString:@"require"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            NSLog(@"%@",[[myBoard getPieceAt:X1 with:Y1] printInformation]);
        }
        else if ([debuggingWindow.text rangeOfString:@"isguard"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            Piece *temp = [myBoard getPieceAt:X1 with:Y1];
            NSMutableArray *a = [myBoard isGuardingPiece:temp];
            NSLog(@"print is guard:");
            for (Piece *i in a) {
                NSLog(@"%@",[i printInformation]);
            }
            
        }
        //taken in move
        else if ([debuggingWindow.text rangeOfString:@"tim"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X2;
            [scanner scanInt:&X2];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y2;
            [scanner scanInt:&Y2];
            Piece *pi = [myBoard getPieceAt:X1 with:Y1];
            Piece *t = [myBoard getPieceAt:X2 with:Y2];
            int ret = [myBoard isTakenInMove:pi to:t];
            NSLog(@"%@ to %@, taken in move result %d",[pi printInformation],[t printInformation],ret);
        }
        // think ahead
        else if ([debuggingWindow.text rangeOfString:@"simnt"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X2;
            [scanner scanInt:&X2];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y2;
            [scanner scanInt:&Y2];
            Piece *pi = [myBoard getPieceAt:X1 with:Y1];
            Piece *t = [myBoard getPieceAt:X2 with:Y2];
            HardBot *tempB = [myBoard copySelf];
            int value = [tempB thinkAhead:[tempB getPieceAt:X1 with:Y1] to:[tempB getPieceAt:X2 with:Y2]];
            NSLog(@"%@ to %@, after move simulate value is %d",[pi printInformation],[t printInformation],value);
        }
        //sim with ifthink = 1
        else if ([debuggingWindow.text rangeOfString:@"simt"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X2;
            [scanner scanInt:&X2];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y2;
            [scanner scanInt:&Y2];
            Piece *pi = [myBoard getPieceAt:X1 with:Y1];
            Piece *t = [myBoard getPieceAt:X2 with:Y2];
            int value = [myBoard thinkAhead:pi to:t];
            NSLog(@"%@ to %@, after move simulate value is %d",[pi printInformation],[t printInformation],value);
        }
        else if ([debuggingWindow.text rangeOfString:@"isunchecked"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X2;
            [scanner scanInt:&X2];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y2;
            [scanner scanInt:&Y2];
            Piece *pi = [myBoard getPieceAt:X1 with:Y1];
            Piece *t = [myBoard getPieceAt:X2 with:Y2];
            HardBot *tempB = [myBoard copySelf];
                NSLog(@"%@ to %@, after move isunchecked is %d",[pi printInformation],[t printInformation],[tempB isUnchecked:pi to:t]);
            
        }
        //value at position
        else if ([debuggingWindow.text rangeOfString:@"vap"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X2;
            [scanner scanInt:&X2];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y2;
            [scanner scanInt:&Y2];
            Piece *pi = [myBoard getPieceAt:X1 with:Y1];
            Piece *t = [myBoard getPieceAt:X2 with:Y2];
            HardBot *tempB = [myBoard imagineMoveOnBoard:pi to:t];
            if (isDetailPrinted == 1) {
                NSMutableArray *a = [myBoard totalBoardValueDetailed:[pi getSide]];
                for (NSString *s in a) {
                    NSLog(@"%@",s);
                }
            }
            else {
            int eva = [tempB totalBoardValue:[pi getSide]];
            NSLog(@"%@ to %@, after move totalboardvalue is %d",[pi printInformation],[t printInformation],eva);
            }
        }
        //Board value check
        else if ([debuggingWindow.text rangeOfString:@"value"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            Piece *temppiece = [myBoard getPieceAt:X1 with:Y1];
            BOOL isCastled = false;
            if ([temppiece getSide] == 1) {
                isCastled = myBoard.isWhiteCastled;
            }
            else if ([temppiece getSide] == 2) {
                isCastled = myBoard.isBlackCastled;
            }

            NSLog(@"%@ value is %d",[temppiece printInformation], [(HardBot *)myBoard boardEvaluationPiece:temppiece isCastled:isCastled isEndGame:0 bishopCount:[myBoard bishopCount:[temppiece getSide]] insufficientMaterial:0]);
        }


        else if ([debuggingWindow.text rangeOfString:@"istaken"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            Piece *temppiece = [myBoard getPieceAt:X1 with:Y1];
            NSLog(@"%@ is takenAfter result: %d, is takenBefore result: %d",[temppiece printInformation],[myBoard isTakenAfterMoved:temppiece],[myBoard isTakenBeforeMoved:temppiece]);
        }
        else if ([debuggingWindow.text rangeOfString:@"ava"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            Piece *t = [myBoard getPieceAt:X1 with:Y1];
            CGRect frame = [UIScreen mainScreen].bounds;
            DrawCircles *drawView = [[DrawCircles alloc] initWithFrame:frame];
            drawView.userInteractionEnabled = NO;
            [self.view addSubview:drawView];
            [self.view bringSubviewToFront:drawView];
            [self showAvailableMoves:t onView:drawView];
            
            NSLog(@"show available move of %@(%d , %d) side:%d(%.2f)",[[myBoard getPieceAt:X1 with:Y1] getName],[t getX],[t getY],[[myBoard getPieceAt:X1 with:Y1] getSide],[[myBoard getPieceAt:X1 with:Y1] getRelativeValue]);
        }
        //Available moves for one piece test
        else if ([debuggingWindow.text rangeOfString:@"opm"].location != NSNotFound) {
            NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int X1;
            [scanner scanInt:&X1];
            [scanner scanUpToString:@"." intoString:NULL];
            [scanner setScanLocation:[scanner scanLocation] + 1];
            int Y1;
            [scanner scanInt:&Y1];
            Piece *t = [myBoard getPieceAt:X1 with:Y1];
            NSMutableArray *moves = [myBoard AvailableMovesForOnePiece:t];
            NSLog(@"Available moves for one %@ print outs:",[t printInformation]);
            for (int i = 0; i < [moves count]; i+=2) {
                NSLog(@"%@ to %@",[[moves objectAtIndex:i] printInformation],[[moves objectAtIndex:i+1] printInformation]);
            }
        }
        else if ([debuggingWindow.text rangeOfString:@"allm"].location != NSNotFound) {
            NSMutableArray *allm = [myBoard getAllMoves:2];
            NSLog(@"All moves");
            for (NSMutableArray *moves in allm) {
                for (int i = 0; i < [moves count]; i+=2) {
                    NSLog(@"%@ to %@",[[moves objectAtIndex:i] printInformation],[[moves objectAtIndex:i+1] printInformation]);
                }
            }
        }
        else if ([debuggingWindow.text rangeOfString:@"allValues"].location != NSNotFound) {
            CGRect frame = [UIScreen mainScreen].bounds;
            DrawValues *valueView = [[DrawValues alloc] initWithFrame:frame];
            [circleViews addObject:valueView];
            valueView.userInteractionEnabled = NO;
            [self.view addSubview:valueView];
            [self.view bringSubviewToFront:valueView];
            [self showAllValues:valueView];
        }
        else if ([debuggingWindow.text rangeOfString:@"best"].location != NSNotFound) {

            [myBoard findBestMove:[myBoard getAllMoves:2]];
        }
        else if ([debuggingWindow.text rangeOfString:@"bestw"].location != NSNotFound) {
            HardBot *tempB = [myBoard copySelf];
            [tempB findBestMove:[tempB getAllMoves:1]];
        }
        else if ([debuggingWindow.text rangeOfString:@"imob"].location != NSNotFound) {
            if ([myBoard class] != [HardBot class]) {
                NSLog(@"myboard is not hardbot class");
            }
            else {
                NSScanner *scanner = [NSScanner scannerWithString:debuggingWindow.text];
                [scanner scanUpToString:@"." intoString:NULL];
                [scanner setScanLocation:[scanner scanLocation] + 1];
                int X1;
                [scanner scanInt:&X1];
                [scanner scanUpToString:@"." intoString:NULL];
                [scanner setScanLocation:[scanner scanLocation] + 1];
                int Y1;
                [scanner scanInt:&Y1];
                [scanner scanUpToString:@"." intoString:NULL];
                [scanner setScanLocation:[scanner scanLocation] + 1];
                int X2;
                [scanner scanInt:&X2];
                [scanner scanUpToString:@"." intoString:NULL];
                [scanner setScanLocation:[scanner scanLocation] + 1];
                int Y2;
                [scanner scanInt:&Y2];
                Piece *pi = [myBoard getPieceAt:X1 with:Y1];
                Piece *t = [myBoard getPieceAt:X2 with:Y2];
                
                [myBoard imagineMoveOnBoard:pi to:t];
                
//                NSLog(@"show available move of %@(%d , %d) side:%d(%.2f)",[[myBoard getPieceAt:X1 with:Y1] getName],[t getX],[t getY],[[myBoard getPieceAt:X1 with:Y1] getSide],[[myBoard getPieceAt:X1 with:Y1] getRelativeValue]);
            }
        }
    }
    debuggingWindow.text = @"";
    return YES;
}

@end

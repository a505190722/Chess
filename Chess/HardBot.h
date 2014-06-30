//
//  HardBot.h
//  Chess
//
//  Created by Liu Di on 6/28/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "Board.h"
#import "ChessManual.h"

@interface HardBot : Board
@property ChessManual *manual;
@property NSMutableArray *pawnValue;
-(void) botMove;
-(BOOL) scriptMove;
-(void) changeTerms;
-(void) botMoveFrom:(Piece *)p to:(Piece *)t;
-(void) addRelativeValue;
@end

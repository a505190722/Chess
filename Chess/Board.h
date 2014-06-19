//
//  Board.h
//  Chess
//
//  Created by Liu Di on 6/15/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
#import "LinearEquation.h"
#import "Player.h"

@interface Board : NSObject
extern int isDebug;
@property NSMutableArray* pieceSet;
@property int terms;
@property Player *white;
@property Player *black;
@property int isChecked;
-(BOOL) setMove:(Piece *) p to:(Piece *)t;
-(BOOL) requrieMove:(Piece *) p to:(Piece *)t;
-(void) setPieceOnBoard:(int)X with:(int)Y with:(Piece *)p;
-(NSMutableArray *) getPieceSet;
-(void) imageTakeOver:(UIImageView *) a takeOver:(UIImageView *)b;
-(void) imageExchange:(UIImageView *) a with:(UIImageView *) b;
-(BOOL) isAbleToBecomeQueenFor:(Piece *) pi to:(Piece *) t;
-(BOOL) isOppColor: (Piece *) pi and :(Piece *)t;
-(Piece *) getPieceAt:(int)X with:(int)Y;
-(void) changeTerms;

-(BOOL)blackPawnMove:(Piece *) pi to :(Piece *)t;
-(BOOL)whitePawnMove:(Piece *) pi to :(Piece *)t;

-(BOOL)knightMove:(Piece *)pi to :(Piece *)t;
-(BOOL)isValidKnightMove:(Piece *)pi to :(Piece*)t;

-(BOOL)isValidBishopMove:(Piece *)pi to:(Piece *)t;
-(BOOL)bishopMove:(Piece *)pi to :(Piece *)t;

-(void) debugMove:(Piece *)p to:(Piece *)t;
-(Piece *)getWhiteKing;
-(Piece *)getBlackKing;
@end

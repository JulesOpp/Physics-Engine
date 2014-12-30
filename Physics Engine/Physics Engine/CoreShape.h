//
//  CoreShape.h
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreShape : NSObject
{
@private
    double posX;
    double posY;
    double velX;
    double velY;
    double accX;
    double accY;
    
    double dragX;
    double dragY;
    double elas;
    
    double framerate;

	BOOL move;
    
    int typeShape; // Def:prob error, rect:1, circle:2
}


-(id) initWithpositionX:(double)xx positionY:(double)xy velocityX:(double)vx velocityY:(double)vy accelerationX:(double)ax accelerationY:(double)ay dragValueX:(double)dx dragValueY:(double)dy elasticity:(double)e canMove:(BOOL)m andFramerate:(double)fr;

-(void) draw: (NSColor*)c;
-(void) update;

-(double) getPosX;
-(double) getPosY;
-(double) getVelX;
-(double) getVelY;
-(double) getAccX;
-(double) getAccY;
-(double) getDragX;
-(double) getDragY;
-(double) getElas;
-(double) getFr;
-(BOOL) getMove;
-(int) getType;

-(void) setPosX: (double) x;
-(void) setPosY: (double) y;
-(void) setVelX: (double) x;
-(void) setVelY: (double) y;
-(void) setAccX: (double) x;
-(void) setAccY: (double) y;
-(void) setDragX: (double) d;
-(void) setDragY: (double) d;
-(void) setElas: (double) e;
//-(void)setMovingState:(BOOL)choice;//not yet implemented

-(void) setType: (int)t;
@end

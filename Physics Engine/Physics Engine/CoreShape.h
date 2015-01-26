//
//  CoreShape.h
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Notes on the physics:
//      Drag is calculated F = -dV where d is a set constant
//      This is a Stokes' drag, approximating relatively low speeds

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
    
    double mass;
    
    double angle;
    double rotation;
    double rotAccel;
    
	BOOL move;
    BOOL ignoreNextUpdate; // To counteract the gravity sink
    
    int typeShape; // Def:prob error, rect:1, circle:2
}


-(id) initWithpositionX:(double)xx positionY:(double)xy velocityX:(double)vx velocityY:(double)vy accelerationX:(double)ax accelerationY:(double)ay dragValueX:(double)dx dragValueY:(double)dy elasticity:(double)e mass:(double)n canMove:(BOOL)m angle:(double)a rotation:(double)r rotAccel:(double)ra;

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
-(double) getMass;
-(BOOL) getMove;
-(int) getType;
-(BOOL) getIgnoreNextUpdate;

-(double) getAngle;
-(double) getRotation;
-(double) getRotAccel;

-(void) setAngle: (double) a;
-(void) setRotation: (double) r;

-(void) setPosX: (double) x;
-(void) setPosY: (double) y;
-(void) setVelX: (double) x;
-(void) setVelY: (double) y;
-(void) setAccX: (double) x;
-(void) setAccY: (double) y;
-(void) setDragX: (double) d;
-(void) setDragY: (double) d;
-(void) setElas: (double) e;
-(void) setMass: (double) m;
-(void) setIgnoreNextUpdate: (BOOL) b;

-(void) setType: (int)t;
@end

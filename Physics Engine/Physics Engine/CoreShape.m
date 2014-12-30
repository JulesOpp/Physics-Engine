//
//  CoreShape.m
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CoreShape.h"

@implementation CoreShape

// The CoreShape is the parent class of all shapes - attributes for (x,y) position, velocity, acceleration, drag, elasticity, ability to move, and framerate and SOON TO BE COLOR
-(id) initWithpositionX:(double)xx positionY:(double)xy velocityX:(double)vx velocityY:(double)vy accelerationX:(double)ax accelerationY:(double)ay dragValueX:(double)dx dragValueY: (double)dy elasticity:(double)e canMove:(BOOL)m andFramerate:(double)fr {
    self = [super init];
    if (self) {
        posX = xx;
        posY = xy;
        velX = vx;
        velY = vy;
        accX = ax;
        accY = ay;
        dragX = dx;
        dragY = dy;
        elas = e;
        move = m;
        framerate = fr;
    }
    return self;
}

-(void) draw:(NSColor*)c {
    // Must be overridden by children
}

-(void) update {
    // Must be overridden by children
}

-(double) getPosX { return posX; }
-(double) getPosY { return posY; }
-(double) getVelX { return velX; }
-(double) getVelY { return velY; }
-(double) getAccX { return accX; }
-(double) getAccY { return accY; }
-(double) getDragX { return dragX; }
-(double) getDragY { return dragY; }
-(double) getElas { return elas; }
-(BOOL) getMove { return move; }
-(double) getFr { return framerate; };
-(int) getType { return typeShape; }

-(void) setPosX: (double) x { posX = x; }
-(void) setPosY: (double) y { posY = y; }
-(void) setVelX: (double) x { velX = x; }
-(void) setVelY: (double) y { velY = y; }
-(void) setAccX: (double) x { accX = x; }
-(void) setAccY: (double) y { accY = y; }
-(void) setDragX: (double) d { dragX = d; }
-(void) setDragY: (double) d { dragY = d; }
-(void) setElas: (double) e { elas = e; }
//-(void)setMovingState:(BOOL)choice{movabilty = choice;}

// The type is interesting - I needed a was to determine which type of CoreShape object I was using, so rectangles declare their type to be 1 and circles to be 2
-(void) setType:(int)t { typeShape = t; }

@end

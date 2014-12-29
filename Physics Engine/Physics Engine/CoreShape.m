//
//  CoreShape.m
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CoreShape.h"

@implementation CoreShape

//-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) d: (double) e: (double) fr {
-(id) initWithpositionX:(double)xx positionY:(double)xy velocityX:(double)vx velocityY:(double)vy accelerationX:(double)ax accelerationY:(double)ay dragValue:(double)d elasticity:(double)e andFramerate:(double)fr {
    self = [super init];
    if (self) {
        posX = xx;
        posY = xy;
        velX = vx;
        velY = vy;
        accX = ax;
        accY = ay;
        drag = d;
        elas = e;
        framerate = fr;
    }
    return self;
}

-(void) draw {
    // Must be overridden
}

-(void) update {
    // Must be overridden
}

-(double) getPosX { return posX; }
-(double) getPosY { return posY; }
-(double) getVelX { return velX; }
-(double) getVelY { return velY; }
-(double) getAccX { return accX; }
-(double) getAccY { return accY; }
-(double) getDrag { return drag; }
-(double) getElas { return elas; }
-(double) getFr { return framerate; };

-(void) setPosX: (double) x { posX = x; }
-(void) setPosY: (double) y { posY = y; }
-(void) setVelX: (double) x { velX = x; }
-(void) setVelY: (double) y { velY = y; }
-(void) setAccX: (double) x { accX = x; }
-(void) setAccY: (double) y { accY = y; }
-(void) setDrag: (double) d { drag = d; }
-(void) setElas: (double) e { elas = e; }
-(void)setMovingState:(BOOL)choice{movabilty = choice;}
@end

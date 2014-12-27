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
    
    double drag;
    double elas;
}

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) d: (double) e;

-(void) draw;

-(double) getPosX;
-(double) getPosY;
-(double) getVelX;
-(double) getVelY;
-(double) getAccX;
-(double) getAccY;
-(double) getDrag;
-(double) getElas;

-(void) setPosX: (double) x;
-(void) setPosY: (double) y;
-(void) setVelX: (double) x;
-(void) setVelY: (double) y;
-(void) setAccX: (double) x;
-(void) setAccY: (double) y;
-(void) setDrag: (double) d;
-(void) setElas: (double) e;

@end

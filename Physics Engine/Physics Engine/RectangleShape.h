//
//  RectangleShape.h
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreShape.h"

@interface RectangleShape : CoreShape
{
    @private
    double width;
    double height;
}

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) d: (double) e: (double) fr: (double) w: (double) h;
-(void) draw;
-(void) update;

@end

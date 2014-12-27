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
    double top;
    double left;
    double bottom;
    double right;
}

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) d: (double) e: (double) t: (double) l: (double) b: (double) r;
-(void) draw;

@end

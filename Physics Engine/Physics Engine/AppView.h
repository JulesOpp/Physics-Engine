//
//  AppView.h
//  Physics Engine
//
//  Created by Jules on 12/26/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CoreShape.h"

@interface AppView : NSView
{
    @public
    int numberShapes;
    BOOL pausePlay;
    
    @private
    int currentObject;
    NSColor *drawColor;
}

- (id)initWithFr:(CGRect)frame:(double)fr;
-(CoreShape*) getObject: (int) i;
-(int) getCurrentObject;
-(void) setColor: (NSColor*)c;

+(int) getWidth;
+(int) getHeight;

@end

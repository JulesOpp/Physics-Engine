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

- (id)initWithFr:(CGRect)frame:(double)fr;
-(void)drawRectangle:(NSRect)aRect:(Rect)bRect;

@end

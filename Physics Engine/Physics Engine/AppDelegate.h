//
//  AppDelegate.h
//  Physics Engine
//
//  Created by Jules on 12/26/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    @public
    AppView *view;
    @private
    BOOL pausePlay;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *numShape;

- (IBAction)refresh:(id)sender;
-(IBAction)pause:(id)sender;

@end

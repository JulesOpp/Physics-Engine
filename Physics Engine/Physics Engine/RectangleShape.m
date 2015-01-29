//
//  RectangleShape.m
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "RectangleShape.h"
#import "AppView.h"
#import "CircleShape.h"
#import "AppDelegate.h"

@implementation RectangleShape

// The posX and posY define the bottom left corner of the rectangle
// All else needed is the width and height

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) dx: (double) dy: (double) e: (double) n: (BOOL) m: (double) w: (double) h: (double) a: (double) r: (double) ra {
	self = [super initWithpositionX:xx positionY:xy velocityX:vx velocityY:vy accelerationX:ax accelerationY:ay dragValueX:dx dragValueY:dy elasticity:e mass:n canMove:m angle:a rotation:r rotAccel:ra];
    if (self) {
        width = w;
        height = h;
    }
    [super setType:1];
    return self;
}

-(void) draw:(NSColor*)c {    
    NSAffineTransform* xform = [NSAffineTransform transform];
    [xform rotateByDegrees:[super getAngle]];
    NSAffineTransform* pointXfrm = [NSAffineTransform transform];
    [pointXfrm rotateByDegrees:-1*[super getAngle]];    //    Needed to get original point in rotated coordinates.
    double storeX = [super getPosX] + width/2;
    double storeY = [super getPosY] + height/2;
    NSPoint oldPoint = [pointXfrm transformPoint:CGPointMake(storeX, storeY)];
    float x = oldPoint.x - storeX;
    float y = oldPoint.y - storeY;
    [xform translateXBy:x yBy:y];    //    Done in the rotated coordinates.
    [xform concat];
    [c setFill];
    NSRectFill(CGRectMake([super getPosX], [super getPosY], width, height));
    [xform invert];
    [xform concat];
}

// For a step by step calculation
// Xf = Xo + V
// Vf = Vo + A
// A = F/m    assuming m=1    Ay = g - dv  and   Ax = -dv

// THE INPUTTED ACCELERATION DOESNT DO ANYTHING RIGHT NOW

-(void) update {
    if (![super getMove]) { [super setVelX:0]; [super setVelY:0]; return;}
    double fr = [AppDelegate getFrameRate]; 
    
    double currentAccR = ([super getMass]*[super getRotAccel] - ([super getDragX]+[super getDragY])/10*[super getRotation])/[super getMass];
    if ([super getIgnoreNextUpdate])
        currentAccR = 0;
    [super setRotation:[super getRotation] + currentAccR*fr*100];
    [super setAngle:[super getAngle] + [super getRotation]*fr*100];

    double gravity = -2;
    //[super setAccX:([super getAccX]-[super getDragX]*[super getVelX])];
    //[super setAccY:([super getAccY]+gravity-[super getDragY]*[super getVelY])];
    
    // Ax = (ma - dv)/m      Ay = (ma - mg - dv)/m
    double currentAccX = ([super getMass]*[super getAccX]-[super getDragX]*[super getVelX])/[super getMass];
    double currentAccY = ([super getMass]*[super getAccY]+[super getMass]*gravity-[super getDragY]*[super getVelY])/[super getMass];
    
    if ([super getIgnoreNextUpdate]) {
        currentAccX = 0;
        currentAccY = 0;
        [super setIgnoreNextUpdate:false];
    }
    
    [super setVelX:[super getVelX]+currentAccX*fr*10];
    [super setVelY:[super getVelY]+currentAccY*fr*10];
    
    [super setPosX:[super getPosX]+[super getVelX]*fr*10];
    [super setPosY:[super getPosY]+[super getVelY]*fr*10];
    
    // Bounce
    if ([super getPosY] < 0 && [super getVelY] < 0)
        [super setVelY:-1*[super getVelY]];
    if ([super getPosX] < 0 && [super getVelX] < 0)
        [super setVelX:-1*[super getVelX]];
    if ([super getPosY] > [AppView getHeight] && [super getVelY] > 0)
        [super setVelY:-1*[super getVelY]];
    if ([super getPosX] > [AppView getWidth] && [super getVelX] > 0)
        [super setVelX:-1*[super getVelX]];
    
    // Keep at bottom
    if ([super getPosY] <= 0) {
        [super setPosY:0];
        [super setVelY:0];
        [super setIgnoreNextUpdate:true];
    }
}

+(BOOL) checkCollisionR2:(RectangleShape*)a:(RectangleShape *) b {
    // USING THE SEPARATE AXIS THEOREM AND ROTATED RECTANGLES
    // http://www.gamedev.net/page/resources/_/technical/game-programming/2d-rotated-rectangle-collision-r2604
    //double Ax1 = [a getPosX], Ax2 = Ax1+[a getWidth],Ay1 = [a getPosY],Ay2 =Ay1+[a getHeight];
    //double Bx1 = [b getPosX], Bx2 = Bx1+[b getWidth],By1 = [b getPosY],By2 =By1+[b getHeight];
    
    double thetaA = -1*[a getAngle];
    double thetaB = -1*[b getAngle];
    double Ax1 = cos(thetaA)*-1*[a getWidth]/2 - sin(thetaA)*-1*[a getHeight]/2+[a getPosX]+[a getWidth]/2;
    double Ay1 = sin(thetaA)*-1*[a getWidth]/2 - cos(thetaA)*-1*[a getHeight]/2+[a getPosY]+[a getHeight]/2;
    double Ax2 = cos(thetaA)*[a getWidth]/2 - sin(thetaA)*[a getHeight]/2+[a getPosX]+[a getWidth]/2;
    double Ay2 = sin(thetaA)*[a getWidth]/2 - cos(thetaA)*[a getHeight]/2+[a getPosY]+[a getHeight]/2;
    
    double Bx1 = cos(thetaB)*-1*[b getWidth]/2 - sin(thetaB)*-1*[b getHeight]/2+[b getPosX]+[b getWidth]/2;
    double By1 = sin(thetaB)*-1*[b getWidth]/2 - cos(thetaB)*-1*[b getHeight]/2+[b getPosY]+[b getHeight]/2;
    double Bx2 = cos(thetaB)*[b getWidth]/2 - sin(thetaB)*[b getHeight]/2+[b getPosX]+[b getWidth]/2;
    double By2 = sin(thetaB)*[b getWidth]/2 - cos(thetaB)*[b getHeight]/2+[b getPosY]+[b getHeight]/2;
    
    struct dpoint { double x; double y; };
    struct dpoint 
        AUL = {Ax1, Ay2},
        AUR = {Ax2, Ay2},
        ALR = {Ax2, Ay1},
        ALL = {Ax1, Ay1},
        BLL = {Bx1, By1},
        BLR = {Bx2, By1},
        BUL = {Bx1, By2},
        BUR = {Bx2, By2};
    struct dpoint 
        axis1 = {AUR.x-AUL.x, AUR.y-AUL.y},
        axis2 = {AUR.x-ALR.x, AUR.y-ALR.y},
        axis3 = {BUL.x-BLL.x, BUL.y-BLL.y},
        axis4 = {BUL.x-BUR.x, BUL.y-BUR.y};
    
    // Project all points to axis2
    double  axis2M = axis2.x*axis2.x + axis2.y*axis2.y;

    double temp = (ALR.x*axis2.x + ALR.y*axis2.y) / axis2M;
    struct dpoint ALR2 = {temp*axis2.x,temp*axis2.y};
    double ALR_Cross_2 = ALR2.x*axis2.x + ALR2.y*axis2.y;
    
    temp = (AUR.x*axis2.x + AUR.y*axis2.y) / axis2M;
    struct dpoint AUR2 = {temp*axis2.x,temp*axis2.y};
    double AUR_Cross_2 = AUR2.x*axis2.x + AUR2.y*axis2.y;
    
    temp = (BLL.x*axis2.x + BLL.y*axis2.y) / axis2M;
    struct dpoint BLL2= {temp*axis2.x,temp*axis2.y};
    double BLL_Cross_2 = BLL2.x*axis2.x + BLL2.y*axis2.y;
    
    temp = (BLR.x*axis2.x + BLR.y*axis2.y) / axis2M;
    struct dpoint BLR2= {temp*axis2.x,temp*axis2.y};
    double BLR_Cross_2 = BLR2.x*axis2.x + BLR2.y*axis2.y;
    
    temp = (BUL.x*axis2.x + BUL.y*axis2.y) / axis2M;
    struct dpoint BUL2= {temp*axis2.x,temp*axis2.y};
    double BUL_Cross_2 = BUL2.x*axis2.x + BUL2.y*axis2.y;
    
    temp = (BUR.x*axis2.x + BUR.y*axis2.y) / axis2M;
    struct dpoint BUR2= {temp*axis2.x,temp*axis2.y};
    double BUR_Cross_2 = BUR2.x*axis2.x + BUR2.y*axis2.y;
    
    double Amin2 = MIN(ALR_Cross_2, AUR_Cross_2);
    double Amax2 = MAX(ALR_Cross_2, AUR_Cross_2);
    double Bmin2 = MIN(MIN(BLL_Cross_2,BLR_Cross_2),MIN(BUL_Cross_2,BUR_Cross_2));
    double Bmax2 = MAX(MAX(BLL_Cross_2,BLR_Cross_2),MAX(BUL_Cross_2,BUR_Cross_2));
        
    if (Bmin2 <= Amax2 && Bmax2 >= Amin2) {
        //NSLog(@"Overlap on 2");
    }
    else {
        //NSLog(@"no2 %f %f %f %f",Amin2,Amax2,Bmin2,Bmax2);
        return false;
    }
    
    
    // Project all points to axis1
    double axis1M = axis1.x*axis1.x + axis1.y*axis1.y;

    temp = (AUL.x*axis1.x + AUL.y*axis1.y) / axis1M;
    struct dpoint AUL1 = {temp*axis1.x,temp*axis1.y};
    double AUL_Cross_1 = AUL1.x*axis1.x + AUL1.y*axis1.y;
    
    temp = (AUR.x*axis1.x + AUR.y*axis1.y) / axis1M;
    struct dpoint AUR1 = {temp*axis1.x,temp*axis1.y};
    double AUR_Cross_1 = AUR1.x*axis1.x + AUR1.y*axis1.y;
    
    temp = (BLL.x*axis1.x + BLL.y*axis1.y) / axis1M;
    struct dpoint BLL1 = {temp*axis1.x,temp*axis1.y};
    double BLL_Cross_1 = BLL1.x*axis1.x + BLL1.y*axis1.y;
    
    temp = (BLR.x*axis1.x + BLR.y*axis1.y) / axis1M;
    struct dpoint BLR1 = {temp*axis1.x,temp*axis1.y};
    double BLR_Cross_1 = BLR1.x*axis1.x + BLR1.y*axis1.y;
    
    temp = (BUL.x*axis1.x + BUL.y*axis1.y) / axis1M;
    struct dpoint BUL1 = {temp*axis1.x,temp*axis1.y};
    double BUL_Cross_1 = BUL1.x*axis1.x + BUL1.y*axis1.y;
    
    temp = (BUR.x*axis1.x + BUR.y*axis1.y) / axis1M;
    struct dpoint BUR1 = {temp*axis1.x,temp*axis1.y};
    double BUR_Cross_1 = BUR1.x*axis1.x + BUR1.y*axis1.y;
    
    double Amin1 = MIN(AUL_Cross_1, AUR_Cross_1);
    double Amax1 = MAX(AUL_Cross_1, AUR_Cross_1);
    double Bmin1 = MIN(MIN(BLL_Cross_1,BLR_Cross_1),MIN(BUL_Cross_1,BUR_Cross_1));
    double Bmax1 = MAX(MAX(BLL_Cross_1,BLR_Cross_1),MAX(BUL_Cross_1,BUR_Cross_1));
    
    if (Bmin1 <= Amax1 && Bmax1 >= Amin1) {
        //NSLog(@"Overlap on 1");
    }
    else {
        //NSLog(@"no1 %f %f %f %f",Amin1,Amax1,Bmin1,Bmax1);
        return false;
    }
    
    
    // Project all points to axis3
    // ALL, ALR, AUR, AUL, BLL, BUL
    double axis3M = axis3.x*axis3.x + axis3.y*axis3.y;

    temp = (BLL.x*axis3.x + BLL.y*axis3.y) / axis3M;
    struct dpoint BLL3 = {temp*axis3.x,temp*axis3.y};
    double BLL_Cross_3 = BLL3.x*axis3.x + BLL3.y*axis3.y;
    
    temp = (BUL.x*axis3.x + BUL.y*axis3.y) / axis3M;
    struct dpoint BUL3 = {temp*axis3.x,temp*axis3.y};
    double BUL_Cross_3 = BUL3.x*axis3.x + BUL3.y*axis3.y;
    
    temp = (ALL.x*axis3.x + ALL.y*axis3.y) / axis3M;
    struct dpoint ALL3= {temp*axis3.x,temp*axis3.y};
    double ALL_Cross_3 = ALL3.x*axis3.x + ALL3.y*axis3.y;
    
    temp = (ALR.x*axis3.x + ALR.y*axis3.y) / axis3M;
    struct dpoint ALR3= {temp*axis3.x,temp*axis3.y};
    double ALR_Cross_3 = ALR3.x*axis3.x + ALR3.y*axis3.y;
    
    temp = (AUL.x*axis3.x + AUL.y*axis3.y) / axis3M;
    struct dpoint AUL3= {temp*axis3.x,temp*axis3.y};
    double AUL_Cross_3 = AUL3.x*axis3.x + AUL3.y*axis3.y;
    
    temp = (AUR.x*axis3.x + AUR.y*axis3.y) / axis3M;
    struct dpoint AUR3= {temp*axis3.x,temp*axis3.y};
    double AUR_Cross_3 = AUR3.x*axis3.x + AUR3.y*axis3.y;
    
    double Bmin3 = MIN(BLL_Cross_3, BUL_Cross_3);
    double Bmax3 = MAX(BLL_Cross_3, BUL_Cross_3);
    double Amin3 = MIN(MIN(ALL_Cross_3,ALR_Cross_3),MIN(AUL_Cross_3,AUR_Cross_3));
    double Amax3 = MAX(MAX(ALL_Cross_3,ALR_Cross_3),MAX(AUL_Cross_3,AUR_Cross_3));
    
    if (Bmin3 <= Amax3 && Bmax3 >= Amin3) {
        //NSLog(@"Overlap on 3");
    }
    else {
        //NSLog(@"no3 %f %f %f %f",Amin3,Amax3,Bmin3,Bmax3);
        return false;
    }

    
    // Project all points to axis4
    // ALL, ALR, AUR, AUL, BUL, BUR
    double axis4M = axis4.x*axis4.x + axis4.y*axis4.y;

    temp = (BUR.x*axis4.x + BUR.y*axis4.y) / axis4M;
    struct dpoint BUR4 = {temp*axis4.x,temp*axis4.y};
    double BUR_Cross_4 = BUR4.x*axis4.x + BUR4.y*axis4.y;
    
    temp = (BUL.x*axis4.x + BUL.y*axis4.y) / axis4M;
    struct dpoint BUL4 = {temp*axis4.x,temp*axis4.y};
    double BUL_Cross_4 = BUL4.x*axis4.x + BUL4.y*axis4.y;
    
    temp = (ALL.x*axis4.x + ALL.y*axis4.y) / axis4M;
    struct dpoint ALL4= {temp*axis4.x,temp*axis4.y};
    double ALL_Cross_4 = ALL4.x*axis4.x + ALL4.y*axis4.y;
    
    temp = (ALR.x*axis4.x + ALR.y*axis4.y) / axis4M;
    struct dpoint ALR4= {temp*axis4.x,temp*axis4.y};
    double ALR_Cross_4 = ALR4.x*axis4.x + ALR4.y*axis4.y;
    
    temp = (AUL.x*axis4.x + AUL.y*axis4.y) / axis4M;
    struct dpoint AUL4= {temp*axis4.x,temp*axis4.y};
    double AUL_Cross_4 = AUL4.x*axis4.x + AUL4.y*axis4.y;
    
    temp = (AUR.x*axis4.x + AUR.y*axis4.y) / axis4M;
    struct dpoint AUR4= {temp*axis4.x,temp*axis4.y};
    double AUR_Cross_4 = AUR4.x*axis4.x + AUR4.y*axis4.y;
    
    double Bmin4 = MIN(BUR_Cross_4, BUL_Cross_4);
    double Bmax4 = MAX(BUR_Cross_4, BUL_Cross_4);
    double Amin4 = MIN(MIN(ALL_Cross_4,ALR_Cross_4),MIN(AUL_Cross_4,AUR_Cross_4));
    double Amax4 = MAX(MAX(ALL_Cross_4,ALR_Cross_4),MAX(AUL_Cross_4,AUR_Cross_4));
    
    if (Bmin4 <= Amax4 && Bmax4 >= Amin4) {
        //NSLog(@"Overlap on 4");
    }
    else {
        //NSLog(@"no4 %f %f %f %f",Amin4,Amax4,Bmin4,Bmax4);
        return false;
    }
    
    return true;
}

// Check for Rect v Rect collision
+(void) checkCollisionR:(RectangleShape*)a:(RectangleShape *) b {
    // Rectangle vs Rectangle
    
    // COLLISION DETECT
    //if ([a getPosX]>[b getPosX]+[b getWidth] || [a getPosX]+[a getWidth]<[b getPosX]) return;
    //if ([a getPosY]+[a getHeight]<[b getPosY] || [a getPosY]>[b getPosY]+[b getHeight]) return;
    
    if (![RectangleShape checkCollisionR2:a:b]) return;
    
    //NSLog(@"Collision on Rect v Rect");
    
    if (![a getMove]) {
        double dx = ([a getPosX] + [a getWidth]/2 - [b getPosX] - [b getWidth]/2)/[a getWidth];
        double dy = ([a getPosY] + [a getHeight]/2 - [b getPosY] - [b getHeight]/2)/[a getHeight];
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Side
        if (adx > ady) {
            [b setVelX:[b getVelX]*[b getElas]*-1];
            [b setPosX:[b getPosX]+adx];
        }
        // Top or bottom
        else {
            [b setVelY:[b getVelY]*[b getElas]*-1];
            [b setPosY:[b getPosY]+ady];
        }
        
        // No gravity sink
        [b setIgnoreNextUpdate:true];
    }
    else if (![b getMove]) {
        double dx = ([a getPosX] + [a getWidth]/2 - [b getPosX] - [b getWidth]/2)/[b getWidth];
        double dy = ([a getPosY] + [a getHeight]/2 - [b getPosY] - [b getHeight]/2)/[b getHeight];
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Side
        if (adx > ady) {
            [a setVelX:[a getVelX]*[a getElas]*-1];
            [a setPosX:[a getPosX]+adx];
        }
        // Top or bottom
        else {
            [a setVelY:[a getVelY]*[a getElas]*-1];
            [a setPosY:[a getPosY]+ady];
        }
        
        // No gravity sink
        [a setIgnoreNextUpdate:true];
    }
    else {
        // TO CHANGE
        //http://www.euclideanspace.com/physics/dynamics/collision/twod/
        
        double Vrx = [a getVelX] - [b getVelX];
        double Vry = [a getVelY] - [b getVelY];
        double Nx = [a getPosX] - [b getPosX];
        double Ny = [a getPosY] - [b getPosY];
        double NVr = Nx * Vrx + Ny * Vry;
        
        /////////////////////////////////////////////////////////
        
        //double rAngle = atan2(Ny, Nx)*180/pi;       // r vector to angle in degrees
        //double roundAngle = round(rAngle*8/360)/8*2*pi;    // To nearest 1/8 circle
        //double rSize = sqrt(Nx*Nx+Ny*Ny);
        //double rax = rSize*cos(roundAngle)/2, ray = rSize*sin(roundAngle)/2, rbx = -1*rax, rby = -1*ray;
        //NSLog(@"%f",roundAngle*180/pi);
        
        double ma = [a getMass], mb = [b getMass];
        double Ia = 1, Ib = 1;
        double rax = -1*Nx/2, ray = -1*Ny/2, rbx = -1*rax, rby = -1*ray;
        
        //double rax = [a getPosX], ray = [a getPosY], rbx = [b getPosX], rby = [b getPosY];
        
        double ma2 = ma*ma, mb2 = mb*mb;
        double maIa = ma*Ia, maIb = ma*Ib, mbIa = mb*Ia, mbIb = mb*Ib;
        double IaIb = Ia*Ib;
        double rax2=rax*rax, ray2=ray*ray, rbx2=rbx*rbx, rby2=rby*rby;
        
        //double Jx;
        //double Jy;
        
        
        double k = 1/ma2 + 2/ma/mb + 1/mb2 - rax2/maIa - rbx2/maIb - ray2/maIa - ray2/mbIa - rax2/mbIa - rbx2/mbIb - rby2/maIb - rby2/mbIb + ray2*rbx2/IaIb + rax2*rby2/IaIb - 2*rax*ray*rbx*rby/IaIb;
        
        double e1k = (1+ ([a getElas]+[b getElas])/2 )/k;
        double sec = rax*ray/Ia + rbx*rby/Ib;
        
        double Jx = e1k * (Vrx*(1/ma - rax2/Ia + 1/mb - rbx2/Ib) - Vry*(sec));
        
        double Jy = e1k * (Vry*(1/ma - ray2/Ia + 1/mb - rby2/Ib) - Vrx*(sec));
        
        NSLog(@"%f %f",Jy,Jx);
         
        
        double Vafx = [a getVelX] - Jx/ma;
        double Vafy = [a getVelY] - Jy/ma;
        double Vbfx = [b getVelX] - Jx/mb;
        double Vbfy = [b getVelY] - Jy/mb;
        double Waf = [a getRotation] - (Jx*ray - Jy*rax)/Ia;
        double Wbf = [b getRotation] - (Jx*rby - Jy*rbx)/Ib;
        
        NSLog(@"Vi, Vf, %f, %f",[a getVelX],Vafx);
        
        [a setVelX:Vafx];
        [a setVelY:Vafy];
        [b setVelX:Vbfx];
        [b setVelY:Vbfy];
        [a setRotation:Waf];
        [b setRotation:Wbf];
        
        double dx = [a getPosX] + [a getWidth]/2 - [b getPosX] - [b getWidth]/2;
        [a setPosX:[a getPosX]+dx/[b getWidth]];
        
        /////////////////////////////////////////////////////////
        /*
        double sumMass = [a getMass] + [b getMass];
        double elasAvg = ([a getElas] + [b getElas]) / 2;
        [a setVelX:[a getVelX] - Nx * NVr / (pow(Nx,2)+pow(Ny,2)) * elasAvg * [b getMass]/sumMass];
        [a setVelY:[a getVelY] - Ny * NVr / (pow(Nx,2)+pow(Ny,2)) * elasAvg * [b getMass]/sumMass];
        
        [b setVelX:[b getVelX] + Nx * NVr / (pow(Nx,2)+pow(Ny,2)) * elasAvg * [a getMass]/sumMass];
        [b setVelY:[b getVelY] + Ny * NVr / (pow(Nx,2)+pow(Ny,2)) * elasAvg * [a getMass]/sumMass];
        
        double dx = [a getPosX] + [a getWidth]/2 - [b getPosX] - [b getWidth]/2;
        [a setPosX:[a getPosX]+dx/[b getWidth]];
         */
    }
    
    // COLLISION SOLVE
    /*
    if ([a getMove] && [b getMove]) {
        // Get distance from midpoints
        double dx = [a getPosX] + [a getWidth]/2 - [b getPosX] - [b getWidth]/2;
        double dy = [a getPosY] + [a getHeight]/2 - [b getPosY] - [b getHeight]/2;
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Approaching from corner
        if (fabs(adx - ady) < 0.1) {
            // TO BE IMPLEMENTED LATER
            double Va = [a getVelX];
            double Vb = [b getVelX];
            
            // Va = E*Mb*(Vb-Va)+Ma*Va+Mb*Vb / Ma+Mb
            [a setVelX:([a getElas]*[b getMass]*(Vb-Va)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setVelX:([b getElas]*[a getMass]*(Va-Vb)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];

        }
        // Approaching from sides
        if (adx > ady) {
            // a on the left
            /*if (dx < 0) {
                [a setVelX:fabs([a getVelX]*[a getElas])*-1];
                [b setVelX:fabs([b getVelX]*[b getElas])*1];
            }
            // a on the right
            else {
                [a setVelX:fabs([a getVelX]*[a getElas])*1];    
                [b setVelX:fabs([b getVelX]*[b getElas])*-1];
            }*//*
            // Inelastic collision equation
            double Va = [a getVelX];
            double Vb = [b getVelX];
            
            // Va = E*Mb*(Vb-Va)+Ma*Va+Mb*Vb / Ma+Mb
            [a setVelX:([a getElas]*[b getMass]*(Vb-Va)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setVelX:([b getElas]*[a getMass]*(Va-Vb)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [a setPosX:[a getPosX]+adx/[b getWidth]];

        }
        // Approaching from top or bottom
        else {
            //[a setVelY:[a getVelY]*[a getElas]*-1];
            //[b setVelY:[b getVelY]*[b getElas]*-1];
            
            double Va = [a getVelY];
            double Vb = [b getVelY];
            
            [a setVelY:([a getElas]*[b getMass]*(Vb-Va)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setVelY:([b getElas]*[a getMass]*(Va-Vb)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [a setPosY:[a getPosY]+ady/[b getHeight]];

        }
    }*/
    
    if (fabs([a getVelX]) < 0.04) [a setVelX:0];
    if (fabs([a getVelY]) < 0.04) [a setVelY:0];
    if (fabs([b getVelX]) < 0.04) [b setVelX:0];
    if (fabs([b getVelY]) < 0.04) [b setVelY:0];
}

// Check for Rect v Circle collision
+(void) checkCollisionC:(RectangleShape*)a:(CircleShape *)b {
    // Rectangle vs Circle
    
    // COLLISION DETECT
    //if ([a getPosX]>[b getPosX]+[b getRadius] || [a getPosX]+[a getWidth]<[b getPosX]-[b getRadius]) return;
    //if ([a getPosY]+[a getHeight]<[b getPosY]-[b getRadius] || [a getPosY]>[b getPosY]+[b getRadius]) return;
    
    //double r = pow([b getRadius],2);
    
    // TO IMPLEMENT, CORNER DETECTION - Right now, circles are interpretted as rects
    //if (r < pow([b getPosX]-[a getPosX],2)+pow([b getPosY]-[a getPosY],2) && r < pow([b getPosX]-[a getPosX]-[a getWidth],2)+pow([b getPosY]-[a getPosY],2) && r < pow([b getPosX]-[a getPosX],2)+pow([b getPosY]-[a getPosY]-[a getHeight],2) && r < pow([b getPosX]-[a getPosX]-[a getWidth],2)+pow([b getPosY]-[a getPosY]-[a getHeight],2)) return;

    /////////////////////////////////////////////////////////
    //http://code.tutsplus.com/tutorials/quick-tip-collision-detection-between-a-circle-and-a-line-segment--active-10632
    
    BOOL inter = false;
    
    double thetaA = -1*[a getAngle];
    double Ax1 = cos(thetaA)*-1*[a getWidth]/2 - sin(thetaA)*-1*[a getHeight]/2+[a getPosX]+[a getWidth]/2;
    double Ay1 = sin(thetaA)*-1*[a getWidth]/2 - cos(thetaA)*-1*[a getHeight]/2+[a getPosY]+[a getHeight]/2;
    double Ax2 = cos(thetaA)*[a getWidth]/2 - sin(thetaA)*[a getHeight]/2+[a getPosX]+[a getWidth]/2;
    double Ay2 = sin(thetaA)*[a getWidth]/2 - cos(thetaA)*[a getHeight]/2+[a getPosY]+[a getHeight]/2;
        
    struct dpoint { double x; double y; };
    struct dpoint 
    AUL = {Ax1, Ay2},
    AUR = {Ax2, Ay2},
    ALR = {Ax2, Ay1},
    ALL = {Ax1, Ay1};
    
    //double ax = [a getPosX], ay = [a getPosY], bx = [a getPosX]+[a getWidth],by=[a getPosY];
    double ax = ALL.x, ay = ALL.y, bx = ALR.x, by = ALR.y;
    double cx = [b getPosX], cy = [b getPosY], r = [b getRadius];
    double vecLX = ax - bx, vecLY = ay - by;
    double magL = sqrt(pow(vecLX,2)+pow(vecLY,2));
    double vecCX = ax - cx, vecCY = ay - cy;
    double norX = -1*vecLY, norY = vecLX;
    double magN = sqrt(pow(norX,2)+pow(norY,2));
    double onNorm = vecCX*norX/magN + vecCY*norY/magN;
    double onLine = vecCX*vecLX/magL + vecCY*vecLY/magL;
    //NSLog(@"%f %f %f %f %f",onNorm, r, (vecLX*vecCX+vecLX+vecCY),onLine,magL);
    if ((fabs(onNorm) <= r && (vecLX*vecCX + vecLY*vecCY) > 0 && onLine < magL) || ( pow(vecCX,2)+pow(vecCY,2) < pow(r,2) ) ) inter = true;
    
    //ax = [a getPosX]+[a getWidth], ay = [a getPosY], bx = [a getPosX]+[a getWidth],by=[a getPosY]+[a getHeight];
    ax = ALR.x, ay = ALR.y, bx = AUR.x, by = AUR.y;
    vecLX = ax - bx, vecLY = ay - by;
    magL = sqrt(pow(vecLX,2)+pow(vecLY,2));
    vecCX = ax - cx, vecCY = ay - cy;
    norX = -1*vecLY, norY = vecLX;
    magN = sqrt(pow(norX,2)+pow(norY,2));
    onNorm = vecCX*norX/magN + vecCY*norY/magN;
    onLine = vecCX*vecLX/magL + vecCY*vecLY/magL;
    if ((fabs(onNorm) <= r && (vecLX*vecCX + vecLY*vecCY) > 0 && onLine < magL) || ( pow(vecCX,2)+pow(vecCY,2) < pow(r,2) ) ) inter = true;

    //ax = [a getPosX], ay = [a getPosY]+[a getHeight], bx = [a getPosX]+[a getWidth],by=[a getPosY]+[a getHeight];
    ax = AUL.x, ay = AUL.y, bx = AUR.x, by = AUR.y;
    vecLX = ax - bx, vecLY = ay - by;
    magL = sqrt(pow(vecLX,2)+pow(vecLY,2));
    vecCX = ax - cx, vecCY = ay - cy;
    norX = -1*vecLY, norY = vecLX;
    magN = sqrt(pow(norX,2)+pow(norY,2));
    onNorm = vecCX*norX/magN + vecCY*norY/magN;
    onLine = vecCX*vecLX/magL + vecCY*vecLY/magL;
    if ((fabs(onNorm) <= r && (vecLX*vecCX + vecLY*vecCY) > 0 && onLine < magL) || ( pow(vecCX,2)+pow(vecCY,2) < pow(r,2) ) ) inter = true;
    
    //ax = [a getPosX],ay=[a getPosY], bx = [a getPosX],by = [a getPosY]+[a getHeight];
    ax = ALR.x, ay = ALR.y, bx = AUL.x, by = AUL.y;
    vecLX = ax - bx, vecLY = ay - by;
    magL = sqrt(pow(vecLX,2)+pow(vecLY,2));
    vecCX = ax - cx, vecCY = ay - cy;
    norX = -1*vecLY, norY = vecLX;
    magN = sqrt(pow(norX,2)+pow(norY,2));
    onNorm = vecCX*norX/magN + vecCY*norY/magN;
    onLine = vecCX*vecLX/magL + vecCY*vecLY/magL;
    if ((fabs(onNorm) <= r && (vecLX*vecCX + vecLY*vecCY) > 0 && onLine < magL) || ( pow(vecCX,2)+pow(vecCY,2) < pow(r,2) ) ) inter = true;

    
    if (inter == false) return;
    
    ////////////////////////////////////////////////////////////////////////////
    
    NSLog(@"Collision on Rect v Circle");
    
    // COLLISION SOLVE

    if (![a getMove]) {
        double dx = ([a getPosX] + [a getWidth]/2 - [b getPosX])/[a getWidth];
        double dy = ([a getPosY] + [a getHeight]/2 - [b getPosY])/[a getHeight];
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Side
        if (adx > ady)
            [b setVelX:[b getVelX]*[b getElas]*-1];
        // Top or bottom
        else {
            [b setVelY:[b getVelY]*[b getElas]*-1];
            double dy = [a getPosY] + [a getHeight]/2 - [b getPosY];
            [b setPosY:[b getPosY]+fabs(dy)/[a getHeight]];

        }
        
        // No gravity sink
        [b setIgnoreNextUpdate:true];
    }
    /*if (![b getMove]) {
        double dx = ([a getPosX] + [a getWidth]/2 - [b getPosX])/[b getRadius]/2;
        double dy = ([a getPosY] + [a getHeight]/2 - [b getPosY])/[b getRadius]/2;
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Side
        if (adx > ady)
            [a setVelX:[a getVelX]*[a getElas]*-1];
        // Top or bottom
        else
            [a setVelY:[a getVelY]*[a getElas]*-1];
        
        // No gravity sink
        [a setIgnoreNextUpdate:true];
    }*/
    //if ([a getMove] && [b getMove]) {
    else {
        double Vrx = [a getVelX] - [b getVelX];
        double Vry = [a getVelY] - [b getVelY];
        double Nx = [a getPosX] + [a getWidth]/2 - [b getPosX];
        double Ny = [a getPosY] + [a getHeight]/2 - [b getPosY];
        double NVr = Nx * Vrx + Ny * Vry;
        
        double sumMass = [a getMass] + [b getMass];
        [a setVelX:[a getVelX] - Nx * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [b getMass]/sumMass];
        [a setVelY:[a getVelY] - Ny * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [b getMass]/sumMass];
        
        [b setVelX:[b getVelX] + Nx * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [a getMass]/sumMass];
        [b setVelY:[b getVelY] + Ny * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [a getMass]/sumMass];
        
        
        double dy = [a getPosY] + [a getHeight]/2 - [b getPosY];
        [b setPosY:[b getPosY]+fabs(dy)/[a getHeight]];

        // Get distance from midpoints
        /*double dx = [a getPosX] + [a getWidth]/2 - [b getPosX];
        double dy = [a getPosY] + [a getHeight]/2 - [b getPosY];
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Approaching from corner
        if (fabs(adx - ady) < 0.1) {
            double Vrx = [a getVelX] - [b getVelX];
            double Vry = [a getVelY] - [b getVelY];
            double Nx = [a getPosX] + [a getWidth]/2 - [b getPosX];
            double Ny = [a getPosY] + [a getHeight]/2 - [b getPosY];
            double NVr = Nx * Vrx + Ny * Vry;
            
            double sumMass = [a getMass] + [b getMass];
            [a setVelX:[a getVelX] - Nx * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [b getMass]/sumMass];
            [a setVelY:[a getVelY] - Ny * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [b getMass]/sumMass];
            
            [b setVelX:[b getVelX] + Nx * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [a getMass]/sumMass];
            [b setVelY:[b getVelY] + Ny * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [a getMass]/sumMass];
            
        }
        // Approaching from sides
        else if (adx > ady) {
            // Inelastic collision equation
            double Va = [a getVelX];
            double Vb = [b getVelX];
            
            // Va = E*Mb*(Vb-Va)+Ma*Va+Mb*Vb / Ma+Mb
            [a setVelX:([a getElas]*[b getMass]*(Vb-Va)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setVelX:([b getElas]*[a getMass]*(Va-Vb)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setPosX:[b getPosX]+adx/[a getWidth]];
        }
        // Approaching from top or bottom
        else {
            double Va = [a getVelY];
            double Vb = [b getVelY];
            
            [a setVelY:([a getElas]*[b getMass]*(Vb-Va)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setVelY:([b getElas]*[a getMass]*(Va-Vb)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setPosY:[b getPosY]+ady/[a getHeight]];

        }
        [a setPosX:[a getPosX]+dx/[b getRadius]];*/
    }
    
    if (fabs([a getVelX]) < 0.04) [a setVelX:0];
    if (fabs([a getVelY]) < 0.04) [a setVelY:0];
    if (fabs([b getVelX]) < 0.04) [b setVelX:0];
    if (fabs([b getVelY]) < 0.04) [b setVelY:0];
    
    /*double Vrx = [a getVelX] - [b getVelX];
    double Vry = [a getVelY] - [b getVelY];
    double Nx = [a getPosX] - [b getPosX];
    double Ny = [a getPosY] - [b getPosY];
    double NVr = Nx * Vrx + Ny * Vry;
    
    [a setVelX:[a getVelX] - Nx * NVr / (pow(Nx,2)+pow(Ny,2))];
    [a setVelY:[a getVelY] - Ny * NVr / (pow(Nx,2)+pow(Ny,2))];
    
    [b setVelX:[b getVelX] + Nx * NVr / (pow(Nx,2)+pow(Ny,2))];
    [b setVelY:[b getVelY] + Ny * NVr / (pow(Nx,2)+pow(Ny,2))];*/
}

// Check if click on rect
+(BOOL) checkCoord: (RectangleShape*)a:(int)x:(int)y {
    if (x < [a getPosX] || x > [a getPosX] + [a getWidth]) return false;
    if (y < [a getPosY] || y > [a getPosY] + [a getHeight]) return false;
    return true;
}

-(double) getWidth { return width; }
-(double) getHeight { return height; }

@end

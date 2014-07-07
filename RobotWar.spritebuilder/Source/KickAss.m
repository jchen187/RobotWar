//
//  KickAss.m
//  RobotWar
//
//  Created by Johnny Chen on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "KickAss.h"
typedef NS_ENUM(NSInteger, RobotState) {
    RobotStateDefault,
    RobotStateTurnaround,
    RobotStateFiring,
    RobotStateSearching
};

@implementation KickAss{
    RobotState _currentRobotState;
    
    CGPoint _lastKnownPosition;
    CGFloat _lastKnownPositionTimestamp;
    BOOL aimleft;
}

BOOL aimleft = TRUE;

- (void)run {
    while (true) {
        if (_currentRobotState == RobotStateFiring) {
            
            //robot stop and shoot for 10 sec
            if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 10.f) {
                _currentRobotState = RobotStateSearching;
            } else {
                CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                if (angle >= 0) {
                    [self turnGunRight:abs(angle)];
                } else {
                    [self turnGunLeft:abs(angle)];
                }
                [self shoot];
            }
        }
        
        if (_currentRobotState == RobotStateSearching) {
            //int r = arc4random() % 10;
            
            int x = _lastKnownPosition.x - self.position.x;
            int y = _lastKnownPosition.y - self.position.y;
            
            //turn the robot in the direction of the last known position
            //compare heading direction with the lastknownposition to see if turn left or right
            /*
             if (([self headingDirection].x * _lastKnownPosition.x < 0) || ([self headingDirection].y * _lastKnownPosition.y < 0)){
             //turn left or right but which?
             
             }
             */
            
            float missingAngle = [self angleBetweenHeadingDirectionAndWorldPosition:_lastKnownPosition];
            //NSLog(@"the missing angle is %f",missingAngle);
            //turn the gun in that direction first
            //[self turnGunLeft:missingAngle];
            
            if (missingAngle >= 0 ){
                [self turnRobotRight:abs(missingAngle)];
            }
            else{
                [self turnRobotRight:abs(missingAngle)];
            }
            
            //do something with the heading position
            //if something turn left otherwise turn right
            
            
            //using P>T to get to the lastknownposition
            [self moveAhead:sqrt(powf(x,2)+powf(y,2))];
            
            
        }
        
        if (_currentRobotState == RobotStateDefault) {
            //go to the one corner

            
            //[self moveBack:10];
            
            if (!aimleft){
                [self turnGunLeft:10];
                [self shoot];
                //[self turnGunLeft:10];
                //[self shoot];
                aimleft = TRUE;
            }
            else {
                [self turnGunRight:10];
                [self shoot];
                //[self turnGunRight:10];
                //[self shoot];
                aimleft = FALSE;
            }
            //[self turnRobotLeft:90];
            //NSLog(@"%f, %f",self.headingDirection.x, self.headingDirection.y);
            //[self turnGunRight:7];
            //[self shoot];
            
            
        }
    }
}

- (void)bulletHitEnemy:(Bullet *)bullet {
    // There are a couple of neat things you could do in this handler
    //[self moveAhead:1];
}

- (void)gotHit{
    //int r = arc4random() % 200;
    [self shoot];
    
    //NSLog(@"The position is %f %f \n", _lastKnownPosition.x, _lastKnownPosition.y);
    //NSLog(@"The position of me is %f %f \n", [self position].x, [self position].y);
    //you cant print a cgpoint so you do .x or .y
    
    //NSLog(@"%f, %f",self.headingDirection.x, self.headingDirection.y);
}

- (void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position {
    if (_currentRobotState != RobotStateFiring) {
        [self cancelActiveAction];
    }
    
    _lastKnownPosition = position;
    _lastKnownPositionTimestamp = self.currentTimestamp;
    _currentRobotState = RobotStateFiring;
}

- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)angle {
    if (_currentRobotState != RobotStateTurnaround) {
        [self cancelActiveAction];
        
        RobotState previousState = _currentRobotState;
        _currentRobotState = RobotStateTurnaround;
        
        // always turn to head straight away from the wall
        if (angle >= 0) {
            [self turnRobotLeft:abs(angle)];
        } else {
            [self turnRobotRight:abs(angle)];
            
        }
        
        [self moveAhead:20];
        
        _currentRobotState = previousState;
    }
}

@end

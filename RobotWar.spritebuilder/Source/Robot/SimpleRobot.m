//
//  SimpleRobot.m
//  RobotWar
//
//  Created by Benjamin Encz on 03/06/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//


#import "SimpleRobot.h"


typedef NS_ENUM(NSInteger, RobotState) {
    RobotStateDefault,
    RobotStateTurnaround,
    RobotStateFiring,
    RobotStateSearching
};

@implementation SimpleRobot {
    RobotState _currentRobotState;
    
    CGPoint _lastKnownPosition;
    CGFloat _lastKnownPositionTimestamp;

}


- (void)run {
    while (true) {
        if (_currentRobotState == RobotStateFiring) {
            
            //robot stop and shoot for 10 sec
            if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 5.f) {
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
            int r = arc4random() % 10;
            int j = arc4random() % 30;
            
            [self moveAhead:j];
            [self turnRobotLeft:r];
            [self moveAhead:j];
            [self turnRobotRight:r];
            [self shoot];
        }
        
        if (_currentRobotState == RobotStateDefault) {
            [self moveAhead:20];
            [self shoot];
        }
    }
}

- (void)bulletHitEnemy:(Bullet *)bullet {
    // There are a couple of neat things you could do in this handler
    //[self moveAhead:1];
}

- (void)gotHit{
    int r = arc4random() % 200;
    int j = arc4random() % 500;
    [self shoot];
    //[self moveBack:j];
    //[self turnRobotLeft:r];
    //[self moveAhead:j];
    //[self turnRobotRight:r];
    
    NSLog(@"The position is %f %f \n", _lastKnownPosition.x, _lastKnownPosition.y);
    NSLog(@"The position of me is %f %f \n", [self position].x, [self position].y);
    //you cant print a cgpoint so you do .x or .y
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




/*
 *
 
typedef NS_ENUM(NSInteger, RobotAction) {
 RobotActionDefault,
 RobotActionTurnaround
 };
 
 @implementation SimpleRobot {
 RobotAction _currentRobotAction;
 }
- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)angle {
  [self cancelActiveAction];
  
  _currentRobotAction = RobotActionTurnaround;
  
  switch (hitDirection) {
    case RobotWallHitDirectionFront:
      [self turnRobotRight:180];
      [self moveAhead:1];
      break;
    case RobotWallHitDirectionRear:
      [self moveAhead:80];
      break;
    case RobotWallHitDirectionLeft:
      [self turnRobotRight:90];
      [self moveAhead:50];
      break;
    case RobotWallHitDirectionRight:
      [self turnRobotLeft:90];
      [self moveAhead:20];
      break;
    default:
      break;
  }
  
  _currentRobotAction = RobotActionDefault;
  
}

//- (void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position {
//  if (_currentRobotAction != RobotActionTurnaround) {
//    [self cancelActiveAction];
//    
//    [self turnRobotLeft:20];
//    [self moveBack:80];
//  }
//}

- (void)run {
  while (true) {
    [self moveAhead:80];
    [self turnRobotRight:20];
    [self moveAhead:100];
    [self shoot];
    [self turnRobotLeft:10];
  }
}

- (void)gotHit {
  [self shoot];
  [self turnRobotLeft:45];
  [self moveAhead:100];
}

@end
 *
 */











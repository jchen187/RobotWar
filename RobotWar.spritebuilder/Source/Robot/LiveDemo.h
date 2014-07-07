//
//  LiveDemo.h
//  RobotWar
//
//  Created by Johnny Chen on 7/7/14.
//  Copyright (c) 2014 MakeGamesWithUs. All rights reserved.
//

#import "Robot.h"

typedef NS_ENUM(NSInteger, RobotState) {
    RobotStateFirstMove,//same as 0
    RobotStateTurnaround,//same as 1
    RobotStateFiring,
    RobotStateSearching,
    RobotStateScatter
    
    //enum is a fancy way of keeping track of all states and it is memory efficient compared to other things like strings and numbers becuase you dont need to know what is default ...
};

@interface LiveDemo : Robot

@property (nonatomic, assign) RobotState currentState;
//set up a way to see what state you are in

@end

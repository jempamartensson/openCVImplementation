//
//  JMPRcreate3DchessboardCorners.h
//  openCVImplementation
//
//  Created by johndoe on 17/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMPRcreate3DchessboardCorners : NSObject

std::vector<cv::Point3f> Create3DChessboardCorners(cv::Size boardSize, float squareSize);

@end

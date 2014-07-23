//
//  JMPRcreate3DchessboardCorners.m
//  openCVImplementation
//
//  Created by johndoe on 17/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRcreate3DchessboardCorners.h"

@implementation JMPRcreate3DchessboardCorners

std::vector<cv::Point3f> Create3DChessboardCorners(cv::Size boardSize, float squareSize)
{
    
    
    std::vector<cv::Point3f> corners;
    
    for( int i = 0; i < boardSize.height; i++ )
    {
        for( int j = 0; j < boardSize.width; j++ )
        {
            corners.push_back(cv::Point3f(float(j*squareSize),
                                          float(i*squareSize), 0));
        }
    }
    
    return corners;
}

@end

//
//  JMPRgetCamera.h
//  openCVImplementation
//
//  Created by johndoe on 18/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMPRgetCamera : NSObject

typedef struct CameraStruct CameraStruct;

std::vector<cv::Point3f> Create3DChessboardCorners(cv::Size boardSize, float squareSize);

CameraStruct CalibrateCamera(cv::Mat image, cv::Size boardSize,float squareSize,bool drawcorners, bool debug);

@end

//
//  JMPRcalibrateCamera.m
//  openCVImplementation
//
//  Created by johndoe on 25/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRcalibrateCamera.h"

@implementation JMPRcalibrateCamera

typedef struct CameraStruct
{
    cv::Mat CameraMatrix;
    cv::Mat ImagePoints;
    cv::Mat DistortionCoefficients;
    cv::Mat Image;
}CameraStruct;

CameraStruct calibrateCamera(char folderpath){
    
    
    
    
    
    
    CameraStruct camera;
    
    return camera;
}

@end

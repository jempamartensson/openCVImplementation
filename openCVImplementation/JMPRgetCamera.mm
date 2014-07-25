//
//  JMPRgetCamera.m
//  openCVImplementation
//
//  Created by johndoe on 18/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRgetCamera.h"
#import "JMPRcreate3DchessboardCorners.h"

@implementation JMPRgetCamera



typedef struct CameraStruct
{
    cv::Mat CameraMatrix;
    cv::Mat ImagePoints;
    cv::Mat DistortionCoefficients;
    cv::Mat Image;
}CameraStruct;

CameraStruct CalibrateCamera(cv::Mat image, cv::Size boardSize,float squareSize,bool drawcorners, bool debug)
{

    
    cv::Size imageSize = image.size();
    
    // Find the chessboard corners
    std::vector<std::vector<cv::Point2f>> imagePoints(1);
    bool found = findChessboardCorners(image, boardSize, imagePoints[0]);
    if(!found)
    {
        std::cout << " \n Could not find chess board!" << std::endl;
        exit(-1);
    }
    if(found)
        cv::cornerSubPix(image, imagePoints[0], cv::Size(11, 11), cv::Size(-1, -1),
                         cv::TermCriteria(CV_TERMCRIT_EPS + CV_TERMCRIT_ITER, 30, 0.1));
    
    if (drawcorners){
        drawChessboardCorners(image, boardSize, cv::Mat(imagePoints[0]), found );
    }
    
    
    std::vector<std::vector<cv::Point3f> > objectPoints(1);
    objectPoints[0] = Create3DChessboardCorners(boardSize, squareSize);
    
    std::vector<cv::Mat> rotationVectors;
    std::vector<cv::Mat> translationVectors;
    
    cv::Mat distortionCoefficients = cv::Mat::zeros(8, 1, CV_64F); // There are 8 distortion coefficients
    cv::Mat cameraMatrix = cv::Mat::eye(3, 3, CV_64F);
    
    int flags = 0;
    double rms = calibrateCamera(objectPoints, imagePoints, imageSize, cameraMatrix,
                                 distortionCoefficients, rotationVectors, translationVectors, flags|CV_CALIB_FIX_K4|CV_CALIB_FIX_K5);
    std::cout<<" \n The RMS is :"<<rms<<std::endl;
    
    
    
    
    CameraStruct camera;
    camera.CameraMatrix = cameraMatrix;
    camera.ImagePoints = cv::Mat(imagePoints[0]);
    camera.DistortionCoefficients = distortionCoefficients;
    camera.Image = image;
    

    
    if (debug){
        std::cout<<"The Camera matrix is: "<<camera.CameraMatrix << std::endl;
        std::cout<<"The DistortionCoefficients is: "<<camera.DistortionCoefficients << std::endl;
    
    }
    
    return camera;
}


@end

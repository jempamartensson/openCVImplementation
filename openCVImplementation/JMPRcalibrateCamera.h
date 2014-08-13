//
//  JMPRcalibrateCamera.h
//  openCVImplementation
//
//  Created by johndoe on 25/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

using namespace cv;
using namespace std;

@interface JMPRcalibrateCamera : NSObject

typedef struct CameraStruct CameraStruct;

CameraStruct calibrateCamera(NSString *folderpath, float squaresize, Mat &distCoeff,Mat &K);


@end

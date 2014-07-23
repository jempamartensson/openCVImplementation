//
//  JMPRcalc3d.h
//  openCVImplementation
//
//  Created by johndoe on 22/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JMPRcalc3d : NSObject



typedef struct Calc3d Calc3d;

Calc3d getP1(cv::Mat img1,cv::Mat img2, cv::Mat cameraM,cv::Mat distM);

@end

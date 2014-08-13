//
//  JMPRcheckRot.h
//  openCVImplementation
//
//  Created by johndoe on 30/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

using namespace cv;
using namespace std;

@interface JMPRcheckRot : NSObject

bool checkrot(Mat_<double> &R);

@end

//
//  JMPRfeatureFinAndMatch.h
//  openCVImplementation
//
//  Created by johndoe on 24/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

using namespace std;
using namespace cv;

@interface JMPRfeatureFinAndMatch : NSObject



void featureFinAndMatch(Mat img1,Mat img2,vector<Point2f> &pt_2d);


@end

//
//  JMPRfeatureFinAndMatch.m
//  openCVImplementation
//
//  Created by johndoe on 24/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRfeatureFinAndMatch.h"


using namespace std;
using namespace cv;

@implementation JMPRfeatureFinAndMatch

void featureFinAndMatch(Mat img1,Mat img2,vector<Point2f> &pt_2d){
    
    DynamicAdaptedFeatureDetector detector( new FastAdjuster(10,true), 5000, 10000, 10);;
    vector<KeyPoint> keypoints_1,keypoints_2;
    
    
    
    detector.detect(img1, keypoints_1);
    detector.detect(img2, keypoints_2);
    
    SiftDescriptorExtractor extractor;
    
    Mat descriptor_1,descriptor_2;
    
    extractor.cv::DescriptorExtractor::compute(img1, keypoints_1, descriptor_1);
    extractor.cv::DescriptorExtractor::compute(img1, keypoints_2, descriptor_2);
    
    vector<vector<DMatch>> matches;
    BFMatcher matcher;
    matcher.knnMatch(descriptor_1, descriptor_2, matches, 400);
    
    
    
    
}



@end

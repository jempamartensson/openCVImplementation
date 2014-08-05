//
//  JMPRcheckRot.m
//  openCVImplementation
//
//  Created by johndoe on 30/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRcheckRot.h"

@implementation JMPRcheckRot


bool checkrot(Mat_<float> &R){
    if(int(fabsf(determinant(R)-1.0 > 1e-07))) {
        return false;
        cout<<"This is not a correct rotation \n";
        
    }
    return true;
}

@end

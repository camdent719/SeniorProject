//
//  Pixels.m
//  AlbedoApp
//
//  Created by AlbedoDev on 3/22/18.
//

//#import <Foundation/Foundation.h>
#import "Pixels.h"

@implementation Pixels

+ (int *) getPixelData:(CMSampleBufferRef *)sampleBuffer {
    printf("something ran");
    int r = 0;
    int g = 0;
    int b = 0;
    
    
    
    
    static int arr[3];
    arr[0] = r;
    arr[1] = g;
    arr[2] = b;
    return arr;
}

@end

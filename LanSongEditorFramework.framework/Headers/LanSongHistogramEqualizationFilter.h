//
//  LanSongHistogramEqualizationFilter.h
//  FilterShowcase
//
//  Created by Adam Marcus on 19/08/2014.
//  Copyright (c) 2014 Sunset Lake Software LLC. All rights reserved.
//

#import "LanSongFilterGroup.h"
#import "LanSongHistogramFilter.h"
#import "LanSongRawDataOutput.h"
#import "LanSongRawDataInput.h"
#import "LanSongTwoInputFilter.h"

@interface LanSongHistogramEqualizationFilter : LanSongFilterGroup
{
    LanSongHistogramFilter *histogramFilter;
    LanSongRawDataOutput *rawDataOutputFilter;
    LanSongRawDataInput *rawDataInputFilter;
}

@property(readwrite, nonatomic) NSUInteger downsamplingFactor;

- (id)initWithHistogramType:(LanSongHistogramType)newHistogramType;

@end

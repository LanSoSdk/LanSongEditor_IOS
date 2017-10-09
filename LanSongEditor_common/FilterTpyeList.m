#import "FilterTpyeList.h"


@interface FilterTpyeList ()
{
    LanSongPicture *sourcePicture;
    LanSongShowcaseFilterType filterType;
    
    LanSongFilterPipeline *pipeline;
    
    
    CIDetector *faceDetector;

  
    BOOL faceThinking;
    
}
@end

@implementation FilterTpyeList


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Filter List";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Disable the last filter (Core Image face detection) if running on iOS 4.0
    if ([LanSongContext supportsFastTextureUpload])
    {
        return LanSong_NUMFILTERS;
    }
    else
    {
        return (LanSong_NUMFILTERS - 1);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterCell"];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (index)
    {
        case LanSong_SATURATION: cell.textLabel.text = @"Saturation"; break;
        case LanSong_CONTRAST: cell.textLabel.text = @"Contrast"; break;
        case LanSong_BRIGHTNESS: cell.textLabel.text = @"Brightness"; break;
        case LanSong_LEVELS: cell.textLabel.text = @"Levels"; break;
        case LanSong_EXPOSURE: cell.textLabel.text = @"Exposure"; break;
        case LanSong_HUE: cell.textLabel.text = @"Hue"; break;
        case LanSong_WHITEBALANCE: cell.textLabel.text = @"White balance"; break;
        case LanSong_MONOCHROME: cell.textLabel.text = @"Monochrome"; break;
        case LanSong_FALSECOLOR: cell.textLabel.text = @"False color"; break;
        case LanSong_SHARPEN: cell.textLabel.text = @"Sharpen"; break;
        case LanSong_UNSHARPMASK: cell.textLabel.text = @"Unsharp mask"; break;
        case LanSong_GAMMA: cell.textLabel.text = @"Gamma"; break;
        case LanSong_TONECURVE: cell.textLabel.text = @"Tone curve"; break;
        case LanSong_HIGHLIGHTSHADOW: cell.textLabel.text = @"Highlights and shadows"; break;
        case LanSong_HAZE: cell.textLabel.text = @"Haze"; break;
        case LanSong_HISTOGRAM: cell.textLabel.text = @"Histogram"; break;
        case LanSong_HISTOGRAM_EQUALIZATION: cell.textLabel.text = @"Histogram Equalization"; break;
        case LanSong_THRESHOLD: cell.textLabel.text = @"Threshold"; break;
        case LanSong_ADAPTIVETHRESHOLD: cell.textLabel.text = @"Adaptive threshold"; break;
        case LanSong_AVERAGELUMINANCETHRESHOLD: cell.textLabel.text = @"Average luminance threshold"; break;
        case LanSong_TRANSFORM3D: cell.textLabel.text = @"Transform (3-D)"; break;
       
        case LanSong_COLORINVERT: cell.textLabel.text = @"Color invert"; break;
        case LanSong_GRAYSCALE: cell.textLabel.text = @"Grayscale"; break;
        case LanSong_SEPIA: cell.textLabel.text = @"Sepia tone"; break;
        case LanSong_MISSETIKATE: cell.textLabel.text = @"Miss Etikate (Lookup)"; break;
        case LanSong_SOFTELEGANCE: cell.textLabel.text = @"Soft elegance (Lookup)"; break;
        case LanSong_AMATORKA: cell.textLabel.text = @"Amatorka (Lookup)"; break;
        case LanSong_PIXELLATE: cell.textLabel.text = @"Pixellate"; break;
        case LanSong_POLARPIXELLATE: cell.textLabel.text = @"Polar pixellate"; break;
        case LanSong_PIXELLATE_POSITION: cell.textLabel.text = @"Pixellate (position)"; break;
        case LanSong_POLKADOT: cell.textLabel.text = @"Polka dot"; break;
        case LanSong_HALFTONE: cell.textLabel.text = @"Halftone"; break;
        case LanSong_CROSSHATCH: cell.textLabel.text = @"Crosshatch"; break;
        case LanSong_SOBELEDGEDETECTION: cell.textLabel.text = @"Sobel edge detection"; break;
        case LanSong_PREWITTEDGEDETECTION: cell.textLabel.text = @"Prewitt edge detection"; break;
        case LanSong_CANNYEDGEDETECTION: cell.textLabel.text = @"Canny edge detection"; break;
        case LanSong_THRESHOLDEDGEDETECTION: cell.textLabel.text = @"Threshold edge detection"; break;
        case LanSong_XYGRADIENT: cell.textLabel.text = @"XY derivative"; break;
        case LanSong_LOWPASS: cell.textLabel.text = @"Low pass"; break;
        case LanSong_HIGHPASS: cell.textLabel.text = @"High pass"; break;
        case LanSong_SKETCH: cell.textLabel.text = @"Sketch"; break;
        case LanSong_THRESHOLDSKETCH: cell.textLabel.text = @"Threshold Sketch"; break;
        case LanSong_TOON: cell.textLabel.text = @"Toon"; break;
        case LanSong_SMOOTHTOON: cell.textLabel.text = @"Smooth toon"; break;
        case LanSong_TILTSHIFT: cell.textLabel.text = @"Tilt shift"; break;
        case LanSong_CGA: cell.textLabel.text = @"CGA colorspace"; break;
        case LanSong_CONVOLUTION: cell.textLabel.text = @"3x3 convolution"; break;
        case LanSong_EMBOSS: cell.textLabel.text = @"Emboss"; break;
        case LanSong_LAPLACIAN: cell.textLabel.text = @"Laplacian"; break;
        case LanSong_POSTERIZE: cell.textLabel.text = @"Posterize"; break;
        case LanSong_SWIRL: cell.textLabel.text = @"Swirl"; break;
        case LanSong_BULGE: cell.textLabel.text = @"Bulge"; break;
        case LanSong_PINCH: cell.textLabel.text = @"Pinch"; break;
        case LanSong_STRETCH: cell.textLabel.text = @"Stretch"; break;
        case LanSong_DILATION: cell.textLabel.text = @"Dilation"; break;
        case LanSong_EROSION: cell.textLabel.text = @"Erosion"; break;
        case LanSong_OPENING: cell.textLabel.text = @"Opening"; break;
        case LanSong_CLOSING: cell.textLabel.text = @"Closing"; break;
        case LanSong_PERLINNOISE: cell.textLabel.text = @"Perlin noise"; break;
        case LanSong_VORONOI: cell.textLabel.text = @"Voronoi"; break;
        case LanSong_MOSAIC: cell.textLabel.text = @"Mosaic"; break;
        case LanSong_LOCALBINARYPATTERN: cell.textLabel.text = @"Local binary pattern"; break;
        case LanSong_CHROMAKEY: cell.textLabel.text = @"Chroma key blend (green)"; break;
        case LanSong_DISSOLVE: cell.textLabel.text = @"Dissolve blend"; break;
        case LanSong_SCREENBLEND: cell.textLabel.text = @"Screen blend"; break;
        case LanSong_COLORBURN: cell.textLabel.text = @"Color burn blend"; break;
        case LanSong_COLORDODGE: cell.textLabel.text = @"Color dodge blend"; break;
        case LanSong_LINEARBURN: cell.textLabel.text = @"Linear burn blend"; break;
        case LanSong_ADD: cell.textLabel.text = @"Add blend"; break;
        case LanSong_DIVIDE: cell.textLabel.text = @"Divide blend"; break;
        case LanSong_MULTIPLY: cell.textLabel.text = @"Multiply blend"; break;
        case LanSong_OVERLAY: cell.textLabel.text = @"Overlay blend"; break;
        case LanSong_LIGHTEN: cell.textLabel.text = @"Lighten blend"; break;
        case LanSong_DARKEN: cell.textLabel.text = @"Darken blend"; break;
        case LanSong_EXCLUSIONBLEND: cell.textLabel.text = @"Exclusion blend"; break;
        case LanSong_DIFFERENCEBLEND: cell.textLabel.text = @"Difference blend"; break;
        case LanSong_SUBTRACTBLEND: cell.textLabel.text = @"Subtract blend"; break;
        case LanSong_HARDLIGHTBLEND: cell.textLabel.text = @"Hard light blend"; break;
        case LanSong_SOFTLIGHTBLEND: cell.textLabel.text = @"Soft light blend"; break;
        case LanSong_COLORBLEND: cell.textLabel.text = @"Color blend"; break;
        case LanSong_HUEBLEND: cell.textLabel.text = @"Hue blend"; break;
        case LanSong_SATURATIONBLEND: cell.textLabel.text = @"Saturation blend"; break;
        case LanSong_LUMINOSITYBLEND: cell.textLabel.text = @"Luminosity blend"; break;
        case LanSong_NORMALBLEND: cell.textLabel.text = @"Normal blend"; break;
        case LanSong_POISSONBLEND: cell.textLabel.text = @"Poisson blend"; break;
        case LanSong_KUWAHARA: cell.textLabel.text = @"Kuwahara"; break;
        case LanSong_KUWAHARARADIUS3: cell.textLabel.text = @"Kuwahara (fixed radius)"; break;
        case LanSong_VIGNETTE: cell.textLabel.text = @"Vignette"; break;
        case LanSong_GAUSSIAN: cell.textLabel.text = @"Gaussian blur"; break;
        case LanSong_MEDIAN: cell.textLabel.text = @"Median (3x3)"; break;
        case LanSong_BILATERAL: cell.textLabel.text = @"Bilateral blur"; break;
        case LanSong_MOTIONBLUR: cell.textLabel.text = @"Motion blur"; break;
        case LanSong_ZOOMBLUR: cell.textLabel.text = @"Zoom blur"; break;
        case LanSong_BOXBLUR: cell.textLabel.text = @"Box blur"; break;
        case LanSong_GAUSSIAN_SELECTIVE: cell.textLabel.text = @"Gaussian selective blur"; break;
        case LanSong_GAUSSIAN_POSITION: cell.textLabel.text = @"Gaussian (centered)"; break;
        case LanSong_FILTERGROUP: cell.textLabel.text = @"Filter Group"; break;
        case LanSong_FACES: cell.textLabel.text = @"Face Detection"; break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    filterType=(LanSongShowcaseFilterType)indexPath.row;
    [self setupFilter]; //更新filter;
    /*
     当选中一个滤镜的时候, 在这里切换到该滤镜.
     */
    if (_filterPen!=nil) {
            NSLog(@"在这里切换滤镜");
         [_filterPen switchFilter:_filter];
    }
   
    
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 更新filter
 */
- (void)setupFilter;
{
    BOOL needsSecondImage = NO;
    
    switch (filterType)
    {
        case LanSong_SEPIA:
        {
            self.title = @"Sepia Tone";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:1.0];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            
            self.filter = [[LanSongSepiaFilter alloc] init];
        }; break;
        case LanSong_PIXELLATE:
        {
            self.title = @"Pixellate";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.05];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:0.3];
            
            self.filter = [[LanSongPixellateFilter alloc] init];
        }; break;
        case LanSong_POLARPIXELLATE:
        {
            self.title = @"Polar Pixellate";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.05];
            [self.filterSlider setMinimumValue:-0.1];
            [self.filterSlider setMaximumValue:0.1];
            
            self.filter = [[LanSongPolarPixellateFilter alloc] init];
        }; break;
        case LanSong_PIXELLATE_POSITION:
        {
            self.title = @"Pixellate (position)";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.25];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:0.5];
            
            self.filter = [[LanSongPixellatePositionFilter alloc] init];
        }; break;
        case LanSong_POLKADOT:
        {
            self.title = @"Polka Dot";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.05];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:0.3];
            
            self.filter = [[LanSongPolkaDotFilter alloc] init];
        }; break;
        case LanSong_HALFTONE:
        {
            self.title = @"Halftone";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.01];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:0.05];
            
            self.filter = [[LanSongHalftoneFilter alloc] init];
        }; break;
        case LanSong_CROSSHATCH:
        {
            self.title = @"Crosshatch";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.03];
            [self.filterSlider setMinimumValue:0.01];
            [self.filterSlider setMaximumValue:0.06];
            
            self.filter = [[LanSongCrosshatchFilter alloc] init];
        }; break;
        case LanSong_COLORINVERT:
        {
            self.title = @"Color Invert";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongColorInvertFilter alloc] init];
        }; break;
        case LanSong_GRAYSCALE:
        {
            self.title = @"Grayscale";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongGrayscaleFilter alloc] init];
        }; break;
        case LanSong_MONOCHROME:
        {
            self.title = @"Monochrome";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:1.0];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            
            self.filter = [[LanSongMonochromeFilter alloc] init];
            [(LanSongMonochromeFilter *)self.filter setColor:(GPUVector4){0.0f, 0.0f, 1.0f, 1.f}];
        }; break;
        case LanSong_FALSECOLOR:
        {
            self.title = @"False Color";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongFalseColorFilter alloc] init];
        }; break;
        case LanSong_SOFTELEGANCE:
        {
            self.title = @"Soft Elegance (Lookup)";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongSoftEleganceFilter alloc] init];
        }; break;
//        case LanSong_MISSETIKATE:
//        {
//            self.title = @"Miss Etikate (Lookup)";
//            self.filterSlider.hidden = YES;
//            
//            self.filter = [[LanSongMissEtikateFilter alloc] init];
//        }; break;
        case LanSong_AMATORKA:
        {
            self.title = @"Amatorka (Lookup)";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongAmatorkaFilter alloc] init];
        }; break;
            
        case LanSong_SATURATION:
        {
            self.title = @"Saturation";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:1.0];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:2.0];
            
            self.filter = [[LanSongSaturationFilter alloc] init];
        }; break;
        case LanSong_CONTRAST:
        {
            self.title = @"Contrast";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:4.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongContrastFilter alloc] init];
        }; break;
        case LanSong_BRIGHTNESS:
        {
            self.title = @"Brightness";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-1.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.0];
            
            self.filter = [[LanSongBrightnessFilter alloc] init];
        }; break;
        case LanSong_LEVELS:
        {
            self.title = @"Levels";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.0];
            
            self.filter = [[LanSongLevelsFilter alloc] init];
        }; break;
        case LanSong_HUE:
        {
            self.title = @"Hue";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:360.0];
            [self.filterSlider setValue:90.0];
            
            self.filter = [[LanSongHueFilter alloc] init];
        }; break;
        case LanSong_WHITEBALANCE:
        {
            self.title = @"White Balance";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:2500.0];
            [self.filterSlider setMaximumValue:7500.0];
            [self.filterSlider setValue:5000.0];
            
            self.filter = [[LanSongWhiteBalanceFilter alloc] init];
        }; break;
        case LanSong_EXPOSURE:
        {
            self.title = @"Exposure";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-4.0];
            [self.filterSlider setMaximumValue:4.0];
            [self.filterSlider setValue:0.0];
            
            self.filter = [[LanSongExposureFilter alloc] init];
        }; break;
        case LanSong_SHARPEN:
        {
            self.title = @"Sharpen";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-1.0];
            [self.filterSlider setMaximumValue:4.0];
            [self.filterSlider setValue:0.0];
            
            self.filter = [[LanSongSharpenFilter alloc] init];
        }; break;
        case LanSong_UNSHARPMASK:
        {
            self.title = @"Unsharp Mask";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:5.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongUnsharpMaskFilter alloc] init];
            
            //            [(LanSongUnsharpMaskFilter *)self.filter setIntensity:3.0];
        }; break;
        case LanSong_GAMMA:
        {
            self.title = @"Gamma";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:3.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongGammaFilter alloc] init];
        }; break;
        case LanSong_TONECURVE:
        {
            self.title = @"Tone curve";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[LanSongToneCurveFilter alloc] init];
            [(LanSongToneCurveFilter *)self.filter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]];
        }; break;
        case LanSong_HIGHLIGHTSHADOW:
        {
            self.title = @"Highlights and Shadows";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:1.0];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            
            self.filter = [[LanSongHighlightShadowFilter alloc] init];
        }; break;
        case LanSong_HAZE:
        {
            self.title = @"Haze / UV";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-0.2];
            [self.filterSlider setMaximumValue:0.2];
            [self.filterSlider setValue:0.2];
            
            self.filter = [[LanSongHazeFilter alloc] init];
        }; break;
      
        case LanSong_HISTOGRAM:
        {
            self.title = @"Histogram";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:4.0];
            [self.filterSlider setMaximumValue:32.0];
            [self.filterSlider setValue:16.0];
            
            self.filter = [[LanSongHistogramFilter alloc] initWithHistogramType:kLanSongHistogramRGB];
        }; break;
        case LanSong_HISTOGRAM_EQUALIZATION:
        {
            self.title = @"Histogram Equalization";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:4.0];
            [self.filterSlider setMaximumValue:32.0];
            [self.filterSlider setValue:16.0];
            
            self.filter = [[LanSongHistogramEqualizationFilter alloc] initWithHistogramType:kLanSongHistogramLuminance];
        }; break;
        case LanSong_THRESHOLD:
        {
            self.title = @"Luminance Threshold";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[LanSongLuminanceThresholdFilter alloc] init];
        }; break;
        case LanSong_ADAPTIVETHRESHOLD:
        {
            self.title = @"Adaptive Threshold";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:1.0];
            [self.filterSlider setMaximumValue:20.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongAdaptiveThresholdFilter alloc] init];
        }; break;
        case LanSong_AVERAGELUMINANCETHRESHOLD:
        {
            self.title = @"Avg. Lum. Threshold";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:2.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongAverageLuminanceThresholdFilter alloc] init];
        }; break;
//        case LanSong_MASK:  暂时不支持Mask
//        {
//            self.title = @"Mask";
//            self.filterSlider.hidden = YES;
//            needsSecondImage = YES;
//            
//            self.filter = [[LanSongMaskFilter alloc] init];
//            
//            [(LanSongFilter*)self.filter setBackgroundColorRed:0.0 green:1.0 blue:0.0 alpha:1.0];
//        }; break;
        case LanSong_TRANSFORM3D:
        {
            self.title = @"Transform (3-D)";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:6.28];
            [self.filterSlider setValue:0.75];
            
            self.filter = [[LanSongTransformFilter alloc] init];
            CATransform3D perspectiveTransform = CATransform3DIdentity;
            perspectiveTransform.m34 = 0.4;
            perspectiveTransform.m33 = 0.4;
            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, 0.75, 0.0, 1.0, 0.0);
            
            [(LanSongTransformFilter *)self.filter setTransform3D:perspectiveTransform];
        }; break;
        case LanSong_SOBELEDGEDETECTION:
        {
            self.title = @"Sobel Edge Detection";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.25];
            
            self.filter = [[LanSongSobelEdgeDetectionFilter alloc] init];
        }; break;
        case LanSong_XYGRADIENT:
        {
            self.title = @"XY Derivative";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongXYDerivativeFilter alloc] init];
        }; break;
        case LanSong_PREWITTEDGEDETECTION:
        {
            self.title = @"Prewitt Edge Detection";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongPrewittEdgeDetectionFilter alloc] init];
        }; break;
        case LanSong_CANNYEDGEDETECTION:
        {
            self.title = @"Canny Edge Detection";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongCannyEdgeDetectionFilter alloc] init];
        }; break;
        case LanSong_THRESHOLDEDGEDETECTION:
        {
            self.title = @"Threshold Edge Detection";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.25];
            
            self.filter = [[LanSongThresholdEdgeDetectionFilter alloc] init];
        }; break;
        case LanSong_LOCALBINARYPATTERN:
        {
            self.title = @"Local Binary Pattern";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:1.0];
            [self.filterSlider setMaximumValue:5.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongLocalBinaryPatternFilter alloc] init];
        }; break;
        case LanSong_LOWPASS:
        {
            self.title = @"Low Pass";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[LanSongLowPassFilter alloc] init];
        }; break;
        case LanSong_HIGHPASS:
        {
            self.title = @"High Pass";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[LanSongHighPassFilter alloc] init];
        }; break;
        case LanSong_SKETCH:
        {
            self.title = @"Sketch";
            self.filterSlider.hidden = NO;
            
            [_filterSlider setMinimumValue:0.0];
            [_filterSlider setMaximumValue:1.0];
            [_filterSlider setValue:0.25];
           
            
            self.filter = [[LanSongSketchFilter alloc] init];
        }; break;
        case LanSong_THRESHOLDSKETCH:
        {
            self.title = @"Threshold Sketch";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.25];
            
            self.filter = [[LanSongThresholdSketchFilter alloc] init];
        }; break;
        case LanSong_TOON:
        {
            self.title = @"Toon";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongToonFilter alloc] init];
        }; break;
        case LanSong_SMOOTHTOON:
        {
            self.title = @"Smooth Toon";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:1.0];
            [self.filterSlider setMaximumValue:6.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongSmoothToonFilter alloc] init];
        }; break;
        case LanSong_TILTSHIFT:
        {
            self.title = @"Tilt Shift";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.2];
            [self.filterSlider setMaximumValue:0.8];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[LanSongTiltShiftFilter alloc] init];
            [(LanSongTiltShiftFilter *)self.filter setTopFocusLevel:0.4];
            [(LanSongTiltShiftFilter *)self.filter setBottomFocusLevel:0.6];
            [(LanSongTiltShiftFilter *)self.filter setFocusFallOffRate:0.2];
        }; break;
        case LanSong_CGA:
        {
            self.title = @"CGA Colorspace";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongCGAColorspaceFilter alloc] init];
        }; break;
        case LanSong_CONVOLUTION:
        {
            self.title = @"3x3 Convolution";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSong3x3ConvolutionFilter alloc] init];
            //            [(LanSong3x3ConvolutionFilter *)self.filter setConvolutionKernel:(GPUMatrix3x3){
            //                {-2.0f, -1.0f, 0.0f},
            //                {-1.0f,  1.0f, 1.0f},
            //                { 0.0f,  1.0f, 2.0f}
            //            }];
            [(LanSong3x3ConvolutionFilter *)self.filter setConvolutionKernel:(GPUMatrix3x3){
                {-1.0f,  0.0f, 1.0f},
                {-2.0f, 0.0f, 2.0f},
                {-1.0f,  0.0f, 1.0f}
            }];
            
            //            [(LanSong3x3ConvolutionFilter *)self.filter setConvolutionKernel:(GPUMatrix3x3){
            //                {1.0f,  1.0f, 1.0f},
            //                {1.0f, -8.0f, 1.0f},
            //                {1.0f,  1.0f, 1.0f}
            //            }];
            //            [(LanSong3x3ConvolutionFilter *)self.filter setConvolutionKernel:(GPUMatrix3x3){
            //                { 0.11f,  0.11f, 0.11f},
            //                { 0.11f,  0.11f, 0.11f},
            //                { 0.11f,  0.11f, 0.11f}
            //            }];
        }; break;
        case LanSong_EMBOSS:
        {
            self.title = @"Emboss";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:5.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongEmbossFilter alloc] init];
        }; break;
        case LanSong_LAPLACIAN:
        {
            self.title = @"Laplacian";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongLaplacianFilter alloc] init];
        }; break;
        case LanSong_POSTERIZE:
        {
            self.title = @"Posterize";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:1.0];
            [self.filterSlider setMaximumValue:20.0];
            [self.filterSlider setValue:10.0];
            
            self.filter = [[LanSongPosterizeFilter alloc] init];
        }; break;
        case LanSong_SWIRL:
        {
            self.title = @"Swirl";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:2.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongSwirlFilter alloc] init];
        }; break;
        case LanSong_BULGE:
        {
            self.title = @"Bulge";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-1.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[LanSongBulgeDistortionFilter alloc] init];
        }; break;
        case LanSong_PINCH:
        {
            self.title = @"Pinch";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-2.0];
            [self.filterSlider setMaximumValue:2.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[LanSongPinchDistortionFilter alloc] init];
        }; break;
        case LanSong_STRETCH:
        {
            self.title = @"Stretch";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongStretchDistortionFilter alloc] init];
        }; break;
        case LanSong_DILATION:
        {
            self.title = @"Dilation";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongRGBDilationFilter alloc] initWithRadius:4];
        }; break;
        case LanSong_EROSION:
        {
            self.title = @"Erosion";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongRGBErosionFilter alloc] initWithRadius:4];
        }; break;
        case LanSong_OPENING:
        {
            self.title = @"Opening";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongRGBOpeningFilter alloc] initWithRadius:4];
        }; break;
        case LanSong_CLOSING:
        {
            self.title = @"Closing";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongRGBClosingFilter alloc] initWithRadius:4];
        }; break;
            
        case LanSong_PERLINNOISE:
        {
            self.title = @"Perlin Noise";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:1.0];
            [self.filterSlider setMaximumValue:30.0];
            [self.filterSlider setValue:8.0];
            
            self.filter = [[LanSongPerlinNoiseFilter alloc] init];
        }; break;
        case LanSong_MOSAIC:
        {
            self.title = @"Mosaic";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.002];
            [self.filterSlider setMaximumValue:0.05];
            [self.filterSlider setValue:0.025];
            
            self.filter = [[LanSongMosaicFilter alloc] init];
            [(LanSongMosaicFilter *)self.filter setTileSet:@"squares.png"];
            [(LanSongMosaicFilter *)self.filter setColorOn:NO];
            //[(LanSongMosaicFilter *)self.filter setTileSet:@"dotletterstiles.png"];
            //[(LanSongMosaicFilter *)self.filter setTileSet:@"curvies.png"];
            
        }; break;
        case LanSong_CHROMAKEY:
        {
            self.title = @"Chroma Key (Green)";
            self.filterSlider.hidden = NO;
            needsSecondImage = YES;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.4];
            
            self.filter = [[LanSongChromaKeyBlendFilter alloc] init];
            [(LanSongChromaKeyBlendFilter *)self.filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
        }; break;
        case LanSong_ADD:
        {
            self.title = @"Add Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongAddBlendFilter alloc] init];
        }; break;
        case LanSong_DIVIDE:
        {
            self.title = @"Divide Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongDivideBlendFilter alloc] init];
        }; break;
        case LanSong_MULTIPLY:
        {
            self.title = @"Multiply Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongMultiplyBlendFilter alloc] init];
        }; break;
        case LanSong_OVERLAY:
        {
            self.title = @"Overlay Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongOverlayBlendFilter alloc] init];
        }; break;
        case LanSong_LIGHTEN:
        {
            self.title = @"Lighten Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongLightenBlendFilter alloc] init];
        }; break;
        case LanSong_DARKEN:
        {
            self.title = @"Darken Blend";
            self.filterSlider.hidden = YES;
            
            needsSecondImage = YES;
            self.filter = [[LanSongDarkenBlendFilter alloc] init];
        }; break;
        case LanSong_DISSOLVE:
        {
            self.title = @"Dissolve Blend";
            self.filterSlider.hidden = NO;
            needsSecondImage = YES;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[LanSongDissolveBlendFilter alloc] init];
        }; break;
        case LanSong_SCREENBLEND:
        {
            self.title = @"Screen Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongScreenBlendFilter alloc] init];
        }; break;
        case LanSong_COLORBURN:
        {
            self.title = @"Color Burn Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongColorBurnBlendFilter alloc] init];
        }; break;
        case LanSong_COLORDODGE:
        {
            self.title = @"Color Dodge Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongColorDodgeBlendFilter alloc] init];
        }; break;
        case LanSong_LINEARBURN:
        {
            self.title = @"Linear Burn Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongLinearBurnBlendFilter alloc] init];
        }; break;
        case LanSong_EXCLUSIONBLEND:
        {
            self.title = @"Exclusion Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongExclusionBlendFilter alloc] init];
        }; break;
        case LanSong_DIFFERENCEBLEND:
        {
            self.title = @"Difference Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongDifferenceBlendFilter alloc] init];
        }; break;
        case LanSong_SUBTRACTBLEND:
        {
            self.title = @"Subtract Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongSubtractBlendFilter alloc] init];
        }; break;
        case LanSong_HARDLIGHTBLEND:
        {
            self.title = @"Hard Light Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongHardLightBlendFilter alloc] init];
        }; break;
        case LanSong_SOFTLIGHTBLEND:
        {
            self.title = @"Soft Light Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongSoftLightBlendFilter alloc] init];
        }; break;
        case LanSong_COLORBLEND:
        {
            self.title = @"Color Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongColorBlendFilter alloc] init];
        }; break;
        case LanSong_HUEBLEND:
        {
            self.title = @"Hue Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongHueBlendFilter alloc] init];
        }; break;
        case LanSong_SATURATIONBLEND:
        {
            self.title = @"Saturation Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongSaturationBlendFilter alloc] init];
        }; break;
        case LanSong_LUMINOSITYBLEND:
        {
            self.title = @"Luminosity Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongLuminosityBlendFilter alloc] init];
        }; break;
        case LanSong_NORMALBLEND:
        {
            self.title = @"Normal Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[LanSongNormalBlendFilter alloc] init];
        }; break;
        case LanSong_POISSONBLEND:
        {
            self.title = @"Poisson Blend";
            self.filterSlider.hidden = NO;
            needsSecondImage = YES;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[LanSongPoissonBlendFilter alloc] init];
        }; break;
        case LanSong_KUWAHARA:
        {
            self.title = @"Kuwahara";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:3.0];
            [self.filterSlider setMaximumValue:8.0];
            [self.filterSlider setValue:3.0];
            
            self.filter = [[LanSongKuwaharaFilter alloc] init];
        }; break;
        case LanSong_KUWAHARARADIUS3:
        {
            self.title = @"Kuwahara (Radius 3)";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongKuwaharaRadius3Filter alloc] init];
        }; break;
        case LanSong_VIGNETTE:
        {
            self.title = @"Vignette";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.5];
            [self.filterSlider setMaximumValue:0.9];
            [self.filterSlider setValue:0.75];
            
            self.filter = [[LanSongVignetteFilter alloc] init];
        }; break;
        case LanSong_GAUSSIAN:
        {
            self.title = @"Gaussian Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:24.0];
            [self.filterSlider setValue:2.0];
            
            self.filter = [[LanSongGaussianBlurFilter alloc] init];
        }; break;
        case LanSong_BOXBLUR:
        {
            self.title = @"Box Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:24.0];
            [self.filterSlider setValue:2.0];
            
            self.filter = [[LanSongBoxBlurFilter alloc] init];
        }; break;
        case LanSong_MEDIAN:
        {
            self.title = @"Median";
            self.filterSlider.hidden = YES;
            
            self.filter = [[LanSongMedianFilter alloc] init];
        }; break;
        case LanSong_MOTIONBLUR:
        {
            self.title = @"Motion Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:180.0f];
            [self.filterSlider setValue:0.0];
            
            self.filter = [[LanSongMotionBlurFilter alloc] init];
        }; break;
        case LanSong_ZOOMBLUR:
        {
            self.title = @"Zoom Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:2.5f];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongZoomBlurFilter alloc] init];
        }; break;
       case LanSong_GAUSSIAN_SELECTIVE:
        {
            self.title = @"Selective Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:.75f];
            [self.filterSlider setValue:40.0/320.0];
            
            self.filter = [[LanSongGaussianSelectiveBlurFilter alloc] init];
            [(LanSongGaussianSelectiveBlurFilter*)self.filter setExcludeCircleRadius:40.0/320.0];
        }; break;
        case LanSong_GAUSSIAN_POSITION:
        {
            self.title = @"Selective Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:.75f];
            [self.filterSlider setValue:40.0/320.0];
            
            self.filter = [[LanSongGaussianBlurPositionFilter alloc] init];
            [(LanSongGaussianBlurPositionFilter*)self.filter setBlurRadius:40.0/320.0];
        }; break;
        case LanSong_BILATERAL:
        {
            self.title = @"Bilateral Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:10.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[LanSongBilateralFilter alloc] init];
        }; break;
        case LanSong_FILTERGROUP:
        {
            self.title = @"Filter Group";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.05];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:0.3];
            
            self.filter = [[LanSongFilterGroup alloc] init];
            
            LanSongSepiaFilter *sepiaFilter = [[LanSongSepiaFilter alloc] init];
            [(LanSongFilterGroup *)self.filter addFilter:sepiaFilter];
            
            LanSongPixellateFilter *pixellateFilter = [[LanSongPixellateFilter alloc] init];
            [(LanSongFilterGroup *)self.filter addFilter:pixellateFilter];
            
            [sepiaFilter addTarget:pixellateFilter];
            [(LanSongFilterGroup *)self.filter setInitialFilters:[NSArray arrayWithObject:sepiaFilter]];
            [(LanSongFilterGroup *)self.filter setTerminalFilter:pixellateFilter];
        }; break;
        default: self.filter = [[LanSongSepiaFilter alloc] init]; break;
    }
        //对上面的的补充.
        if (needsSecondImage)
        {
            UIImage *inputImage;
            
//            if (filterType == LanSong_MASK)
//            {
//                inputImage = [UIImage imageNamed:@"mask"];
//            }
//            else {
                inputImage = [UIImage imageNamed:@"WID-small.jpg"];
//            }
            
            sourcePicture = [[LanSongPicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
            [sourcePicture processImage];
            
            [sourcePicture addTarget:self.filter];
        }
}
     
/**

 当slider滑动时调用这里,更改相关效果.

 */
- (void)updateFilterFromSlider:(UISlider *)sender;
{
    switch(filterType)
    {
        case LanSong_SEPIA: [(LanSongSepiaFilter *)self.filter setIntensity:[(UISlider *)sender value]]; break;
        case LanSong_PIXELLATE:
            [(LanSongPixellateFilter *)self.filter setFractionalWidthOfAPixel:[(UISlider *)sender value]];
            break;
        case LanSong_POLARPIXELLATE:
            
            [(LanSongPolarPixellateFilter *)self.filter setPixelSize:CGSizeMake([(UISlider *)sender value], [(UISlider *)sender value])];
            
            break;
        case LanSong_PIXELLATE_POSITION:
            [(LanSongPixellatePositionFilter *)self.filter setRadius:[(UISlider *)sender value]];
            break;
        case LanSong_POLKADOT: [(LanSongPolkaDotFilter *)self.filter setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case LanSong_HALFTONE: [(LanSongHalftoneFilter *)self.filter setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case LanSong_SATURATION: [(LanSongSaturationFilter *)self.filter setSaturation:[(UISlider *)sender value]]; break;
        case LanSong_CONTRAST: [(LanSongContrastFilter *)self.filter setContrast:[(UISlider *)sender value]]; break;
        case LanSong_BRIGHTNESS: [(LanSongBrightnessFilter *)self.filter setBrightness:[(UISlider *)sender value]]; break;
        case LanSong_LEVELS: {
            float value = [(UISlider *)sender value];
            [(LanSongLevelsFilter *)self.filter setRedMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
            [(LanSongLevelsFilter *)self.filter setGreenMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
            [(LanSongLevelsFilter *)self.filter setBlueMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
        }; break;
        case LanSong_EXPOSURE: [(LanSongExposureFilter *)self.filter setExposure:[(UISlider *)sender value]]; break;
        case LanSong_MONOCHROME: [(LanSongMonochromeFilter *)self.filter setIntensity:[(UISlider *)sender value]]; break;
        case LanSong_HUE: [(LanSongHueFilter *)self.filter setHue:[(UISlider *)sender value]]; break;
        case LanSong_WHITEBALANCE: [(LanSongWhiteBalanceFilter *)self.filter setTemperature:[(UISlider *)sender value]]; break;
        case LanSong_SHARPEN: [(LanSongSharpenFilter *)self.filter setSharpness:[(UISlider *)sender value]]; break;
        case LanSong_HISTOGRAM: [(LanSongHistogramFilter *)self.filter setDownsamplingFactor:round([(UISlider *)sender value])]; break;
        case LanSong_HISTOGRAM_EQUALIZATION: [(LanSongHistogramEqualizationFilter *)self.filter setDownsamplingFactor:round([(UISlider *)sender value])]; break;
        case LanSong_UNSHARPMASK: [(LanSongUnsharpMaskFilter *)self.filter setIntensity:[(UISlider *)sender value]]; break;
        case LanSong_GAMMA: [(LanSongGammaFilter *)self.filter setGamma:[(UISlider *)sender value]]; break;
        case LanSong_CROSSHATCH: [(LanSongCrosshatchFilter *)self.filter setCrossHatchSpacing:[(UISlider *)sender value]]; break;
        case LanSong_POSTERIZE: [(LanSongPosterizeFilter *)self.filter setColorLevels:round([(UISlider*)sender value])]; break;
        case LanSong_HAZE: [(LanSongHazeFilter *)self.filter setDistance:[(UISlider *)sender value]]; break;
        case LanSong_SOBELEDGEDETECTION: [(LanSongSobelEdgeDetectionFilter *)self.filter setEdgeStrength:[(UISlider *)sender value]]; break;
        case LanSong_PREWITTEDGEDETECTION: [(LanSongPrewittEdgeDetectionFilter *)self.filter setEdgeStrength:[(UISlider *)sender value]]; break;
        case LanSong_SKETCH: [(LanSongSketchFilter *)self.filter setEdgeStrength:[(UISlider *)sender value]]; break;
        case LanSong_THRESHOLD: [(LanSongLuminanceThresholdFilter *)self.filter setThreshold:[(UISlider *)sender value]]; break;
        case LanSong_ADAPTIVETHRESHOLD: [(LanSongAdaptiveThresholdFilter *)self.filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
        case LanSong_AVERAGELUMINANCETHRESHOLD: [(LanSongAverageLuminanceThresholdFilter *)self.filter setThresholdMultiplier:[(UISlider *)sender value]]; break;
        case LanSong_DISSOLVE: [(LanSongDissolveBlendFilter *)self.filter setMix:[(UISlider *)sender value]]; break;
        case LanSong_POISSONBLEND: [(LanSongPoissonBlendFilter *)self.filter setMix:[(UISlider *)sender value]]; break;
        case LanSong_LOWPASS: [(LanSongLowPassFilter *)self.filter setFilterStrength:[(UISlider *)sender value]]; break;
        case LanSong_HIGHPASS: [(LanSongHighPassFilter *)self.filter setFilterStrength:[(UISlider *)sender value]]; break;
        case LanSong_CHROMAKEY: [(LanSongChromaKeyBlendFilter *)self.filter setThresholdSensitivity:[(UISlider *)sender value]]; break;
        case LanSong_KUWAHARA: [(LanSongKuwaharaFilter *)self.filter setRadius:round([(UISlider *)sender value])]; break;
        case LanSong_SWIRL: [(LanSongSwirlFilter *)self.filter setAngle:[(UISlider *)sender value]]; break;
        case LanSong_EMBOSS: [(LanSongEmbossFilter *)self.filter setIntensity:[(UISlider *)sender value]]; break;
        case LanSong_CANNYEDGEDETECTION: [(LanSongCannyEdgeDetectionFilter *)self.filter setBlurTexelSpacingMultiplier:[(UISlider*)sender value]]; break;
        case LanSong_THRESHOLDEDGEDETECTION: [(LanSongThresholdEdgeDetectionFilter *)self.filter setThreshold:[(UISlider *)sender value]]; break;
        case LanSong_SMOOTHTOON: [(LanSongSmoothToonFilter *)self.filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
        case LanSong_THRESHOLDSKETCH: [(LanSongThresholdSketchFilter *)self.filter setThreshold:[(UISlider *)sender value]]; break;
        case LanSong_BULGE: [(LanSongBulgeDistortionFilter *)self.filter setScale:[(UISlider *)sender value]]; break;
        case LanSong_TONECURVE: [(LanSongToneCurveFilter *)self.filter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, [(UISlider *)sender value])], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]]; break;
        case LanSong_HIGHLIGHTSHADOW: [(LanSongHighlightShadowFilter *)self.filter setHighlights:[(UISlider *)sender value]]; break;
        case LanSong_PINCH: [(LanSongPinchDistortionFilter *)self.filter setScale:[(UISlider *)sender value]]; break;
        case LanSong_PERLINNOISE:  [(LanSongPerlinNoiseFilter *)self.filter setScale:[(UISlider *)sender value]]; break;
        case LanSong_MOSAIC:  [(LanSongMosaicFilter *)self.filter setDisplayTileSize:CGSizeMake([(UISlider *)sender value], [(UISlider *)sender value])]; break;
        case LanSong_VIGNETTE: [(LanSongVignetteFilter *)self.filter setVignetteEnd:[(UISlider *)sender value]]; break;
        case LanSong_BOXBLUR: [(LanSongBoxBlurFilter *)self.filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
        case LanSong_GAUSSIAN: [(LanSongGaussianBlurFilter *)self.filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
            //        case LanSong_GAUSSIAN: [(LanSongGaussianBlurFilter *)self.filter setBlurPasses:round([(UISlider*)sender value])]; break;
            //        case LanSong_BILATERAL: [(LanSongBilateralFilter *)self.filter setBlurSize:[(UISlider*)sender value]]; break;
        case LanSong_BILATERAL: [(LanSongBilateralFilter *)self.filter setDistanceNormalizationFactor:[(UISlider*)sender value]]; break;
        case LanSong_MOTIONBLUR: [(LanSongMotionBlurFilter *)self.filter setBlurAngle:[(UISlider*)sender value]]; break;
        case LanSong_ZOOMBLUR: [(LanSongZoomBlurFilter *)self.filter setBlurSize:[(UISlider*)sender value]]; break;
        case LanSong_GAUSSIAN_SELECTIVE: [(LanSongGaussianSelectiveBlurFilter *)self.filter setExcludeCircleRadius:[(UISlider*)sender value]]; break;
        case LanSong_GAUSSIAN_POSITION: [(LanSongGaussianBlurPositionFilter *)self.filter setBlurRadius:[(UISlider *)sender value]]; break;
        case LanSong_FILTERGROUP: [(LanSongPixellateFilter *)[(LanSongFilterGroup *)self.filter filterAtIndex:1] setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
      case LanSong_TRANSFORM3D:
        {
            CATransform3D perspectiveTransform = CATransform3DIdentity;
            perspectiveTransform.m34 = 0.4;
            perspectiveTransform.m33 = 0.4;
            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, [(UISlider*)sender value], 0.0, 1.0, 0.0);
            
            [(LanSongTransformFilter *)self.filter setTransform3D:perspectiveTransform];
        }; break;
        case LanSong_TILTSHIFT:
        {
            CGFloat midpoint = [(UISlider *)sender value];
            [(LanSongTiltShiftFilter *)self.filter setTopFocusLevel:midpoint - 0.1];
            [(LanSongTiltShiftFilter *)self.filter setBottomFocusLevel:midpoint + 0.1];
        }; break;
        case LanSong_LOCALBINARYPATTERN:
        {
            CGFloat multiplier = [(UISlider *)sender value];
            [(LanSongLocalBinaryPatternFilter *)self.filter setTexelWidth:(multiplier / self.view.bounds.size.width)];
            [(LanSongLocalBinaryPatternFilter *)self.filter setTexelHeight:(multiplier / self.view.bounds.size.height)];
        }; break;
        default: break;
    }
}
-(void)dealloc
{
    _filterPen=nil;
    _filter=nil;
    
}

@end

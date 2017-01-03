#import "FilterTpyeList.h"


@interface FilterTpyeList ()
{
    GPUImagePicture *sourcePicture;
    GPUImageShowcaseFilterType filterType;
    
    GPUImageFilterPipeline *pipeline;
    
    
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
    if ([GPUImageContext supportsFastTextureUpload])
    {
        return GPUIMAGE_NUMFILTERS;
    }
    else
    {
        return (GPUIMAGE_NUMFILTERS - 1);
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
        case GPUIMAGE_SATURATION: cell.textLabel.text = @"Saturation"; break;
        case GPUIMAGE_CONTRAST: cell.textLabel.text = @"Contrast"; break;
        case GPUIMAGE_BRIGHTNESS: cell.textLabel.text = @"Brightness"; break;
        case GPUIMAGE_LEVELS: cell.textLabel.text = @"Levels"; break;
        case GPUIMAGE_EXPOSURE: cell.textLabel.text = @"Exposure"; break;
        case GPUIMAGE_HUE: cell.textLabel.text = @"Hue"; break;
        case GPUIMAGE_WHITEBALANCE: cell.textLabel.text = @"White balance"; break;
        case GPUIMAGE_MONOCHROME: cell.textLabel.text = @"Monochrome"; break;
        case GPUIMAGE_FALSECOLOR: cell.textLabel.text = @"False color"; break;
        case GPUIMAGE_SHARPEN: cell.textLabel.text = @"Sharpen"; break;
        case GPUIMAGE_UNSHARPMASK: cell.textLabel.text = @"Unsharp mask"; break;
        case GPUIMAGE_GAMMA: cell.textLabel.text = @"Gamma"; break;
        case GPUIMAGE_TONECURVE: cell.textLabel.text = @"Tone curve"; break;
        case GPUIMAGE_HIGHLIGHTSHADOW: cell.textLabel.text = @"Highlights and shadows"; break;
        case GPUIMAGE_HAZE: cell.textLabel.text = @"Haze"; break;
        case GPUIMAGE_HISTOGRAM: cell.textLabel.text = @"Histogram"; break;
        case GPUIMAGE_HISTOGRAM_EQUALIZATION: cell.textLabel.text = @"Histogram Equalization"; break;
        case GPUIMAGE_THRESHOLD: cell.textLabel.text = @"Threshold"; break;
        case GPUIMAGE_ADAPTIVETHRESHOLD: cell.textLabel.text = @"Adaptive threshold"; break;
        case GPUIMAGE_AVERAGELUMINANCETHRESHOLD: cell.textLabel.text = @"Average luminance threshold"; break;
        case GPUIMAGE_CROP: cell.textLabel.text = @"Crop"; break;
        case GPUIMAGE_TRANSFORM3D: cell.textLabel.text = @"Transform (3-D)"; break;
        case GPUIMAGE_MASK: cell.textLabel.text = @"Mask"; break;
        case GPUIMAGE_COLORINVERT: cell.textLabel.text = @"Color invert"; break;
        case GPUIMAGE_GRAYSCALE: cell.textLabel.text = @"Grayscale"; break;
        case GPUIMAGE_SEPIA: cell.textLabel.text = @"Sepia tone"; break;
        case GPUIMAGE_MISSETIKATE: cell.textLabel.text = @"Miss Etikate (Lookup)"; break;
        case GPUIMAGE_SOFTELEGANCE: cell.textLabel.text = @"Soft elegance (Lookup)"; break;
        case GPUIMAGE_AMATORKA: cell.textLabel.text = @"Amatorka (Lookup)"; break;
        case GPUIMAGE_PIXELLATE: cell.textLabel.text = @"Pixellate"; break;
        case GPUIMAGE_POLARPIXELLATE: cell.textLabel.text = @"Polar pixellate"; break;
        case GPUIMAGE_PIXELLATE_POSITION: cell.textLabel.text = @"Pixellate (position)"; break;
        case GPUIMAGE_POLKADOT: cell.textLabel.text = @"Polka dot"; break;
        case GPUIMAGE_HALFTONE: cell.textLabel.text = @"Halftone"; break;
        case GPUIMAGE_CROSSHATCH: cell.textLabel.text = @"Crosshatch"; break;
        case GPUIMAGE_SOBELEDGEDETECTION: cell.textLabel.text = @"Sobel edge detection"; break;
        case GPUIMAGE_PREWITTEDGEDETECTION: cell.textLabel.text = @"Prewitt edge detection"; break;
        case GPUIMAGE_CANNYEDGEDETECTION: cell.textLabel.text = @"Canny edge detection"; break;
        case GPUIMAGE_THRESHOLDEDGEDETECTION: cell.textLabel.text = @"Threshold edge detection"; break;
        case GPUIMAGE_XYGRADIENT: cell.textLabel.text = @"XY derivative"; break;
        case GPUIMAGE_LOWPASS: cell.textLabel.text = @"Low pass"; break;
        case GPUIMAGE_HIGHPASS: cell.textLabel.text = @"High pass"; break;
        case GPUIMAGE_SKETCH: cell.textLabel.text = @"Sketch"; break;
        case GPUIMAGE_THRESHOLDSKETCH: cell.textLabel.text = @"Threshold Sketch"; break;
        case GPUIMAGE_TOON: cell.textLabel.text = @"Toon"; break;
        case GPUIMAGE_SMOOTHTOON: cell.textLabel.text = @"Smooth toon"; break;
        case GPUIMAGE_TILTSHIFT: cell.textLabel.text = @"Tilt shift"; break;
        case GPUIMAGE_CGA: cell.textLabel.text = @"CGA colorspace"; break;
        case GPUIMAGE_CONVOLUTION: cell.textLabel.text = @"3x3 convolution"; break;
        case GPUIMAGE_EMBOSS: cell.textLabel.text = @"Emboss"; break;
        case GPUIMAGE_LAPLACIAN: cell.textLabel.text = @"Laplacian"; break;
        case GPUIMAGE_POSTERIZE: cell.textLabel.text = @"Posterize"; break;
        case GPUIMAGE_SWIRL: cell.textLabel.text = @"Swirl"; break;
        case GPUIMAGE_BULGE: cell.textLabel.text = @"Bulge"; break;
        case GPUIMAGE_PINCH: cell.textLabel.text = @"Pinch"; break;
        case GPUIMAGE_STRETCH: cell.textLabel.text = @"Stretch"; break;
        case GPUIMAGE_DILATION: cell.textLabel.text = @"Dilation"; break;
        case GPUIMAGE_EROSION: cell.textLabel.text = @"Erosion"; break;
        case GPUIMAGE_OPENING: cell.textLabel.text = @"Opening"; break;
        case GPUIMAGE_CLOSING: cell.textLabel.text = @"Closing"; break;
        case GPUIMAGE_PERLINNOISE: cell.textLabel.text = @"Perlin noise"; break;
        case GPUIMAGE_VORONOI: cell.textLabel.text = @"Voronoi"; break;
        case GPUIMAGE_MOSAIC: cell.textLabel.text = @"Mosaic"; break;
        case GPUIMAGE_LOCALBINARYPATTERN: cell.textLabel.text = @"Local binary pattern"; break;
        case GPUIMAGE_CHROMAKEY: cell.textLabel.text = @"Chroma key blend (green)"; break;
        case GPUIMAGE_DISSOLVE: cell.textLabel.text = @"Dissolve blend"; break;
        case GPUIMAGE_SCREENBLEND: cell.textLabel.text = @"Screen blend"; break;
        case GPUIMAGE_COLORBURN: cell.textLabel.text = @"Color burn blend"; break;
        case GPUIMAGE_COLORDODGE: cell.textLabel.text = @"Color dodge blend"; break;
        case GPUIMAGE_LINEARBURN: cell.textLabel.text = @"Linear burn blend"; break;
        case GPUIMAGE_ADD: cell.textLabel.text = @"Add blend"; break;
        case GPUIMAGE_DIVIDE: cell.textLabel.text = @"Divide blend"; break;
        case GPUIMAGE_MULTIPLY: cell.textLabel.text = @"Multiply blend"; break;
        case GPUIMAGE_OVERLAY: cell.textLabel.text = @"Overlay blend"; break;
        case GPUIMAGE_LIGHTEN: cell.textLabel.text = @"Lighten blend"; break;
        case GPUIMAGE_DARKEN: cell.textLabel.text = @"Darken blend"; break;
        case GPUIMAGE_EXCLUSIONBLEND: cell.textLabel.text = @"Exclusion blend"; break;
        case GPUIMAGE_DIFFERENCEBLEND: cell.textLabel.text = @"Difference blend"; break;
        case GPUIMAGE_SUBTRACTBLEND: cell.textLabel.text = @"Subtract blend"; break;
        case GPUIMAGE_HARDLIGHTBLEND: cell.textLabel.text = @"Hard light blend"; break;
        case GPUIMAGE_SOFTLIGHTBLEND: cell.textLabel.text = @"Soft light blend"; break;
        case GPUIMAGE_COLORBLEND: cell.textLabel.text = @"Color blend"; break;
        case GPUIMAGE_HUEBLEND: cell.textLabel.text = @"Hue blend"; break;
        case GPUIMAGE_SATURATIONBLEND: cell.textLabel.text = @"Saturation blend"; break;
        case GPUIMAGE_LUMINOSITYBLEND: cell.textLabel.text = @"Luminosity blend"; break;
        case GPUIMAGE_NORMALBLEND: cell.textLabel.text = @"Normal blend"; break;
        case GPUIMAGE_POISSONBLEND: cell.textLabel.text = @"Poisson blend"; break;
        case GPUIMAGE_KUWAHARA: cell.textLabel.text = @"Kuwahara"; break;
        case GPUIMAGE_KUWAHARARADIUS3: cell.textLabel.text = @"Kuwahara (fixed radius)"; break;
        case GPUIMAGE_VIGNETTE: cell.textLabel.text = @"Vignette"; break;
        case GPUIMAGE_GAUSSIAN: cell.textLabel.text = @"Gaussian blur"; break;
        case GPUIMAGE_MEDIAN: cell.textLabel.text = @"Median (3x3)"; break;
        case GPUIMAGE_BILATERAL: cell.textLabel.text = @"Bilateral blur"; break;
        case GPUIMAGE_MOTIONBLUR: cell.textLabel.text = @"Motion blur"; break;
        case GPUIMAGE_ZOOMBLUR: cell.textLabel.text = @"Zoom blur"; break;
        case GPUIMAGE_BOXBLUR: cell.textLabel.text = @"Box blur"; break;
        case GPUIMAGE_GAUSSIAN_SELECTIVE: cell.textLabel.text = @"Gaussian selective blur"; break;
        case GPUIMAGE_GAUSSIAN_POSITION: cell.textLabel.text = @"Gaussian (centered)"; break;
        case GPUIMAGE_FILTERGROUP: cell.textLabel.text = @"Filter Group"; break;
        case GPUIMAGE_FACES: cell.textLabel.text = @"Face Detection"; break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    filterType=(GPUImageShowcaseFilterType)indexPath.row;
    [self setupFilter]; //更新filter;
    
    [_videoPen switchFilter:_filter];
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
        case GPUIMAGE_SEPIA:
        {
            self.title = @"Sepia Tone";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:1.0];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            
            self.filter = [[GPUImageSepiaFilter alloc] init];
        }; break;
        case GPUIMAGE_PIXELLATE:
        {
            self.title = @"Pixellate";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.05];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:0.3];
            
            self.filter = [[GPUImagePixellateFilter alloc] init];
        }; break;
        case GPUIMAGE_POLARPIXELLATE:
        {
            self.title = @"Polar Pixellate";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.05];
            [self.filterSlider setMinimumValue:-0.1];
            [self.filterSlider setMaximumValue:0.1];
            
            self.filter = [[GPUImagePolarPixellateFilter alloc] init];
        }; break;
        case GPUIMAGE_PIXELLATE_POSITION:
        {
            self.title = @"Pixellate (position)";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.25];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:0.5];
            
            self.filter = [[GPUImagePixellatePositionFilter alloc] init];
        }; break;
        case GPUIMAGE_POLKADOT:
        {
            self.title = @"Polka Dot";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.05];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:0.3];
            
            self.filter = [[GPUImagePolkaDotFilter alloc] init];
        }; break;
        case GPUIMAGE_HALFTONE:
        {
            self.title = @"Halftone";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.01];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:0.05];
            
            self.filter = [[GPUImageHalftoneFilter alloc] init];
        }; break;
        case GPUIMAGE_CROSSHATCH:
        {
            self.title = @"Crosshatch";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.03];
            [self.filterSlider setMinimumValue:0.01];
            [self.filterSlider setMaximumValue:0.06];
            
            self.filter = [[GPUImageCrosshatchFilter alloc] init];
        }; break;
        case GPUIMAGE_COLORINVERT:
        {
            self.title = @"Color Invert";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageColorInvertFilter alloc] init];
        }; break;
        case GPUIMAGE_GRAYSCALE:
        {
            self.title = @"Grayscale";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageGrayscaleFilter alloc] init];
        }; break;
        case GPUIMAGE_MONOCHROME:
        {
            self.title = @"Monochrome";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:1.0];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            
            self.filter = [[GPUImageMonochromeFilter alloc] init];
            [(GPUImageMonochromeFilter *)self.filter setColor:(GPUVector4){0.0f, 0.0f, 1.0f, 1.f}];
        }; break;
        case GPUIMAGE_FALSECOLOR:
        {
            self.title = @"False Color";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageFalseColorFilter alloc] init];
        }; break;
        case GPUIMAGE_SOFTELEGANCE:
        {
            self.title = @"Soft Elegance (Lookup)";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageSoftEleganceFilter alloc] init];
        }; break;
        case GPUIMAGE_MISSETIKATE:
        {
            self.title = @"Miss Etikate (Lookup)";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageMissEtikateFilter alloc] init];
        }; break;
        case GPUIMAGE_AMATORKA:
        {
            self.title = @"Amatorka (Lookup)";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageAmatorkaFilter alloc] init];
        }; break;
            
        case GPUIMAGE_SATURATION:
        {
            self.title = @"Saturation";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:1.0];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:2.0];
            
            self.filter = [[GPUImageSaturationFilter alloc] init];
        }; break;
        case GPUIMAGE_CONTRAST:
        {
            self.title = @"Contrast";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:4.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageContrastFilter alloc] init];
        }; break;
        case GPUIMAGE_BRIGHTNESS:
        {
            self.title = @"Brightness";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-1.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.0];
            
            self.filter = [[GPUImageBrightnessFilter alloc] init];
        }; break;
        case GPUIMAGE_LEVELS:
        {
            self.title = @"Levels";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.0];
            
            self.filter = [[GPUImageLevelsFilter alloc] init];
        }; break;
        case GPUIMAGE_HUE:
        {
            self.title = @"Hue";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:360.0];
            [self.filterSlider setValue:90.0];
            
            self.filter = [[GPUImageHueFilter alloc] init];
        }; break;
        case GPUIMAGE_WHITEBALANCE:
        {
            self.title = @"White Balance";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:2500.0];
            [self.filterSlider setMaximumValue:7500.0];
            [self.filterSlider setValue:5000.0];
            
            self.filter = [[GPUImageWhiteBalanceFilter alloc] init];
        }; break;
        case GPUIMAGE_EXPOSURE:
        {
            self.title = @"Exposure";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-4.0];
            [self.filterSlider setMaximumValue:4.0];
            [self.filterSlider setValue:0.0];
            
            self.filter = [[GPUImageExposureFilter alloc] init];
        }; break;
        case GPUIMAGE_SHARPEN:
        {
            self.title = @"Sharpen";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-1.0];
            [self.filterSlider setMaximumValue:4.0];
            [self.filterSlider setValue:0.0];
            
            self.filter = [[GPUImageSharpenFilter alloc] init];
        }; break;
        case GPUIMAGE_UNSHARPMASK:
        {
            self.title = @"Unsharp Mask";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:5.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageUnsharpMaskFilter alloc] init];
            
            //            [(GPUImageUnsharpMaskFilter *)self.filter setIntensity:3.0];
        }; break;
        case GPUIMAGE_GAMMA:
        {
            self.title = @"Gamma";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:3.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageGammaFilter alloc] init];
        }; break;
        case GPUIMAGE_TONECURVE:
        {
            self.title = @"Tone curve";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[GPUImageToneCurveFilter alloc] init];
            [(GPUImageToneCurveFilter *)self.filter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]];
        }; break;
        case GPUIMAGE_HIGHLIGHTSHADOW:
        {
            self.title = @"Highlights and Shadows";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:1.0];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            
            self.filter = [[GPUImageHighlightShadowFilter alloc] init];
        }; break;
        case GPUIMAGE_HAZE:
        {
            self.title = @"Haze / UV";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-0.2];
            [self.filterSlider setMaximumValue:0.2];
            [self.filterSlider setValue:0.2];
            
            self.filter = [[GPUImageHazeFilter alloc] init];
        }; break;
      
        case GPUIMAGE_HISTOGRAM:
        {
            self.title = @"Histogram";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:4.0];
            [self.filterSlider setMaximumValue:32.0];
            [self.filterSlider setValue:16.0];
            
            self.filter = [[GPUImageHistogramFilter alloc] initWithHistogramType:kGPUImageHistogramRGB];
        }; break;
        case GPUIMAGE_HISTOGRAM_EQUALIZATION:
        {
            self.title = @"Histogram Equalization";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:4.0];
            [self.filterSlider setMaximumValue:32.0];
            [self.filterSlider setValue:16.0];
            
            self.filter = [[GPUImageHistogramEqualizationFilter alloc] initWithHistogramType:kGPUImageHistogramLuminance];
        }; break;
        case GPUIMAGE_THRESHOLD:
        {
            self.title = @"Luminance Threshold";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[GPUImageLuminanceThresholdFilter alloc] init];
        }; break;
        case GPUIMAGE_ADAPTIVETHRESHOLD:
        {
            self.title = @"Adaptive Threshold";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:1.0];
            [self.filterSlider setMaximumValue:20.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageAdaptiveThresholdFilter alloc] init];
        }; break;
        case GPUIMAGE_AVERAGELUMINANCETHRESHOLD:
        {
            self.title = @"Avg. Lum. Threshold";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:2.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageAverageLuminanceThresholdFilter alloc] init];
        }; break;
        case GPUIMAGE_CROP:
        {
            self.title = @"Crop";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.2];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.0, 1.0, 0.25)];
        }; break;
        case GPUIMAGE_MASK:
        {
            self.title = @"Mask";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageMaskFilter alloc] init];
            
            [(GPUImageFilter*)self.filter setBackgroundColorRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        }; break;
        case GPUIMAGE_TRANSFORM3D:
        {
            self.title = @"Transform (3-D)";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:6.28];
            [self.filterSlider setValue:0.75];
            
            self.filter = [[GPUImageTransformFilter alloc] init];
            CATransform3D perspectiveTransform = CATransform3DIdentity;
            perspectiveTransform.m34 = 0.4;
            perspectiveTransform.m33 = 0.4;
            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, 0.75, 0.0, 1.0, 0.0);
            
            [(GPUImageTransformFilter *)self.filter setTransform3D:perspectiveTransform];
        }; break;
        case GPUIMAGE_SOBELEDGEDETECTION:
        {
            self.title = @"Sobel Edge Detection";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.25];
            
            self.filter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
        }; break;
        case GPUIMAGE_XYGRADIENT:
        {
            self.title = @"XY Derivative";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageXYDerivativeFilter alloc] init];
        }; break;
        case GPUIMAGE_PREWITTEDGEDETECTION:
        {
            self.title = @"Prewitt Edge Detection";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImagePrewittEdgeDetectionFilter alloc] init];
        }; break;
        case GPUIMAGE_CANNYEDGEDETECTION:
        {
            self.title = @"Canny Edge Detection";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
        }; break;
        case GPUIMAGE_THRESHOLDEDGEDETECTION:
        {
            self.title = @"Threshold Edge Detection";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.25];
            
            self.filter = [[GPUImageThresholdEdgeDetectionFilter alloc] init];
        }; break;
        case GPUIMAGE_LOCALBINARYPATTERN:
        {
            self.title = @"Local Binary Pattern";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:1.0];
            [self.filterSlider setMaximumValue:5.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageLocalBinaryPatternFilter alloc] init];
        }; break;
        case GPUIMAGE_LOWPASS:
        {
            self.title = @"Low Pass";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[GPUImageLowPassFilter alloc] init];
        }; break;
        case GPUIMAGE_HIGHPASS:
        {
            self.title = @"High Pass";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[GPUImageHighPassFilter alloc] init];
        }; break;
        case GPUIMAGE_SKETCH:
        {
            self.title = @"Sketch";
            self.filterSlider.hidden = NO;
            
            [_filterSlider setMinimumValue:0.0];
            [_filterSlider setMaximumValue:1.0];
            [_filterSlider setValue:0.25];
           
            
            self.filter = [[GPUImageSketchFilter alloc] init];
        }; break;
        case GPUIMAGE_THRESHOLDSKETCH:
        {
            self.title = @"Threshold Sketch";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.25];
            
            self.filter = [[GPUImageThresholdSketchFilter alloc] init];
        }; break;
        case GPUIMAGE_TOON:
        {
            self.title = @"Toon";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageToonFilter alloc] init];
        }; break;
        case GPUIMAGE_SMOOTHTOON:
        {
            self.title = @"Smooth Toon";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:1.0];
            [self.filterSlider setMaximumValue:6.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageSmoothToonFilter alloc] init];
        }; break;
        case GPUIMAGE_TILTSHIFT:
        {
            self.title = @"Tilt Shift";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.2];
            [self.filterSlider setMaximumValue:0.8];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[GPUImageTiltShiftFilter alloc] init];
            [(GPUImageTiltShiftFilter *)self.filter setTopFocusLevel:0.4];
            [(GPUImageTiltShiftFilter *)self.filter setBottomFocusLevel:0.6];
            [(GPUImageTiltShiftFilter *)self.filter setFocusFallOffRate:0.2];
        }; break;
        case GPUIMAGE_CGA:
        {
            self.title = @"CGA Colorspace";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageCGAColorspaceFilter alloc] init];
        }; break;
        case GPUIMAGE_CONVOLUTION:
        {
            self.title = @"3x3 Convolution";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImage3x3ConvolutionFilter alloc] init];
            //            [(GPUImage3x3ConvolutionFilter *)self.filter setConvolutionKernel:(GPUMatrix3x3){
            //                {-2.0f, -1.0f, 0.0f},
            //                {-1.0f,  1.0f, 1.0f},
            //                { 0.0f,  1.0f, 2.0f}
            //            }];
            [(GPUImage3x3ConvolutionFilter *)self.filter setConvolutionKernel:(GPUMatrix3x3){
                {-1.0f,  0.0f, 1.0f},
                {-2.0f, 0.0f, 2.0f},
                {-1.0f,  0.0f, 1.0f}
            }];
            
            //            [(GPUImage3x3ConvolutionFilter *)self.filter setConvolutionKernel:(GPUMatrix3x3){
            //                {1.0f,  1.0f, 1.0f},
            //                {1.0f, -8.0f, 1.0f},
            //                {1.0f,  1.0f, 1.0f}
            //            }];
            //            [(GPUImage3x3ConvolutionFilter *)self.filter setConvolutionKernel:(GPUMatrix3x3){
            //                { 0.11f,  0.11f, 0.11f},
            //                { 0.11f,  0.11f, 0.11f},
            //                { 0.11f,  0.11f, 0.11f}
            //            }];
        }; break;
        case GPUIMAGE_EMBOSS:
        {
            self.title = @"Emboss";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:5.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageEmbossFilter alloc] init];
        }; break;
        case GPUIMAGE_LAPLACIAN:
        {
            self.title = @"Laplacian";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageLaplacianFilter alloc] init];
        }; break;
        case GPUIMAGE_POSTERIZE:
        {
            self.title = @"Posterize";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:1.0];
            [self.filterSlider setMaximumValue:20.0];
            [self.filterSlider setValue:10.0];
            
            self.filter = [[GPUImagePosterizeFilter alloc] init];
        }; break;
        case GPUIMAGE_SWIRL:
        {
            self.title = @"Swirl";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:2.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageSwirlFilter alloc] init];
        }; break;
        case GPUIMAGE_BULGE:
        {
            self.title = @"Bulge";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-1.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[GPUImageBulgeDistortionFilter alloc] init];
        }; break;
        case GPUIMAGE_PINCH:
        {
            self.title = @"Pinch";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:-2.0];
            [self.filterSlider setMaximumValue:2.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[GPUImagePinchDistortionFilter alloc] init];
        }; break;
        case GPUIMAGE_STRETCH:
        {
            self.title = @"Stretch";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageStretchDistortionFilter alloc] init];
        }; break;
        case GPUIMAGE_DILATION:
        {
            self.title = @"Dilation";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageRGBDilationFilter alloc] initWithRadius:4];
        }; break;
        case GPUIMAGE_EROSION:
        {
            self.title = @"Erosion";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageRGBErosionFilter alloc] initWithRadius:4];
        }; break;
        case GPUIMAGE_OPENING:
        {
            self.title = @"Opening";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageRGBOpeningFilter alloc] initWithRadius:4];
        }; break;
        case GPUIMAGE_CLOSING:
        {
            self.title = @"Closing";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageRGBClosingFilter alloc] initWithRadius:4];
        }; break;
            
        case GPUIMAGE_PERLINNOISE:
        {
            self.title = @"Perlin Noise";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:1.0];
            [self.filterSlider setMaximumValue:30.0];
            [self.filterSlider setValue:8.0];
            
            self.filter = [[GPUImagePerlinNoiseFilter alloc] init];
        }; break;
        case GPUIMAGE_MOSAIC:
        {
            self.title = @"Mosaic";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.002];
            [self.filterSlider setMaximumValue:0.05];
            [self.filterSlider setValue:0.025];
            
            self.filter = [[GPUImageMosaicFilter alloc] init];
            [(GPUImageMosaicFilter *)self.filter setTileSet:@"squares.png"];
            [(GPUImageMosaicFilter *)self.filter setColorOn:NO];
            //[(GPUImageMosaicFilter *)self.filter setTileSet:@"dotletterstiles.png"];
            //[(GPUImageMosaicFilter *)self.filter setTileSet:@"curvies.png"];
            
        }; break;
        case GPUIMAGE_CHROMAKEY:
        {
            self.title = @"Chroma Key (Green)";
            self.filterSlider.hidden = NO;
            needsSecondImage = YES;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.4];
            
            self.filter = [[GPUImageChromaKeyBlendFilter alloc] init];
            [(GPUImageChromaKeyBlendFilter *)self.filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
        }; break;
        case GPUIMAGE_ADD:
        {
            self.title = @"Add Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageAddBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_DIVIDE:
        {
            self.title = @"Divide Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageDivideBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_MULTIPLY:
        {
            self.title = @"Multiply Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageMultiplyBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_OVERLAY:
        {
            self.title = @"Overlay Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageOverlayBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_LIGHTEN:
        {
            self.title = @"Lighten Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageLightenBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_DARKEN:
        {
            self.title = @"Darken Blend";
            self.filterSlider.hidden = YES;
            
            needsSecondImage = YES;
            self.filter = [[GPUImageDarkenBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_DISSOLVE:
        {
            self.title = @"Dissolve Blend";
            self.filterSlider.hidden = NO;
            needsSecondImage = YES;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[GPUImageDissolveBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_SCREENBLEND:
        {
            self.title = @"Screen Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageScreenBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_COLORBURN:
        {
            self.title = @"Color Burn Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageColorBurnBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_COLORDODGE:
        {
            self.title = @"Color Dodge Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageColorDodgeBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_LINEARBURN:
        {
            self.title = @"Linear Burn Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageLinearBurnBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_EXCLUSIONBLEND:
        {
            self.title = @"Exclusion Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageExclusionBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_DIFFERENCEBLEND:
        {
            self.title = @"Difference Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageDifferenceBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_SUBTRACTBLEND:
        {
            self.title = @"Subtract Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageSubtractBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_HARDLIGHTBLEND:
        {
            self.title = @"Hard Light Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageHardLightBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_SOFTLIGHTBLEND:
        {
            self.title = @"Soft Light Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageSoftLightBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_COLORBLEND:
        {
            self.title = @"Color Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageColorBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_HUEBLEND:
        {
            self.title = @"Hue Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageHueBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_SATURATIONBLEND:
        {
            self.title = @"Saturation Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageSaturationBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_LUMINOSITYBLEND:
        {
            self.title = @"Luminosity Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageLuminosityBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_NORMALBLEND:
        {
            self.title = @"Normal Blend";
            self.filterSlider.hidden = YES;
            needsSecondImage = YES;
            
            self.filter = [[GPUImageNormalBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_POISSONBLEND:
        {
            self.title = @"Poisson Blend";
            self.filterSlider.hidden = NO;
            needsSecondImage = YES;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:1.0];
            [self.filterSlider setValue:0.5];
            
            self.filter = [[GPUImagePoissonBlendFilter alloc] init];
        }; break;
        case GPUIMAGE_KUWAHARA:
        {
            self.title = @"Kuwahara";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:3.0];
            [self.filterSlider setMaximumValue:8.0];
            [self.filterSlider setValue:3.0];
            
            self.filter = [[GPUImageKuwaharaFilter alloc] init];
        }; break;
        case GPUIMAGE_KUWAHARARADIUS3:
        {
            self.title = @"Kuwahara (Radius 3)";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageKuwaharaRadius3Filter alloc] init];
        }; break;
        case GPUIMAGE_VIGNETTE:
        {
            self.title = @"Vignette";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.5];
            [self.filterSlider setMaximumValue:0.9];
            [self.filterSlider setValue:0.75];
            
            self.filter = [[GPUImageVignetteFilter alloc] init];
        }; break;
        case GPUIMAGE_GAUSSIAN:
        {
            self.title = @"Gaussian Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:24.0];
            [self.filterSlider setValue:2.0];
            
            self.filter = [[GPUImageGaussianBlurFilter alloc] init];
        }; break;
        case GPUIMAGE_BOXBLUR:
        {
            self.title = @"Box Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:24.0];
            [self.filterSlider setValue:2.0];
            
            self.filter = [[GPUImageBoxBlurFilter alloc] init];
        }; break;
        case GPUIMAGE_MEDIAN:
        {
            self.title = @"Median";
            self.filterSlider.hidden = YES;
            
            self.filter = [[GPUImageMedianFilter alloc] init];
        }; break;
        case GPUIMAGE_MOTIONBLUR:
        {
            self.title = @"Motion Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:180.0f];
            [self.filterSlider setValue:0.0];
            
            self.filter = [[GPUImageMotionBlurFilter alloc] init];
        }; break;
        case GPUIMAGE_ZOOMBLUR:
        {
            self.title = @"Zoom Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:2.5f];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageZoomBlurFilter alloc] init];
        }; break;
       case GPUIMAGE_GAUSSIAN_SELECTIVE:
        {
            self.title = @"Selective Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:.75f];
            [self.filterSlider setValue:40.0/320.0];
            
            self.filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
            [(GPUImageGaussianSelectiveBlurFilter*)self.filter setExcludeCircleRadius:40.0/320.0];
        }; break;
        case GPUIMAGE_GAUSSIAN_POSITION:
        {
            self.title = @"Selective Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:.75f];
            [self.filterSlider setValue:40.0/320.0];
            
            self.filter = [[GPUImageGaussianBlurPositionFilter alloc] init];
            [(GPUImageGaussianBlurPositionFilter*)self.filter setBlurRadius:40.0/320.0];
        }; break;
        case GPUIMAGE_BILATERAL:
        {
            self.title = @"Bilateral Blur";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:10.0];
            [self.filterSlider setValue:1.0];
            
            self.filter = [[GPUImageBilateralFilter alloc] init];
        }; break;
        case GPUIMAGE_FILTERGROUP:
        {
            self.title = @"Filter Group";
            self.filterSlider.hidden = NO;
            
            [self.filterSlider setValue:0.05];
            [self.filterSlider setMinimumValue:0.0];
            [self.filterSlider setMaximumValue:0.3];
            
            self.filter = [[GPUImageFilterGroup alloc] init];
            
            GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
            [(GPUImageFilterGroup *)self.filter addFilter:sepiaFilter];
            
            GPUImagePixellateFilter *pixellateFilter = [[GPUImagePixellateFilter alloc] init];
            [(GPUImageFilterGroup *)self.filter addFilter:pixellateFilter];
            
            [sepiaFilter addTarget:pixellateFilter];
            [(GPUImageFilterGroup *)self.filter setInitialFilters:[NSArray arrayWithObject:sepiaFilter]];
            [(GPUImageFilterGroup *)self.filter setTerminalFilter:pixellateFilter];
        }; break;
        default: self.filter = [[GPUImageSepiaFilter alloc] init]; break;
    }
        //对上面的的补充.
        if (needsSecondImage)
        {
            UIImage *inputImage;
            
            if (filterType == GPUIMAGE_MASK)
            {
                inputImage = [UIImage imageNamed:@"mask"];
            }
            else {
                inputImage = [UIImage imageNamed:@"WID-small.jpg"];
            }
            
            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
            [sourcePicture processImage];  //图片在这里得到处理.
            
            [sourcePicture addTarget:self.filter];  //把这个图片放到了 TWOInputFilter中的了, 怎样起到glblendFunc的作用呢????
        }
}
     
/**
   当slider滑动时调用这里,更改相关效果.

 @param sender <#sender description#>
 */
- (void)updateFilterFromSlider:(UISlider *)sender;
{
    switch(filterType)
    {
        case GPUIMAGE_SEPIA: [(GPUImageSepiaFilter *)self.filter setIntensity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_PIXELLATE: [(GPUImagePixellateFilter *)self.filter setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case GPUIMAGE_POLARPIXELLATE: [(GPUImagePolarPixellateFilter *)self.filter setPixelSize:CGSizeMake([(UISlider *)sender value], [(UISlider *)sender value])]; break;
        case GPUIMAGE_PIXELLATE_POSITION: [(GPUImagePixellatePositionFilter *)self.filter setRadius:[(UISlider *)sender value]]; break;
        case GPUIMAGE_POLKADOT: [(GPUImagePolkaDotFilter *)self.filter setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case GPUIMAGE_HALFTONE: [(GPUImageHalftoneFilter *)self.filter setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case GPUIMAGE_SATURATION: [(GPUImageSaturationFilter *)self.filter setSaturation:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CONTRAST: [(GPUImageContrastFilter *)self.filter setContrast:[(UISlider *)sender value]]; break;
        case GPUIMAGE_BRIGHTNESS: [(GPUImageBrightnessFilter *)self.filter setBrightness:[(UISlider *)sender value]]; break;
        case GPUIMAGE_LEVELS: {
            float value = [(UISlider *)sender value];
            [(GPUImageLevelsFilter *)self.filter setRedMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
            [(GPUImageLevelsFilter *)self.filter setGreenMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
            [(GPUImageLevelsFilter *)self.filter setBlueMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
        }; break;
        case GPUIMAGE_EXPOSURE: [(GPUImageExposureFilter *)self.filter setExposure:[(UISlider *)sender value]]; break;
        case GPUIMAGE_MONOCHROME: [(GPUImageMonochromeFilter *)self.filter setIntensity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_HUE: [(GPUImageHueFilter *)self.filter setHue:[(UISlider *)sender value]]; break;
        case GPUIMAGE_WHITEBALANCE: [(GPUImageWhiteBalanceFilter *)self.filter setTemperature:[(UISlider *)sender value]]; break;
        case GPUIMAGE_SHARPEN: [(GPUImageSharpenFilter *)self.filter setSharpness:[(UISlider *)sender value]]; break;
        case GPUIMAGE_HISTOGRAM: [(GPUImageHistogramFilter *)self.filter setDownsamplingFactor:round([(UISlider *)sender value])]; break;
        case GPUIMAGE_HISTOGRAM_EQUALIZATION: [(GPUImageHistogramEqualizationFilter *)self.filter setDownsamplingFactor:round([(UISlider *)sender value])]; break;
        case GPUIMAGE_UNSHARPMASK: [(GPUImageUnsharpMaskFilter *)self.filter setIntensity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_GAMMA: [(GPUImageGammaFilter *)self.filter setGamma:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CROSSHATCH: [(GPUImageCrosshatchFilter *)self.filter setCrossHatchSpacing:[(UISlider *)sender value]]; break;
        case GPUIMAGE_POSTERIZE: [(GPUImagePosterizeFilter *)self.filter setColorLevels:round([(UISlider*)sender value])]; break;
        case GPUIMAGE_HAZE: [(GPUImageHazeFilter *)self.filter setDistance:[(UISlider *)sender value]]; break;
        case GPUIMAGE_SOBELEDGEDETECTION: [(GPUImageSobelEdgeDetectionFilter *)self.filter setEdgeStrength:[(UISlider *)sender value]]; break;
        case GPUIMAGE_PREWITTEDGEDETECTION: [(GPUImagePrewittEdgeDetectionFilter *)self.filter setEdgeStrength:[(UISlider *)sender value]]; break;
        case GPUIMAGE_SKETCH: [(GPUImageSketchFilter *)self.filter setEdgeStrength:[(UISlider *)sender value]]; break;
        case GPUIMAGE_THRESHOLD: [(GPUImageLuminanceThresholdFilter *)self.filter setThreshold:[(UISlider *)sender value]]; break;
        case GPUIMAGE_ADAPTIVETHRESHOLD: [(GPUImageAdaptiveThresholdFilter *)self.filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
        case GPUIMAGE_AVERAGELUMINANCETHRESHOLD: [(GPUImageAverageLuminanceThresholdFilter *)self.filter setThresholdMultiplier:[(UISlider *)sender value]]; break;
        case GPUIMAGE_DISSOLVE: [(GPUImageDissolveBlendFilter *)self.filter setMix:[(UISlider *)sender value]]; break;
        case GPUIMAGE_POISSONBLEND: [(GPUImagePoissonBlendFilter *)self.filter setMix:[(UISlider *)sender value]]; break;
        case GPUIMAGE_LOWPASS: [(GPUImageLowPassFilter *)self.filter setFilterStrength:[(UISlider *)sender value]]; break;
        case GPUIMAGE_HIGHPASS: [(GPUImageHighPassFilter *)self.filter setFilterStrength:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CHROMAKEY: [(GPUImageChromaKeyBlendFilter *)self.filter setThresholdSensitivity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_KUWAHARA: [(GPUImageKuwaharaFilter *)self.filter setRadius:round([(UISlider *)sender value])]; break;
        case GPUIMAGE_SWIRL: [(GPUImageSwirlFilter *)self.filter setAngle:[(UISlider *)sender value]]; break;
        case GPUIMAGE_EMBOSS: [(GPUImageEmbossFilter *)self.filter setIntensity:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CANNYEDGEDETECTION: [(GPUImageCannyEdgeDetectionFilter *)self.filter setBlurTexelSpacingMultiplier:[(UISlider*)sender value]]; break;
        case GPUIMAGE_THRESHOLDEDGEDETECTION: [(GPUImageThresholdEdgeDetectionFilter *)self.filter setThreshold:[(UISlider *)sender value]]; break;
        case GPUIMAGE_SMOOTHTOON: [(GPUImageSmoothToonFilter *)self.filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
        case GPUIMAGE_THRESHOLDSKETCH: [(GPUImageThresholdSketchFilter *)self.filter setThreshold:[(UISlider *)sender value]]; break;
        case GPUIMAGE_BULGE: [(GPUImageBulgeDistortionFilter *)self.filter setScale:[(UISlider *)sender value]]; break;
        case GPUIMAGE_TONECURVE: [(GPUImageToneCurveFilter *)self.filter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, [(UISlider *)sender value])], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]]; break;
        case GPUIMAGE_HIGHLIGHTSHADOW: [(GPUImageHighlightShadowFilter *)self.filter setHighlights:[(UISlider *)sender value]]; break;
        case GPUIMAGE_PINCH: [(GPUImagePinchDistortionFilter *)self.filter setScale:[(UISlider *)sender value]]; break;
        case GPUIMAGE_PERLINNOISE:  [(GPUImagePerlinNoiseFilter *)self.filter setScale:[(UISlider *)sender value]]; break;
        case GPUIMAGE_MOSAIC:  [(GPUImageMosaicFilter *)self.filter setDisplayTileSize:CGSizeMake([(UISlider *)sender value], [(UISlider *)sender value])]; break;
        case GPUIMAGE_VIGNETTE: [(GPUImageVignetteFilter *)self.filter setVignetteEnd:[(UISlider *)sender value]]; break;
        case GPUIMAGE_BOXBLUR: [(GPUImageBoxBlurFilter *)self.filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
        case GPUIMAGE_GAUSSIAN: [(GPUImageGaussianBlurFilter *)self.filter setBlurRadiusInPixels:[(UISlider*)sender value]]; break;
            //        case GPUIMAGE_GAUSSIAN: [(GPUImageGaussianBlurFilter *)self.filter setBlurPasses:round([(UISlider*)sender value])]; break;
            //        case GPUIMAGE_BILATERAL: [(GPUImageBilateralFilter *)self.filter setBlurSize:[(UISlider*)sender value]]; break;
        case GPUIMAGE_BILATERAL: [(GPUImageBilateralFilter *)self.filter setDistanceNormalizationFactor:[(UISlider*)sender value]]; break;
        case GPUIMAGE_MOTIONBLUR: [(GPUImageMotionBlurFilter *)self.filter setBlurAngle:[(UISlider*)sender value]]; break;
        case GPUIMAGE_ZOOMBLUR: [(GPUImageZoomBlurFilter *)self.filter setBlurSize:[(UISlider*)sender value]]; break;
        case GPUIMAGE_GAUSSIAN_SELECTIVE: [(GPUImageGaussianSelectiveBlurFilter *)self.filter setExcludeCircleRadius:[(UISlider*)sender value]]; break;
        case GPUIMAGE_GAUSSIAN_POSITION: [(GPUImageGaussianBlurPositionFilter *)self.filter setBlurRadius:[(UISlider *)sender value]]; break;
        case GPUIMAGE_FILTERGROUP: [(GPUImagePixellateFilter *)[(GPUImageFilterGroup *)self.filter filterAtIndex:1] setFractionalWidthOfAPixel:[(UISlider *)sender value]]; break;
        case GPUIMAGE_CROP: [(GPUImageCropFilter *)self.filter setCropRegion:CGRectMake(0.0, 0.0, 1.0, [(UISlider*)sender value])]; break;
      case GPUIMAGE_TRANSFORM3D:
        {
            CATransform3D perspectiveTransform = CATransform3DIdentity;
            perspectiveTransform.m34 = 0.4;
            perspectiveTransform.m33 = 0.4;
            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, [(UISlider*)sender value], 0.0, 1.0, 0.0);
            
            [(GPUImageTransformFilter *)self.filter setTransform3D:perspectiveTransform];
        }; break;
        case GPUIMAGE_TILTSHIFT:
        {
            CGFloat midpoint = [(UISlider *)sender value];
            [(GPUImageTiltShiftFilter *)self.filter setTopFocusLevel:midpoint - 0.1];
            [(GPUImageTiltShiftFilter *)self.filter setBottomFocusLevel:midpoint + 0.1];
        }; break;
        case GPUIMAGE_LOCALBINARYPATTERN:
        {
            CGFloat multiplier = [(UISlider *)sender value];
            [(GPUImageLocalBinaryPatternFilter *)self.filter setTexelWidth:(multiplier / self.view.bounds.size.width)];
            [(GPUImageLocalBinaryPatternFilter *)self.filter setTexelHeight:(multiplier / self.view.bounds.size.height)];
        }; break;
        default: break;
    }
}

@end

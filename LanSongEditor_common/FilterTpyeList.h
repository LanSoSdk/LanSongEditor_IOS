#import <UIKit/UIKit.h>
#import <LanSongEditorFramework/LanSongEditor.h>
/**
 增加美颜,无等滤镜
 增加InstaFilter, 17个.
 */
typedef enum {
    LanSong_NULL,
    LanSong_BEAUTY,
    
    LanSong_IF1977,
    LanSong_IFAmaro,
    LanSong_IFBrannan,
    LanSong_IFEarlybird,
    LanSong_IFHefe,
    LanSong_IFHudson,
    LanSong_IFInkwell,
    LanSong_IFLomofi,
    LanSong_IFNashville,
    LanSong_IFRise,
    LanSong_IFSierra,
    LanSong_IFSutro,
    LanSong_IFToaster,
    LanSong_IFValencia,
    LanSong_IFWalden,
    LanSong_IFXproII,
    LanSong_IFLordKelvin,
    
    LanSong_SATURATION,
    LanSong_CONTRAST,
    LanSong_BRIGHTNESS,
    LanSong_LEVELS,
    LanSong_EXPOSURE,
    LanSong_HUE,
    LanSong_WHITEBALANCE,
    LanSong_MONOCHROME,
    LanSong_FALSECOLOR,
    LanSong_SHARPEN,
    LanSong_UNSHARPMASK,
    LanSong_TRANSFORM3D,
    LanSong_GAMMA,
    LanSong_TONECURVE,
    LanSong_HIGHLIGHTSHADOW,
    LanSong_HAZE,
    LanSong_SEPIA,
    LanSong_AMATORKA,
    LanSong_MISSETIKATE,
    LanSong_SOFTELEGANCE,
    LanSong_COLORINVERT,
    LanSong_GRAYSCALE,
    LanSong_HISTOGRAM,
    LanSong_HISTOGRAM_EQUALIZATION,
    LanSong_THRESHOLD,
    LanSong_ADAPTIVETHRESHOLD,
    LanSong_AVERAGELUMINANCETHRESHOLD,
    LanSong_PIXELLATE,
    LanSong_POLARPIXELLATE,
    LanSong_PIXELLATE_POSITION,
    LanSong_POLKADOT,
    LanSong_HALFTONE,
    LanSong_CROSSHATCH,
    LanSong_SOBELEDGEDETECTION,
    LanSong_PREWITTEDGEDETECTION,
    LanSong_CANNYEDGEDETECTION,
    LanSong_THRESHOLDEDGEDETECTION,
    LanSong_XYGRADIENT,
    LanSong_LOWPASS,
    LanSong_HIGHPASS,
    LanSong_SKETCH,
    LanSong_THRESHOLDSKETCH,
    LanSong_TOON,
    LanSong_SMOOTHTOON,
    LanSong_TILTSHIFT,
    LanSong_CGA,
    LanSong_POSTERIZE,
    LanSong_CONVOLUTION,
    LanSong_EMBOSS,
    LanSong_LAPLACIAN,
    LanSong_KUWAHARA,
    LanSong_KUWAHARARADIUS3,
    LanSong_VIGNETTE,
    LanSong_GAUSSIAN,
    LanSong_GAUSSIAN_SELECTIVE,
    LanSong_GAUSSIAN_POSITION,
    LanSong_BOXBLUR,
    LanSong_MEDIAN,
    LanSong_BILATERAL,
    LanSong_MOTIONBLUR,
    LanSong_ZOOMBLUR,
    LanSong_SWIRL,
    LanSong_BULGE,
    LanSong_PINCH,
    LanSong_STRETCH,
    LanSong_DILATION,
    LanSong_EROSION,
    LanSong_OPENING,
    LanSong_CLOSING,
    LanSong_PERLINNOISE,
    LanSong_VORONOI,
    LanSong_MOSAIC,
    LanSong_LOCALBINARYPATTERN,
    LanSong_DISSOLVE,
    LanSong_CHROMAKEY,
    LanSong_ADD,
    LanSong_DIVIDE,
    LanSong_MULTIPLY,
    LanSong_OVERLAY,
    LanSong_LIGHTEN,
    LanSong_DARKEN,
    LanSong_COLORBURN,
    LanSong_COLORDODGE,
    LanSong_LINEARBURN,
    LanSong_SCREENBLEND,
    LanSong_DIFFERENCEBLEND,
    LanSong_SUBTRACTBLEND,
    LanSong_EXCLUSIONBLEND,
    LanSong_HARDLIGHTBLEND,
    LanSong_SOFTLIGHTBLEND,
    LanSong_COLORBLEND,
    LanSong_HUEBLEND,
    LanSong_SATURATIONBLEND,
    LanSong_LUMINOSITYBLEND,
    LanSong_NORMALBLEND,
    LanSong_POISSONBLEND,
    LanSong_FILTERGROUP,
    LanSong_FACES,
    LanSong_NUMFILTERS
} LanSongShowcaseFilterType;

@interface FilterTpyeList : UITableViewController

@property UISlider *filterSlider;


/**
 当前选中的滤镜
 */
@property LanSongOutput <LanSongInput> *selectedFilter;


@property LSOPen *filterPen;
/**
 当slider滑动时调用这里,更改相关效果.
 */
- (void)updateFilterFromSlider:(UISlider *)sender;

@end

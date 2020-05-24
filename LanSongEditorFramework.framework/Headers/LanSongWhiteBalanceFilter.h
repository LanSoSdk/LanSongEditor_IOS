#import "LanSongFilter.h"
/**
 * Created by Alaric Cole
 * Allows adjustment of color temperature in terms of what an image was effectively shot in.
 * This means higher Kelvin values will warm the image, while lower values will cool it.
 
 */
@interface LanSongWhiteBalanceFilter : LanSongFilter
{
    GLint temperatureUniform, tintUniform;
}
/**
 choose color temperature, in degrees Kelvin
 默认是5000 ,建议最小是0, 最大是15000;
 色温.
 */

@property(nonatomic,readonly) CGFloat minTemperatureValue;
@property(nonatomic,readonly) CGFloat maxTemperatureValue;
@property(nonatomic,readonly) CGFloat defaultTemperatureValue;


@property(readwrite, nonatomic) CGFloat temperature;

/**
 adjust tint to compensate
 色调.
 setTint(float) 色调, 默认是0; 建议最小是-200, 最大是200;
 */
@property(readwrite, nonatomic) CGFloat tint;

@property(nonatomic,readonly) CGFloat minTintValue;
@property(nonatomic,readonly) CGFloat maxTintValue;
@property(nonatomic,readonly) CGFloat defaultTintValue;


@end

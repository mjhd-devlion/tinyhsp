//
//  MyCALayer.h
//  objc-calayer-example
//
//  Created by dolphilia on 2016/02/01.
//  Copyright © 2016年 dolphilia. All rights reserved.
//

#ifndef MyCALayer_h
#define MyCALayer_h

#import "AppDelegate.h"
#import "utility_picture.h"
#import "utility_pixel.h"
#import <Accelerate/Accelerate.h>
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface MyCALayer : CALayer {
    
@private
    AppDelegate* g; //"g"lobal
    int window_id;  //対応するウィンドウID
    int samplesPerPixel;
    BOOL is_redraw_just_now;
    
@public
    uint8_t* pixel_data;
    int32_t screen_width;
    int32_t screen_height;
    
    Color current_color;
    _Point current_point;
    NSString* font_name;           //フォント関連
    int font_size;
    int font_style;
}

- (void)update_contents_with_cgimage:(CGImageRef)image;
- (void)redraw;
- (void)get_pixel_color:(int)point_x point_y:(int)point_y;
- (int)get_current_point_x;
- (int)get_current_point_y;
- (UInt8)get_current_color_r;
- (UInt8)get_current_color_g;
- (UInt8)get_current_color_b;
- (UInt8)get_current_color_a;
- (void)set_window_id:(int)p1;
- (void)set_redraw_flag:(BOOL)flag;
- (void)set_font:(NSString*)name size:(int)size style:(int)style;
- (void)set_color_rgba:(int)red
                 green:(int)green
                  blue:(int)blue
                 alpha:(int)alpha;
- (void)set_current_point:(int)point_x point_y:(int)point_y;
- (void)clear_canvas:(int)color_number;
- (void)set_pixel_rgba:(int)point_x point_y:(int)point_y;
- (void)set_line_rgba:(int)start_point_x
        start_point_y:(int)start_point_y
          end_point_x:(int)end_point_x
          end_point_y:(int)end_point_y;
- (void)set_rect_line_rgba:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2;
- (void)fill_rect_rgba:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2;
- (void)fill_rect_rgba_slow:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2;
- (void)set_circle_rgba:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2;
- (void)fill_circle_rgba:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2;
- (void)mes:(NSString*)text;
- (NSSize)picload:(NSString*)filename;
- (NSSize)picload:(NSString*)filename mode:(int)mode;

@end

#endif /* MyCALayer_h */

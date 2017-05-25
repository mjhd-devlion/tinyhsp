//
//  MyCALayer.m
//  objc-calayer-example
//
//  Created by dolphilia on 2016/02/01.
//  Copyright © 2016年 dolphilia. All rights reserved.
//

#import "MyCALayer.h"
#import <Foundation/Foundation.h>

#define BUFFER_MAX_WIDTH 2500
#define BUFFER_MAX_HEIGHT 2500
#define BUFFER_HAS_ALPHA YES

@implementation MyCALayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        g = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        
        samplesPerPixel = 4; //ピクセル数(3 = RGB, 4 = RGBA)
        
        screen_width = 640;
        screen_height = 480;
        pixel_data = calloc(screen_width * screen_height * samplesPerPixel, sizeof(UInt8));
        
        font_name = @"";
        font_size = 12;
        font_style = 0;
        
        is_redraw_just_now = YES;
        
        //設定の初期化
        [self clear_canvas:0];
        [self set_color_rgba:0 green:0 blue:0 alpha:255];
        [self redraw];
        
        ////タイマー
        // NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
        // arget:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        //[myTimer fire];
    }
    return self;
}

- (void)update_contents_with_cgimage:(CGImageRef)image
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    self.contents = (__bridge id _Nullable)image;
    [CATransaction commit];
}

- (void)redraw
{
    if (g.backing_scale_factor == 0.0) {
        return;
    }
    // g.backing_scale_factor = 2.0;
    NSBitmapImageRep* bip;
    if (g.backing_scale_factor == 2.0) {
        int width = screen_width;
        int height = screen_height;
        int h_mul = width * 2 * samplesPerPixel;
        
        unsigned char* retina_pixel_data = calloc(
                                                  width * 2 * height * 2 * samplesPerPixel * 4, sizeof(unsigned char));
        int i = 0;
        for (int y = 0; y < height * 2; y += 2) {
            for (int x = 0; x < width * 2 * samplesPerPixel; x += 8) {
                memcpy(&retina_pixel_data[x + h_mul * y], &pixel_data[i],
                       sizeof(unsigned char) * 4);
                memcpy(&retina_pixel_data[x + 4 + h_mul * y], &pixel_data[i],
                       sizeof(unsigned char) * 4);
                memcpy(&retina_pixel_data[x + h_mul * (y + 1)], &pixel_data[i],
                       sizeof(unsigned char) * 4);
                memcpy(&retina_pixel_data[x + 4 + h_mul * (y + 1)], &pixel_data[i],
                       sizeof(unsigned char) * 4);
                i += 4;
            }
        }
        
        bip = [[NSBitmapImageRep alloc]
               initWithBitmapDataPlanes:&retina_pixel_data
               pixelsWide:screen_width * 2
               pixelsHigh:screen_height * 2
               bitsPerSample:8
               samplesPerPixel:samplesPerPixel
               hasAlpha:YES
               isPlanar:NO
               colorSpaceName:NSDeviceRGBColorSpace
               bytesPerRow:screen_width * 2 * samplesPerPixel
               bitsPerPixel:samplesPerPixel * 8];
        free(retina_pixel_data);
    } else {
        bip = [[NSBitmapImageRep alloc]
               initWithBitmapDataPlanes:&pixel_data
               pixelsWide:screen_width
               pixelsHigh:screen_height
               bitsPerSample:8
               samplesPerPixel:samplesPerPixel
               hasAlpha:YES
               isPlanar:NO
               colorSpaceName:NSDeviceRGBColorSpace
               bytesPerRow:screen_width * samplesPerPixel
               bitsPerPixel:samplesPerPixel * 8];
    }
    
    [self update_contents_with_cgimage:[bip CGImage]];
}

//----

- (int)get_current_point_x
{
    return current_point.x;
}

- (int)get_current_point_y
{
    return current_point.y;
}

- (UInt8)get_current_color_r
{
    return current_color.red;
}

- (UInt8)get_current_color_g
{
    return current_color.green;
}

- (UInt8)get_current_color_b
{
    return current_color.blue;
}

- (UInt8)get_current_color_a
{
    return current_color.alpha;
}

- (void)get_pixel_color:(int)point_x point_y:(int)point_y
{
    Color color = get_pixel_color(pixel_data, point_x, point_y,
                                  screen_width, screen_height);
    [self set_color_rgba:color.red
                   green:color.green
                    blue:color.blue
                   alpha:color.alpha];
}

//----

- (void)set_redraw_flag:(BOOL)flag
{
    is_redraw_just_now = flag;
}

- (void)set_window_id:(int)p1
{
    window_id = p1;
}

- (void)set_current_point:(int)point_x point_y:(int)point_y
{
    current_point.x = point_x;
    current_point.y = point_y;
}

- (void)set_font:(NSString*)name size:(int)size style:(int)style
{
    font_name = name;
    font_size = size;
    font_style = style;
}

- (void)set_color_rgba:(int)red green:(int)green blue:(int)blue alpha:(int)alpha
{
    current_color.red = red;
    current_color.green = green;
    current_color.blue = blue;
    current_color.alpha = alpha;
}

- (void)clear_canvas:(int)color_number
{
    clear_canvas_rgba(pixel_data, screen_width,
                      screen_height, color_number);
    if (is_redraw_just_now) {
        [self redraw];
    }
}

- (void)set_pixel_rgba:(int)point_x point_y:(int)point_y
{
    set_pixel_rgba(pixel_data, point_x, point_y, current_color.red,
                   current_color.green, current_color.blue, current_color.alpha,
                   screen_width, screen_height);
    if (is_redraw_just_now) {
        [self redraw];
    }
}

- (void)set_line_rgba:(int)start_point_x
        start_point_y:(int)start_point_y
          end_point_x:(int)end_point_x
          end_point_y:(int)end_point_y
{
    set_line_rgba(pixel_data, start_point_x, start_point_y,
                  end_point_x, end_point_y, current_color.red,
                  current_color.green, current_color.blue, current_color.alpha,
                  screen_width, screen_height);
    if (is_redraw_just_now) {
        [self redraw];
    }
}

- (void)set_rect_line_rgba:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2
{
    [self set_line_rgba:x1 start_point_y:y1 end_point_x:x1 end_point_y:y2];
    [self set_line_rgba:x1 start_point_y:y2 end_point_x:x2 end_point_y:y2];
    [self set_line_rgba:x2 start_point_y:y2 end_point_x:x2 end_point_y:y1];
    [self set_line_rgba:x2 start_point_y:y1 end_point_x:x1 end_point_y:y1];
}

- (void)fill_rect_rgba:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2
{
    fill_rect_rgba(pixel_data, x1, y1, x2, y2, current_color.red,
                   current_color.green, current_color.blue, current_color.alpha,
                   screen_width, screen_height);
    if (is_redraw_just_now) {
        [self redraw];
    }
}

- (void)fill_rect_rgba_slow:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2
{
    fill_rect_rgba_slow(pixel_data, x1, y1, x2, y2, current_color.red,
                        current_color.green, current_color.blue,
                        current_color.alpha, screen_width,
                        screen_height);
    if (is_redraw_just_now) {
        [self redraw];
    }
}

- (void)set_circle_rgba:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2
{
    set_circle_rgba(pixel_data, x1, y1, x2, y2, current_color.red,
                    current_color.green, current_color.blue, current_color.alpha,
                    screen_width, screen_height);
    if (is_redraw_just_now) {
        [self redraw];
    }
}

- (void)fill_circle_rgba:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2
{
    fill_circle_rgba(pixel_data, x1, y1, x2, y2, current_color.red,
                     current_color.green, current_color.blue, current_color.alpha,
                     screen_width, screen_height);
    if (is_redraw_just_now) {
        [self redraw];
    }
}

- (void)mes:(NSString*)text
{
    @autoreleasepool {
        // NSImageに文字を描画
        NSString* str = text;
        CGFloat scale = 1.0;
        BOOL is_font_smooth = NO;
        
        if (font_style & 16) { //アンチエイリアシングありの時だけRetina対応をする
            is_font_smooth = YES;
            scale = g.backing_scale_factor;
        }
        
        NSFont* font;
        CFStringRef ct_font_name; // = CFStringCreateWithCString(NULL, "Helvetica",
        // kCFStringEncodingMacRoman);
        CTFontRef ct_font;        // = CTFontCreateWithName(font_name, 12.0, NULL);
        
        if ([font_name isEqual:@""]) { //フォント名が未指定だったら
            font = [NSFont fontWithName:@"Helvetica" size:((float)font_size) / scale];
            ct_font_name =
            CFStringCreateWithCString(NULL, "Osaka", kCFStringEncodingUTF8);
            ct_font =
            CTFontCreateWithName(ct_font_name, ((float)font_size) / scale, NULL);
        } else {
            font = [NSFont fontWithName:font_name size:((float)font_size) / scale];
            ct_font_name = CFStringCreateWithCString(NULL, [font_name UTF8String],
                                                     kCFStringEncodingUTF8);
            ct_font =
            CTFontCreateWithName(ct_font_name, ((float)font_size) / scale, NULL);
        }
        
        CGSize strSize = [str sizeWithAttributes:@{
                                                   NSForegroundColorAttributeName : [NSColor whiteColor],
                                                   NSFontAttributeName : font
                                                   }]; //現在の属性からサイズを取得する
        int h = 0;
        int w = 0;
        
        if (scale > 1.0) { // Retina環境
            h = (int)strSize.height * scale;
            w = (int)strSize.width * scale + 20;
        } else { //非Retina環境
            h = (int)strSize.height;
            w = (int)strSize.width + 10;
        }
        
        NSImage* img = [[NSImage alloc]
                        initWithSize:NSMakeSize((int)strSize.width + 10, (int)strSize.height)];
        
        //プレーンデータからNSImageを生成
        unsigned char* plane = malloc(sizeof(unsigned char) * screen_width *
                                      screen_height * samplesPerPixel);
        memcpy(plane, pixel_data,
               sizeof(unsigned char) * screen_width *
               screen_height * samplesPerPixel);
        NSBitmapImageRep* bip = [[NSBitmapImageRep alloc]
                                 initWithBitmapDataPlanes:&plane
                                 pixelsWide:screen_width
                                 pixelsHigh:screen_height
                                 bitsPerSample:8
                                 samplesPerPixel:samplesPerPixel
                                 hasAlpha:YES
                                 isPlanar:NO
                                 colorSpaceName:NSDeviceRGBColorSpace
                                 bytesPerRow:screen_width * samplesPerPixel
                                 bitsPerPixel:samplesPerPixel * 8];
        free(plane);
        
        NSColor* color =
        [NSColor colorWithCalibratedRed:((float)current_color.red) / 255.0
                                  green:((float)current_color.green) / 255.0
                                   blue:((float)current_color.blue) / 255.0
                                  alpha:1.0];
        
        // NSMutableDictionary* font_styleAttributes;
        
        if (is_font_smooth) { //アンチエリアシングあり
            NSDictionary* stringAttributes;
            if (font_style & 4 && font_style & 8) { //下線＋打ち消し線
                stringAttributes = @{
                                     NSForegroundColorAttributeName : color,
                                     NSFontAttributeName : font,
                                     NSUnderlineStyleAttributeName :
                                         [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                     NSStrikethroughStyleAttributeName :
                                         [NSNumber numberWithInteger:NSUnderlineStyleSingle]
                                     };
            } else if (font_style & 8) { //打ち消し線
                stringAttributes = @{
                                     NSForegroundColorAttributeName : color,
                                     NSFontAttributeName : font,
                                     NSStrikethroughStyleAttributeName :
                                         [NSNumber numberWithInteger:NSUnderlineStyleSingle]
                                     };
            } else if (font_style & 4) { //下線
                stringAttributes = @{
                                     NSForegroundColorAttributeName : color,
                                     NSFontAttributeName : font,
                                     NSUnderlineStyleAttributeName :
                                         [NSNumber numberWithInteger:NSUnderlineStyleSingle]
                                     };
            } else { //標準スタイル
                stringAttributes = @{
                                     NSForegroundColorAttributeName : color,
                                     NSFontAttributeName : font
                                     };
            }
            [img lockFocus];
            [bip drawInRect:NSMakeRect(0, 0, w, h)
                   fromRect:NSMakeRect(current_point.x,
                                       screen_height - current_point.y - h,
                                       w, h)
                  operation:NSCompositingOperationSourceOver
                   fraction:1.0f
             respectFlipped:NO
                      hints:@{}];
            [str drawAtPoint:NSMakePoint(0, 0) withAttributes:stringAttributes];
            [img unlockFocus];
            bip = [[NSBitmapImageRep alloc] initWithData:[img TIFFRepresentation]];
        } else { //アンチエリアシングなし
            unsigned char* plane_text_image =
            malloc(sizeof(unsigned char) * img.size.width * img.size.height *
                   samplesPerPixel);
            memset(plane_text_image, 0, sizeof(unsigned char) * img.size.width *
                   img.size.height * samplesPerPixel);
            
            CGContextRef context = CGBitmapContextCreate(
                                                         plane_text_image, img.size.width, img.size.height, 8,
                                                         img.size.width * 4, CGColorSpaceCreateDeviceRGB(),
                                                         kCGImageAlphaPremultipliedLast);
            CGContextSaveGState(context);
            
            CGColorRef fontColor = [color CGColor];
            
            // Paragraph
            //- kCTTextAlignmentLeft
            //- kCTTextAlignmentCenter
            //- kCTTextAlignmentRight
            //- kCTTextAlignmentNatural
            CTTextAlignment alignment = kCTTextAlignmentLeft;
            
            CTParagraphStyleSetting settings[] = {
                { kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment }
            };
            
            CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(
                                                                        settings, sizeof(settings) / sizeof(settings[0]));
            
            CFTypeRef underline_style;
            if (font_style & 4) {
                underline_style = (__bridge CFTypeRef)(@(kCTUnderlineStyleSingle));
            } else {
                underline_style = (__bridge CFTypeRef)(@(kCTUnderlineStyleNone));
            }
            
            CFStringRef keys[] = { kCTFontAttributeName,
                kCTParagraphStyleAttributeName,
                kCTForegroundColorAttributeName,
                kCTUnderlineStyleAttributeName };
            CFTypeRef values[] = { ct_font, paragraphStyle, fontColor,
                underline_style };
            
            //メモリ解放必要
            CFDictionaryRef font_attributes = CFDictionaryCreate(
                                                                 kCFAllocatorDefault, (const void**)&keys, (const void**)&values,
                                                                 sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks,
                                                                 &kCFTypeDictionaryValueCallBacks);
            int x = 0;
            int y = 3;
            
            CFStringRef string = CFStringCreateWithCString(NULL, [str UTF8String],
                                                           kCFStringEncodingUTF8);
            CFAttributedStringRef attr_string =
            CFAttributedStringCreate(NULL, string, font_attributes);
            CTLineRef line = CTLineCreateWithAttributedString(attr_string);
            CGContextSetTextPosition(context, x, y);
            CGContextSetAllowsAntialiasing(context, NO);
            CGContextSetShouldAntialias(context, NO);
            CGContextSetShouldSmoothFonts(context, NO);
            
            CTLineDraw(line, context);
            
            unsigned char* bitmap = CGBitmapContextGetData(context);
            
            // 画像出力
            CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(
                                                                             NULL, bitmap, img.size.width * img.size.height * 4, bufferFree);
            CGImageRef result = CGImageCreate(
                                              img.size.width, img.size.height, 8, 32, img.size.width * 4,
                                              CGColorSpaceCreateDeviceRGB(), (CGBitmapInfo)kCGImageAlphaLast,
                                              dataProviderRef, NULL, 0, kCGRenderingIntentDefault);
            NSImage* image = [[NSImage alloc] initWithCGImage:result size:img.size];
            bip = [[NSBitmapImageRep alloc] initWithData:[image TIFFRepresentation]];
            
            // 解放処理
            CFRelease(dataProviderRef);
            CGImageRelease(result);
            
            CFRelease(underline_style);
            CFRelease(paragraphStyle);
            CFRelease(line);
            CFBridgingRelease(attr_string);
            CFBridgingRelease(string);
            CFBridgingRelease(font_attributes);
            CGContextRelease(context);
            free(plane_text_image);
        }
        
        //描画した画像からプレーンデータを生成する
        NSUInteger color_now[samplesPerPixel];
        NSUInteger color_compare[samplesPerPixel];
        color_compare[0] = current_color.red;
        color_compare[1] = current_color.green;
        color_compare[2] = current_color.blue;
        color_compare[3] = current_color.alpha;
        
        int i = 0;
        int height = h; //(int)strSize.height;
        int width = w;  //(int)strSize.width + 10;
        while (1) {
            if (width + current_point.x >= 641) {
                width--;
            } else if (width < 1) {
                break;
            } else {
                break;
            }
        }
        i = current_point.x * samplesPerPixel +
        current_point.y * screen_width * samplesPerPixel;
        
        if (font_style & 16) {
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    [bip getPixel:color_now atX:x y:y];
                    pixel_data[i] = color_now[0];
                    pixel_data[i + 1] = color_now[1];
                    pixel_data[i + 2] = color_now[2];
                    pixel_data[i + 3] = color_now[3];
                    
                    i += samplesPerPixel;
                }
                i += screen_width * samplesPerPixel - width * samplesPerPixel;
            }
        } else {
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    [bip getPixel:color_now atX:x y:y];
                    if (color_now[0] == color_compare[0] &&
                        color_now[1] == color_compare[1] &&
                        color_now[2] == color_compare[2] &&
                        color_now[3] == color_compare[3]) {
                        pixel_data[i] = color_now[0];
                        pixel_data[i + 1] = color_now[1];
                        pixel_data[i + 2] = color_now[2];
                        pixel_data[i + 3] = color_now[3];
                    }
                    
                    i += samplesPerPixel;
                }
                i += screen_width * samplesPerPixel - width * samplesPerPixel;
            }
        }
        
        CFRelease(ct_font_name);
        CFRelease(ct_font);
        
        current_point.y += h;
        
        if (is_redraw_just_now) {
            [self redraw];
        }
    }
}

static void
bufferFree(void* info, const void* data, size_t size)
{
    // free((unsigned char *)data);
}

- (NSSize)picload:(NSString*)filename
{
    return [self picload:filename mode:0];
}

- (NSSize)picload:(NSString*)filename mode:(int)mode
{
    NSSize pictureSize;
    @autoreleasepool {
        NSString* path;
        if (g.is_startax_in_resource) { //リソース内にstart.axがある場合
            path = [NSBundle mainBundle].resourcePath; //リソースディレクトリ
            path = [path stringByAppendingString:@"/"];
            path = [path stringByAppendingString:filename];
        } else if (![g.current_script_path
                     isEqual:@""]) { //ソースコードのあるディレクトリ
            path = g.current_script_path;
        } else { // hsptmp
            path = [NSHomeDirectory() stringByAppendingString:@"/Documents/hsptmp"];
        }
        path = [path stringByAppendingString:@"/"];
        path = [path stringByAppendingString:filename];
        
        _Size image_size;
        if (mode == 0) {
            //画像サイズに合わせて画面をリサイズ
            image_size =
            load_image_init_canvas([path UTF8String], pixel_data);
            screen_width = image_size.width;
            screen_height = image_size.height;
        } else {
            //画面をリサイズせず読み込み
            image_size = load_image([path UTF8String], pixel_data,
                                    current_point.x, current_point.y,
                                    screen_width, screen_height);
        }
        pictureSize.width = image_size.width;
        pictureSize.height = image_size.height;
        
        if (is_redraw_just_now) {
            [self redraw];
        }
    }
    return pictureSize;
}

@end

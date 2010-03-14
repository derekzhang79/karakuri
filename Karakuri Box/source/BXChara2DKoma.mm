//
//  BXChara2DKoma.mm
//  Karakuri Box
//
//  Created by numata on 10/03/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "BXChara2DKoma.h"
#import "NSDictionary+LoadSave.h"
#import "BXChara2DSpec.h"
#import "BXChara2DState.h"


@implementation BXChara2DKomaHitInfo

- (id)initWithType:(int)type group:(int)groupIndex rect:(NSRect)rect
{
    self = [super init];
    if (self) {
        mHitType = type;
        mGroupIndex = groupIndex;
        mRect = rect;
    }
    return self;
}

- (id)initWithInfo:(NSDictionary*)infoDict
{
    self = [super init];
    if (self) {
        mHitType = [infoDict intValueForName:@"Hit Type" currentValue:BXChara2DKomaHitTypeRect];
        mGroupIndex = [infoDict intValueForName:@"Group Index" currentValue:1];
        mRect.origin.x = [infoDict intValueForName:@"Rect X" currentValue:0.0];
        mRect.origin.y = [infoDict intValueForName:@"Rect Y" currentValue:0.0];
        mRect.size.width = [infoDict intValueForName:@"Rect Width" currentValue:2.0];
        mRect.size.height = [infoDict intValueForName:@"Rect Height" currentValue:2.0];
    }
    return self;
}

- (BOOL)contains:(NSPoint)pos
{
    return NSPointInRect(pos, mRect);
}

- (NSRect)rect
{
    return mRect;
}

- (void)setRect:(NSRect)rect
{
    mRect = rect;
}

- (void)drawInRect:(NSRect)targetRect scale:(double)scale isMain:(BOOL)isMain
{
    NSColor* borderColor = [NSColor colorWithCalibratedWhite:0.4 alpha:1.0];
    NSColor* fillColor = [NSColor colorWithCalibratedWhite:0.4 alpha:0.5];
    if (isMain) {
        if (mGroupIndex == 1) {
            borderColor = [NSColor colorWithCalibratedRed:1.0 green:0.5 blue:0.0 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:1.0 green:0.5 blue:0.0 alpha:0.5];
        } else if (mGroupIndex == 2) {
            borderColor = [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:0.0 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:0.0 alpha:0.5];
        } else if (mGroupIndex == 3) {
            borderColor = [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:1.0 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:0.0 green:0.5 blue:1.0 alpha:0.5];
        } else if (mGroupIndex == 4) {
            borderColor = [NSColor colorWithCalibratedRed:1.0 green:0.3 blue:1.0 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:1.0 green:0.3 blue:1.0 alpha:0.5];
        } else if (mGroupIndex == 5) {
            borderColor = [NSColor colorWithCalibratedRed:1.0 green:0.2 blue:0.2 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:1.0 green:0.2 blue:0.2 alpha:0.5];
        } else if (mGroupIndex == 6) {
            borderColor = [NSColor colorWithCalibratedRed:0.7 green:0.7 blue:0.0 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:0.7 green:0.7 blue:0.0 alpha:0.5];
        } else if (mGroupIndex == 7) {
            borderColor = [NSColor colorWithCalibratedRed:0.0 green:0.7 blue:0.5 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:0.0 green:0.7 blue:0.5 alpha:0.5];
        } else if (mGroupIndex == 8) {
            borderColor = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:1.0 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:1.0 alpha:0.5];
        } else if (mGroupIndex == 9) {
            borderColor = [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.0 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.0 alpha:0.5];
        } else if (mGroupIndex == 10) {
            borderColor = [NSColor colorWithCalibratedRed:0.4 green:0.0 blue:0.4 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:0.4 green:0.0 blue:0.4 alpha:0.5];
        } else if (mGroupIndex == 11) {
            borderColor = [NSColor colorWithCalibratedRed:0.6 green:0.3 blue:0.0 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:0.6 green:0.3 blue:0.0 alpha:0.5];
        } else if (mGroupIndex == 12) {
            borderColor = [NSColor colorWithCalibratedRed:0.0 green:0.8 blue:0.0 alpha:1.0];
            fillColor = [NSColor colorWithCalibratedRed:0.0 green:0.8 blue:0.0 alpha:0.5];
        }
    }
    
    NSRect theRect = NSMakeRect(targetRect.origin.x + mRect.origin.x * scale,
                                targetRect.origin.y + targetRect.size.height - mRect.origin.y * scale - mRect.size.height * scale,
                                mRect.size.width * scale,
                                mRect.size.height * scale);
    NSBezierPath* thePath = nil;
    if (mHitType == BXChara2DKomaHitTypeRect) {
        thePath = [NSBezierPath bezierPathWithRect:theRect];
    } else if (mHitType == BXChara2DKomaHitTypeOval) {
        thePath = [NSBezierPath bezierPathWithOvalInRect:theRect];
    }
    
    [fillColor set];
    [thePath fill];
    
    [[NSColor whiteColor] set];
    [thePath setLineWidth:3.0];
    [thePath stroke];
    
    [borderColor set];
    [thePath setLineWidth:2.0];
    [thePath stroke];
}

- (void)drawHandleAtPoint:(NSPoint)pos
{
    NSRect theRect = NSMakeRect(pos.x-1, pos.y-1, 2, 2);
    
    [[NSColor whiteColor] set];
    [NSBezierPath setDefaultLineWidth:2.0];
    [NSBezierPath strokeRect:theRect];
    
    [[NSColor colorWithCalibratedRed:0.0 green:0.6 blue:1.0 alpha:0.7] set];
    [NSBezierPath fillRect:theRect];
}

- (void)drawResizeHandlesInRect:(NSRect)targetRect scale:(double)scale
{
    NSRect theRect = NSMakeRect(targetRect.origin.x + mRect.origin.x * scale,
                                targetRect.origin.y + targetRect.size.height - mRect.origin.y * scale - mRect.size.height * scale,
                                mRect.size.width * scale,
                                mRect.size.height * scale);

    NSPoint topMiddle = NSMakePoint(theRect.origin.x+theRect.size.width/2, theRect.origin.y+theRect.size.height);
    NSPoint bottomMiddle = NSMakePoint(theRect.origin.x+theRect.size.width/2, theRect.origin.y);
    NSPoint leftMiddle = NSMakePoint(theRect.origin.x, theRect.origin.y+theRect.size.height/2);
    NSPoint rightMiddle = NSMakePoint(theRect.origin.x+theRect.size.width, theRect.origin.y+theRect.size.height/2);
    [self drawHandleAtPoint:topMiddle];
    [self drawHandleAtPoint:bottomMiddle];
    [self drawHandleAtPoint:leftMiddle];
    [self drawHandleAtPoint:rightMiddle];
}

- (int)groupIndex
{
    return mGroupIndex;
}

- (NSDictionary*)infoDict
{
    NSMutableDictionary* theInfo = [NSMutableDictionary dictionary];
    
    [theInfo setIntValue:mHitType forName:@"Hit Type"];
    [theInfo setIntValue:mGroupIndex forName:@"Group Index"];
    [theInfo setDoubleValue:mRect.origin.x forName:@"Rect X"];
    [theInfo setDoubleValue:mRect.origin.y forName:@"Rect Y"];
    [theInfo setDoubleValue:mRect.size.width forName:@"Rect Width"];
    [theInfo setDoubleValue:mRect.size.height forName:@"Rect Height"];
    
    return theInfo;
}

@end


@implementation BXChara2DKoma

- (id)init
{
    self = [super init];
    if (self) {
        mKomaNumber = 0;
        mIsCancelable = YES;
        mInterval = 0;
        mGotoTargetKoma = nil;        

        mHitInfos = [[NSMutableArray alloc] init];
        mShowsHitInfos = YES;
        mCurrentHitGroupIndex = 1;
    }
    return self;
}

- (id)initWithInfo:(NSDictionary*)info chara2DSpec:(BXChara2DSpec*)chara2DSpec
{
    self = [super init];
    if (self) {
        int imageID = [info intValueForName:@"Image ID" currentValue:-1];
        mImage = [chara2DSpec imageWithID:imageID];
        mImageAtlasIndex = [info intValueForName:@"Atlas Index" currentValue:0];
        
        mKomaNumber = [info intValueForName:@"Koma Number" currentValue:0];
        mIsCancelable = [info boolValueForName:@"Cancelable" currentValue:YES];
        mInterval = [info intValueForName:@"Interval" currentValue:0];
        
        mTempGotoTargetKomaNumber = [info intValueForName:@"Goto Target" currentValue:0];
        
        mGotoTargetKoma = nil;

        mHitInfos = [[NSMutableArray alloc] init];
        mShowsHitInfos = [info intValueForName:@"Shows Hit Infos" currentValue:YES];
        mCurrentHitGroupIndex = [info intValueForName:@"Current Hit Group Index" currentValue:1];
        
        NSArray* hitInfoDicts = [info objectForKey:@"Hit Infos"];
        if (hitInfoDicts) {
            for (int i = 0; i < [hitInfoDicts count]; i++) {
                NSDictionary* infoDict = [hitInfoDicts objectAtIndex:i];
                BXChara2DKomaHitInfo* theInfo = [[[BXChara2DKomaHitInfo alloc] initWithInfo:infoDict] autorelease];
                [mHitInfos addObject:theInfo];
            }
        }
    }
    return self;
}

- (void)dealloc
{
    [mHitInfos release];

    [super dealloc];
}

- (void)drawHitInfosInRect:(NSRect)targetRect scale:(double)scale
{
    // メイン以外の当たり判定範囲をすべて描画する
    for (int i = 0; i < [mHitInfos count]; i++) {
        BXChara2DKomaHitInfo* anInfo = [mHitInfos objectAtIndex:i];
        if ([anInfo groupIndex] != mCurrentHitGroupIndex) {
            [anInfo drawInRect:targetRect scale:scale isMain:NO];
        }
    }

    // メインの当たり判定範囲をすべて描画する
    for (int i = 0; i < [mHitInfos count]; i++) {
        BXChara2DKomaHitInfo* anInfo = [mHitInfos objectAtIndex:i];
        if ([anInfo groupIndex] == mCurrentHitGroupIndex) {
            [anInfo drawInRect:targetRect scale:scale isMain:YES];
        }
    }
}

- (int)hitInfoCount
{
    return [mHitInfos count];
}

- (BOOL)showsHitInfos
{
    return mShowsHitInfos;
}

- (void)setShowsHitInfos:(BOOL)flag
{
    mShowsHitInfos = flag;
}

- (int)currentHitGroupIndex
{
    return mCurrentHitGroupIndex;
}

- (void)setCurrentHitGroupIndex:(int)index
{
    mCurrentHitGroupIndex = index;
}

- (BXChara2DKomaHitInfo*)addHitInfoOval
{
    NSImage* nsImage = [self nsImage];
    NSSize size = [nsImage size];
    
    NSRect theRect = NSMakeRect(0, 0, 10, 10);
    if (size.width < theRect.size.width) {
        theRect.size.width = size.width;
    }
    if (size.height < theRect.size.height) {
        theRect.size.height = size.height;
    }
    
    BXChara2DKomaHitInfo* theInfo = [[[BXChara2DKomaHitInfo alloc] initWithType:BXChara2DKomaHitTypeOval
                                                                          group:mCurrentHitGroupIndex
                                                                           rect:theRect] autorelease];
    [mHitInfos addObject:theInfo];
    
    return theInfo;
}

- (BXChara2DKomaHitInfo*)addHitInfoRect
{
    NSImage* nsImage = [self nsImage];
    NSSize size = [nsImage size];
    
    NSRect theRect = NSMakeRect(0, 0, 10, 10);
    if (size.width < theRect.size.width) {
        theRect.size.width = size.width;
    }
    if (size.height < theRect.size.height) {
        theRect.size.height = size.height;
    }
    
    BXChara2DKomaHitInfo* theInfo = [[[BXChara2DKomaHitInfo alloc] initWithType:BXChara2DKomaHitTypeRect
                                                                          group:mCurrentHitGroupIndex
                                                                           rect:theRect] autorelease];
    [mHitInfos addObject:theInfo];

    return theInfo;
}

- (BXChara2DKomaHitInfo*)hitInfoAtPoint:(NSPoint)pos
{
    for (int i = 0; i < [mHitInfos count]; i++) {
        BXChara2DKomaHitInfo* anInfo = [mHitInfos objectAtIndex:i];
        if ([anInfo groupIndex] == mCurrentHitGroupIndex && [anInfo contains:pos]) {
            return anInfo;
        }
    }
    return nil;
}

- (void)setImage:(BXChara2DImage*)image atlasAtIndex:(int)index
{
    mImage = image;
    mImageAtlasIndex = index;
    
    [mImage incrementUsedCount];
}

- (int)komaNumber
{
    return mKomaNumber;
}

- (void)setKomaNumber:(int)number
{
    mKomaNumber = number;
}

- (BOOL)isCancelable
{
    return mIsCancelable;
}

- (void)setCancelable:(BOOL)flag
{
    mIsCancelable = flag;
}

- (int)interval
{
    return mInterval;
}

- (void)setInterval:(int)interval
{
    mInterval = interval;
}

- (NSImage*)nsImage
{
    return [mImage atlasImage72dpiAtIndex:mImageAtlasIndex];
}

- (BXChara2DImage*)image
{
    return mImage;
}

- (int)atlasIndex
{
    return mImageAtlasIndex;
}

- (int)gotoTargetNumber
{
    if (!mGotoTargetKoma) {
        return 0;
    }
    return [mGotoTargetKoma komaNumber];
}

- (BXChara2DKoma*)gotoTarget
{
    return mGotoTargetKoma;
}

- (void)setGotoTarget:(BXChara2DKoma*)target
{
    mGotoTargetKoma = target;
}

- (void)replaceTempGotoInfoForState:(BXChara2DState*)state
{
    if (mTempGotoTargetKomaNumber > 0) {
        BXChara2DKoma* targetKoma = [state komaWithNumber:mTempGotoTargetKomaNumber];
        mGotoTargetKoma = targetKoma;
    }
    
    mTempGotoTargetKomaNumber = -1;
}

- (void)preparePreviewTexture
{
    mPreviewTex = new KRTexture2D(mImage, mImageAtlasIndex);
}

- (KRTexture2D*)previewTexture
{
    return mPreviewTex;
}

- (NSDictionary*)komaInfo
{
    NSMutableDictionary* theInfo = [NSMutableDictionary dictionary];
    
    [theInfo setIntValue:[mImage imageID] forName:@"Image ID"];
    [theInfo setIntValue:mImageAtlasIndex forName:@"Atlas Index"];
    [theInfo setIntValue:mKomaNumber forName:@"Koma Number"];
    [theInfo setBoolValue:mIsCancelable forName:@"Cancelable"];
    [theInfo setIntValue:mInterval forName:@"Interval"];
    [theInfo setIntValue:[self gotoTargetNumber] forName:@"Goto Target"];
    [theInfo setBoolValue:mShowsHitInfos forName:@"Shows Hit Infos"];
    [theInfo setIntValue:mCurrentHitGroupIndex forName:@"Current Hit Group Index"];
    
    NSMutableArray* hitInfoDicts = [NSMutableArray array];
    for (int i = 0; i < [mHitInfos count]; i++) {
        BXChara2DKomaHitInfo* anInfo = [mHitInfos objectAtIndex:i];
        [hitInfoDicts addObject:[anInfo infoDict]];
    }
    [theInfo setObject:hitInfoDicts forKey:@"Hit Infos"];

    return theInfo;
}

@end


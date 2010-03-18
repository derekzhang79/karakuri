//
//  BXResourceImporter.mm
//  Karakuri Library
//
//  Created by numata on 10/03/17.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "BXResourceImporter.h"

#include "KarakuriException.h"

#import "KRTexture2DManager.h"


@implementation BXImportContext

- (id)initWithFileAtPath:(NSString*)filepath
{
    self = [super init];
    if (self) {
        mData = [[NSData alloc] initWithContentsOfMappedFile:filepath];
        mPos = 0;
    }
    return self;
}

- (void)dealloc
{
    [mData release];
    [super dealloc];
}

- (BOOL)checkMagic:(const char*)magic
{
    unsigned char* buffer[4];
    
    [self readBytes:buffer length:4];
    
    return (strncmp(magic, (const char*)buffer, 4) == 0)? YES: NO;
}

- (BXResourceType)checkResourceType
{
    unsigned char* buffer[4];    
    [self readBytes:buffer length:4];
    
    if (strncmp("KRED", (const char*)buffer, 4) == 0) {
        return BXResourceTypeEndMark;
    }
    else if (strncmp("KRC2", (const char*)buffer, 4) == 0) {
        return BXResourceTypeChara2D;
    }
    else if (strncmp("KRP2", (const char*)buffer, 4) == 0) {
        return BXResourceTypeParticle2D;
    }
    else if (strncmp("KRT2", (const char*)buffer, 4) == 0) {
        return BXResourceTypeTexture2D;
    }
    else if (strncmp("KRDT", (const char*)buffer, 4) == 0) {
        return BXResourceTypeData;
    }
    
    NSLog(@"Unknown Resource Header: %c%c%c%c (0x%06X)", buffer[0], buffer[1], buffer[2], buffer[3], mPos-4);
    
    return BXResourceTypeUnknown;
}

- (unsigned)currentPos
{
    return mPos;
}

- (void)reset
{
    mPos = 0;
}

- (void)readBytes:(void*)buffer length:(unsigned)length
{
    [mData getBytes:buffer range:NSMakeRange(mPos, length)];
    mPos += length;
}

- (NSData*)readDataWithLength:(unsigned)length
{
    NSData* ret = [mData subdataWithRange:NSMakeRange(mPos, length)];
    
    mPos += length;
    
    return ret;
}

- (unsigned)readUnsignedIntValue
{
    unsigned char buffer[4];
    
    [mData getBytes:buffer range:NSMakeRange(mPos, 4)];
    mPos += 4;
    
    return ((buffer[0] << 24) | (buffer[1] << 16) | (buffer[2] << 8) | buffer[3]);
}

- (void)skip:(unsigned)length
{
    mPos += length;
}

@end


@implementation BXResourceImporter

- (id)initWithFileName:(NSString*)fileName
{
    self = [super init];
    if (self) {
        NSString* filepath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        mContext = [[BXImportContext alloc] initWithFileAtPath:filepath];
        mFileName = [fileName copy];
    }
    return self;
}

- (void)dealloc
{
    [mContext release];
    [mFileName release];

    [super dealloc];
}

- (void)skipChara2D
{
    unsigned infoSize = [mContext readUnsignedIntValue];
    [mContext skip:infoSize];
}

- (void)skipParticle2D
{
    unsigned infoSize = [mContext readUnsignedIntValue];
    [mContext skip:infoSize];
}

- (void)importChara2D
{
    unsigned infoSize = [mContext readUnsignedIntValue];
    NSData* data = [mContext readDataWithLength:infoSize];
    
    NSString* errorStr = nil;
    NSDictionary* chara2DInfo = [NSPropertyListSerialization propertyListFromData:data
                                                                 mutabilityOption:NSPropertyListImmutable
                                                                           format:nil
                                                                 errorDescription:&errorStr];
    
    int resourceID = [[chara2DInfo objectForKey:@"Resource ID"] intValue];
    int groupID = [[chara2DInfo objectForKey:@"Group ID"] intValue];
    
    KRChara2DSpec* chara2DSpec = new KRChara2DSpec(groupID);

    NSArray* imageInfos = [chara2DInfo objectForKey:@"Image Infos"];
    for (int i = 0; i < [imageInfos count]; i++) {
        NSDictionary* anImageInfo = [imageInfos objectAtIndex:i];
        int divX = [[anImageInfo objectForKey:@"Div X"] intValue];
        int divY = [[anImageInfo objectForKey:@"Div Y"] intValue];
        NSString* ticket = [anImageInfo objectForKey:@"Image Ticket"];
        gKRTex2DMan->setDivForTicket([ticket cStringUsingEncoding:NSUTF8StringEncoding], divX, divY);
    }
    
    NSArray* stateInfos = [chara2DInfo objectForKey:@"State Infos"];
    for (int i = 0; i < [stateInfos count]; i++) {
        NSDictionary* aStateInfo = [stateInfos objectAtIndex:i];
        
        //NSString* stateName = [aStateInfo objectForKey:@"State Name"];
        int stateID = [[aStateInfo objectForKey:@"State ID"] intValue];
        int nextStateID = [[aStateInfo objectForKey:@"Next State ID"] intValue];
        int cancelKomaNumber = [[aStateInfo objectForKey:@"Cancel Koma"] intValue]; // キャンセル時の終了アニメーション開始コマ
        
        KRChara2DState* aState = new KRChara2DState();
        aState->initForBoxChara2D(cancelKomaNumber, nextStateID);

        int defaultInterval = [[aStateInfo objectForKey:@"Default Interval"] intValue]; // キャンセル時の終了アニメーション開始コマ

        NSArray* komaInfos = [aStateInfo objectForKey:@"Koma Infos"];
        for (int j = 0; j < [komaInfos count]; j++) {
            NSDictionary* aKomaInfo = [komaInfos objectAtIndex:j];
            
            int interval = [[aKomaInfo objectForKey:@"Interval"] intValue];
            if (interval == 0) {
                interval = defaultInterval;
            }
            //int komaNumber = [[aKomaInfo objectForKey:@"Koma Number"] intValue];
            NSString* imageTicket = [aKomaInfo objectForKey:@"Image Ticket"];
            int atlasIndex = [[aKomaInfo objectForKey:@"Atlas Index"] intValue];
            BOOL isCancelable = [[aKomaInfo objectForKey:@"Cancelable"] boolValue];
            int gotoTarget = [[aKomaInfo objectForKey:@"Goto Target"] intValue];
            //NSArray* hitInfos = [aKomaInfo objectForKey:@"Hit Infos"];

            KRChara2DKoma* aKoma = new KRChara2DKoma();
            aKoma->initForBoxChara2D([imageTicket cStringUsingEncoding:NSUTF8StringEncoding], atlasIndex, interval,
                                     (isCancelable? true: false), gotoTarget);
            aState->addKoma(aKoma);
        }
        
        chara2DSpec->addState(stateID, aState);
    }

    gKRAnime2DMan->_addCharaSpec(resourceID, chara2DSpec);
}

- (void)importParticle2D
{
    unsigned infoSize = [mContext readUnsignedIntValue];
    NSData* data = [mContext readDataWithLength:infoSize];
    
    NSString* errorStr = nil;
    NSDictionary* particle2DInfo = [NSPropertyListSerialization propertyListFromData:data
                                                                    mutabilityOption:NSPropertyListImmutable
                                                                              format:nil
                                                                    errorDescription:&errorStr];
    
    int resourceID = [[particle2DInfo objectForKey:@"Resource ID"] intValue];
    int groupID = [[particle2DInfo objectForKey:@"Group ID"] intValue];
    NSString* imageTicket = [particle2DInfo objectForKey:@"Image Ticket"];
    
    gKRAnime2DMan->_addParticle2DWithTicket(resourceID, groupID, [imageTicket cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)skipTexture2D
{
    unsigned infoSize = [mContext readUnsignedIntValue];
    [mContext skip:infoSize];

    if ([mContext checkResourceType] != BXResourceTypeData) {
        throw KRRuntimeError("KRGameManager::addResources(): Resource data is lacking: 0x%06x", [mContext currentPos]-4);
    }
    
    unsigned dataLength = [mContext readUnsignedIntValue];
    [mContext skip:dataLength];
}

- (void)importTexture2D
{
    unsigned infoSize = [mContext readUnsignedIntValue];
    NSData* data = [mContext readDataWithLength:infoSize];

    NSString* errorStr = nil;
    NSDictionary* tex2DInfo = [NSPropertyListSerialization propertyListFromData:data
                                                               mutabilityOption:NSPropertyListImmutable
                                                                         format:nil
                                                               errorDescription:&errorStr];
    
    if ([mContext checkResourceType] != BXResourceTypeData) {
        throw KRRuntimeError("KRGameManager::addResources(): Resource data is lacking: 0x%06x", [mContext currentPos]-4);
    }

    unsigned dataLength = [mContext readUnsignedIntValue];
    unsigned dataStartPos = [mContext currentPos];

    int groupID = [[tex2DInfo objectForKey:@"Group ID"] intValue];
    NSString* resourceName = [tex2DInfo objectForKey:@"Resource Name"];
    NSString* ticket = [tex2DInfo objectForKey:@"Ticket"];
    
    gKRTex2DMan->addTexture(groupID,
                            [resourceName cStringUsingEncoding:NSUTF8StringEncoding],
                            [ticket cStringUsingEncoding:NSUTF8StringEncoding],
                            [mFileName cStringUsingEncoding:NSUTF8StringEncoding],
                            dataStartPos, dataLength);

    [mContext skip:dataLength];
}

- (void)importPrimitiveResources
{
    [mContext reset];

    // MAGIC
    if (![mContext checkMagic:"KRRS"]) {
        throw KRRuntimeError("KRGameManager::addResources(): Invalid resource file header.");
    }
    
    // Version numbers
    //unsigned majorVersion = [mContext readUnsignedIntValue];
    [mContext skip:4];
    //unsigned minorVersion = [mContext readUnsignedIntValue];
    [mContext skip:4];
    
    while (YES) {
        BXResourceType type = [mContext checkResourceType];
        
        // リソースの終端
        if (type == BXResourceTypeEndMark) {
            break;
        }
        // 2Dキャラクタ
        else if (type == BXResourceTypeChara2D) {
            [self skipChara2D];
        }
        // 2Dパーティクル
        else if (type == BXResourceTypeParticle2D) {
            [self skipParticle2D];
        }
        // 2Dテクスチャ
        else if (type == BXResourceTypeTexture2D) {
            [self importTexture2D];
        }
        // 未知のタイプ
        else {
            throw KRRuntimeError("Unknown resource header appeared!!");
        }
    }    
}

- (void)importRichResources
{
    [mContext reset];

    // MAGIC
    if (![mContext checkMagic:"KRRS"]) {
        throw KRRuntimeError("KRGameManager::addResources(): Invalid resource file header.");
    }
    
    // Version numbers
    //unsigned majorVersion = [mContext readUnsignedIntValue];
    [mContext skip:4];
    //unsigned minorVersion = [mContext readUnsignedIntValue];
    [mContext skip:4];

    while (YES) {
        BXResourceType type = [mContext checkResourceType];

        // リソースの終端
        if (type == BXResourceTypeEndMark) {
            break;
        }
        // 2Dキャラクタ
        else if (type == BXResourceTypeChara2D) {
            [self importChara2D];
        }
        // 2Dパーティクル
        else if (type == BXResourceTypeParticle2D) {
            [self importParticle2D];
        }
        // 2Dテクスチャ
        else if (type == BXResourceTypeTexture2D) {
            [self skipTexture2D];
        }
        // 未知のタイプ
        else {
            throw KRRuntimeError("Unknown resource header appeared!!");
        }
    }
}

@end



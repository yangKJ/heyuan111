//
//  SectionData.m
//  XinMinClub
//
//  Created by 赵劲松 on 16/3/31.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "SectionData.h"

@implementation SectionData

- (id)initWithDic:(NSDictionary *)dic {
    
    SectionData *sectionData = [[SectionData alloc] init];
    _dic = [NSDictionary dictionary];
    if (!dic) {
        return sectionData;
    }
    sectionData.author = dic[@"author"];
    sectionData.sectionName = dic[@"sectionName"];
    sectionData.bookName = dic[@"bookName"];
    sectionData.playCount = dic[@"playCount"];
    sectionData.sectionID = dic[@"sectionID"];
    sectionData.dic = dic[@"dic"];
    sectionData.libraryImageUrl = dic[@"image"];
    sectionData.clickMp3 = dic[@"mp3"];
    sectionData.localMp3 = dic[@"mp3"];
    return sectionData;
}

+ (id)sectionWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}

@end

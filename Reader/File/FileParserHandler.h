//
//  FileParserHandler.h
//  Reader
//
//  Created by xing on 2020/11/18.
//  Copyright © 2020 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileParserHandler : NSObject

+ (void)parserFileWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END

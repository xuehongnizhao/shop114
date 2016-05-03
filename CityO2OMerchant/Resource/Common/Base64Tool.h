//
//  Base65Tool.h
//  PersonInfo
//
//  Created by Sky on 14-8-25.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEngine.h"

@interface Base64Tool : NSObject
/*
 @brief 普通字典请求
 */
+(void)postSomethingToServe:(NSString*) url andParams:(NSDictionary*) dict isBase64:(BOOL) base64 CompletionBlock:(completionBlock) completionBlock andErrorBlock:(MKNKErrorBlock)errorBlock;
 

/*
 @brief post单一文件
 
 */

+(void)postFileTo:(NSString *)url andParams:(NSDictionary *)dict  andFile:(NSData*) fileData andFileName:(NSString*) fileName  isBase64:(BOOL)base64 CompletionBlock:(completionBlock) completionBlock andErrorBlock:(MKNKErrorBlock)errorBlock;


/*
 
 @brief post多文件
 */

+(void)postFileTo:(NSString*) url andParams:(NSDictionary*)dict andFiles:(NSArray*) fileDatas andFileNames:(NSArray*) fileNames isBase64:(BOOL)
isBase64 CompletionBlock:(completionBlock) completionBlock andErrorBlock:(MKNKErrorBlock)errorBlock;

/*
 @brief base64加密算法
 */
+(NSDictionary*)encodeDict:(NSDictionary*) params;
@end

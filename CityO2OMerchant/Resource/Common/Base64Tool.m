//
//  Base65Tool.m
//  PersonInfo
//
//  Created by Sky on 14-8-25.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import "Base64Tool.h"
#import "Base64.h"
#import "MyMD5.h"
#import "AppDelegate.h"
@implementation Base64Tool
+(void)postSomethingToServe:(NSString *)url andParams:(NSDictionary *)dict isBase64:(BOOL)base64 CompletionBlock:(completionBlock)completionBlock andErrorBlock:(MKNKErrorBlock)errorBlock
{
    NSDictionary* dictionary=dict;
    if (base64==YES)
    {
        dictionary=[self encodeDict:dict];
    }
    
  __block  NSDictionary* result=nil;
        [ApplicationDelegate.baseEngine postSomethingTo:url withParams:dictionary withCompletionBlock:^(id param)
         {
             NSDictionary* dic=nil;
             if (base64==YES)
             {
                              dic=[NSJSONSerialization JSONObjectWithData:[Base64 decodeData:param] options:NSJSONReadingMutableContainers error:nil];
             }
             else
             {
                dic=[NSJSONSerialization JSONObjectWithData:param options:NSJSONReadingMutableContainers error:nil];
             }
             NSLog(@"dict:%@",dic);
             NSLog(@" message:%@",[dic objectForKey:@"message"]);
             
             result=dic;
             completionBlock(result);
             
         } andErrorBlock:^(NSError *error) {
             errorBlock(error);
         } option:responseStringState];
    return;
}

+(void)postFileTo:(NSString *)url andParams:(NSDictionary *)dict  andFile:(NSData*) fileData andFileName:(NSString*) fileName  isBase64:(BOOL)base64 CompletionBlock:(completionBlock) completionBlock andErrorBlock:(MKNKErrorBlock)errorBlock
{
    NSDictionary* dictionary=dict;
    if (base64==YES)
    {
        dictionary=[self encodeDict:dict];
    }
    
    __block  NSDictionary* result=nil;
    [ApplicationDelegate.baseEngine postFileTo:url withParams:dictionary withFile:fileData andName:fileName withCompletionBlock:^(id param)
    {
        NSDictionary* dic=nil;
        if (base64==YES)
        {
            dic=[NSJSONSerialization JSONObjectWithData:[Base64 decodeData:param] options:NSJSONReadingMutableContainers error:nil];
        }
        else
        {
            dic=[NSJSONSerialization JSONObjectWithData:param options:NSJSONReadingMutableContainers error:nil];
        }
        NSLog(@"dict:%@",dic);
        NSLog(@" message:%@",[dic objectForKey:@"message"]);
        
        result=dic;
        completionBlock(result);
    }
    andErrorBlock:^(NSError *error)
    {
        errorBlock(error);
    }];
    return;
}


+(void)postFileTo:(NSString *)url andParams:(NSDictionary *)dict andFiles:(NSArray *)fileDatas andFileNames:(NSArray *)fileNames isBase64:(BOOL)isBase64 CompletionBlock:(completionBlock)completionBlock andErrorBlock:(MKNKErrorBlock)errorBlock
{
    NSDictionary* dictionary=dict;
    if (isBase64==YES)
    {
        dictionary=[self encodeDict:dict];
    }
    __block  NSDictionary* result=nil;
    [ApplicationDelegate.baseEngine postFileTo:url withParams:dictionary withFiles:fileDatas andNames:fileNames withCompletionBlock:^(id param)
    {
        if (param)
        {
            NSDictionary* dic=nil;
            if (isBase64==YES)
            {
                dic=[NSJSONSerialization JSONObjectWithData:[Base64 decodeData:param] options:NSJSONReadingMutableContainers error:nil];
            }
            else
            {
                dic=[NSJSONSerialization JSONObjectWithData:param options:NSJSONReadingMutableContainers error:nil];
            }
            NSLog(@"dict:%@",dic);
            NSLog(@" message:%@",[dic objectForKey:@"message"]);
            
            result=dic;
            completionBlock(result);
        }
        else
        {
            NSLog(@"数据解析错误，可能是php问题");
        }
        
    } andErrorBlock:^(NSError *error)
    {
        errorBlock(error);
    }];
    
    return;

}

#pragma mark---------app_keyMd5加密 dictBase64加密
+(NSDictionary*)encodeDict:(NSDictionary*) params
{
    //app_key加密
    NSString* app_key=[MyMD5 md5:[NSString stringWithFormat:@"http://%@/%@",baseUrl,[params objectForKey:@"app_key"]]];
    NSLog(@"before app_key:%@",app_key);
    NSLog(@"%@%@",baseUrl,[params objectForKey:@"app_key"]);
    NSLog(@"app_key:%@",app_key);
    NSMutableDictionary* mDict=[[NSMutableDictionary alloc]initWithDictionary:params];
    [mDict removeObjectForKey:@"app_key"];
    NSLog(@"mDict:%@",mDict);
    [mDict setObject:app_key forKey:@"app_key"];
    NSMutableArray* allValues=[[NSMutableArray alloc]init];
    for (id obj in [mDict allValues])
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"已找到字典");
            NSMutableArray* muArr=[[NSMutableArray alloc]init];
            for (NSString* s in [obj allValues] )
            {
                NSString* string=[Base64 stringByEncodingData:[s dataUsingEncoding:NSUTF8StringEncoding]];
                [muArr addObject:string];
            }
            
            NSMutableArray* keyArr=[[NSMutableArray alloc]init];
            for (NSString* s in [obj allKeys])
            {
                NSString* string=[Base64 stringByEncodingData:[s dataUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"str:%@",string);
                [keyArr addObject:string];
            }
        
            NSDictionary* dict=[[NSDictionary alloc]initWithObjects:muArr forKeys:keyArr];
            NSLog(@"base64后字典为:%@",dict);
            [allValues addObject:dict];
        }
        else
        {
            NSString* string=[Base64 stringByEncodingData:[obj dataUsingEncoding:NSUTF8StringEncoding]];
            [allValues addObject:string];
        }
    }
    NSDictionary* dict=[[NSDictionary alloc]initWithObjects:allValues forKeys:[mDict allKeys]];
    NSLog(@"base64加密后的字典%@",dict);
    
    return dict;
}


@end

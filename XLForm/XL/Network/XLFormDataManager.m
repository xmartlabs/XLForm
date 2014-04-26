//
//  XLFormDataManager.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Created by Martin Barreto on 31/3/14.
//
//  Copyright (c) 2014 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLFormDataManager.h"

@implementation XLFormDataManager
{
    NSURLSessionDataTask * _task;
    NSDictionary * _data;
}

-(id)init
{
    return [self initWithMultipartRequest:NO];
}

-(id)initWithMultipartRequest:(BOOL)isMultipartRequest;
{
    self = [super init];
    if (self){
        _data = nil;
        self.isMultiPartRequest = isMultipartRequest;
    }
    return self;
}

-(void)setDefaultValues
{
    _task = nil;
    _data = nil;
}

-(void)setData:(NSDictionary *)data
{
    _data = data;
}

-(NSURLSessionDataTask *)prepareURLSessionTask
{
    NSMutableURLRequest * request = self.prepareURLRequest;
    XLFormDataManager * __weak weakSelf = self;
    
    void (^completionHandler)(NSURLResponse * __unused response, id responseObject, NSError *error);
    completionHandler = ^(NSURLResponse * __unused response, id responseObject, NSError *error){
        if (error) {
            if (responseObject){
                NSMutableDictionary * newUserInfo = [error.userInfo mutableCopy];
                [newUserInfo setObject:responseObject forKey:AFNetworkingTaskDidCompleteSerializedResponseKey];
                NSError * newError = [NSError errorWithDomain:error.domain code:error.code userInfo:newUserInfo];
                [weakSelf unsuccessfulDataLoadWithError:newError];
            }
            else{
                [weakSelf unsuccessfulDataLoadWithError:error];
            }
        } else {
            [weakSelf setData:(NSDictionary *)responseObject];
            [weakSelf successfulDataLoad];
        }
    };
    if (self.isMultiPartRequest) {
        return [[self sessionManager] uploadTaskWithStreamedRequest:request progress:nil completionHandler:completionHandler];
    }
    else {
        return [[self sessionManager] dataTaskWithRequest:request completionHandler:completionHandler];
    }
}

-(NSMutableURLRequest *)prepareURLRequest
{
    if (!self.isMultiPartRequest){
        return [[self sessionManager].requestSerializer requestWithMethod:self.httpMethod
                                                                URLString:[[NSURL URLWithString:self.urlString relativeToURL:[[self sessionManager] baseURL]] absoluteString]
                                                               parameters:[self parameters]
                                                                    error:nil];
    }
    return [[self sessionManager].requestSerializer multipartFormRequestWithMethod:self.httpMethod URLString:[[NSURL URLWithString:self.urlString relativeToURL:[[self sessionManager] baseURL]] absoluteString] parameters:[self parameters] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary *param in self.multipartParameters) {
            [formData appendPartWithFileData:param[@"data"] name:param[@"name"] fileName:param[@"fileName"] mimeType:param[@"mimeType"]];
        }
    } error:nil];
}


-(void)successfulDataLoad
{
    if (self.delegate){
        [self.delegate dataLoaderDidLoadData:self];
    }
}

-(void)unsuccessfulDataLoadWithError:(NSError *)error
{
    if (self.delegate){
        [self.delegate dataLoaderDidFailLoadData:self withError:error];
    }
}

-(void)load
{
    _task = [self prepareURLSessionTask];
    [_task resume];
    if (self.delegate){
        [self.delegate dataLoaderDidStartLoadingData:self];
    }
}


-(void)forceReload
{
    if (_task){
        [_task cancel];
        _task = nil;
    }
    [self setDefaultValues];
    [self load];
}

-(NSDictionary *)fetchedData
{
    return _data;
}


@end

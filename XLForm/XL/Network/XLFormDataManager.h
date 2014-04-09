//
//  XLFormDataManager.h
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

#import <AFNetworking/AFNetworking.h>
#import <XLDataLoader/XLDataLoader.h>
#import <Foundation/Foundation.h>

@interface XLFormDataManager : XLDataLoader

@property (weak) id<XLDataLoaderDelegate> delegate;
@property (weak) AFHTTPSessionManager * sessionManager;
@property NSDictionary * parameters;
@property NSArray * multipartParameters;
@property NSString * urlString;
@property NSString * httpMethod;

@property BOOL isMultiPartRequest;

-(id)init;
-(id)initWithMultipartRequest:(BOOL)isMultipartRequest;

-(void)forceReload;

// method called after a successful data load, if overrited by subclass don't forget to call super method (delegate is called from there).
-(void)successulDataLoad;
// method called after a failure on data load, if overrited by subclass don't forget to call super method (delegate is called from there).
-(void)unsuccessulDataLoadWithError:(NSError *)error;

// call for obtain the related fetched
-(NSDictionary *)fetchedData;

//-(NSURLSessionDataTask *)prepareURLSessionTask;

@end
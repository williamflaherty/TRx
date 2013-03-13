//
//  NZURLConnection.h
//
//  Created by Nathan Ziebart on 7/17/12.
//

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2012 Nathan Ziebart
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

@interface NZURLConnection : NSURLConnection <NSURLConnectionDelegate>

@property (strong) void (^completionHandler)(NSData *response, NSError *error, BOOL timedOut);

+ (NZURLConnection *) postObject:(id)object toURL:(NSString *)urlString withTimeout:(NSTimeInterval)timeout completionHandler:(void (^)(NSData *response, NSError *error, BOOL timedOut))completion;

+ (NZURLConnection *) getAsynchronousResponseFromURL:(NSString *)urlString withTimeout:(NSTimeInterval)timeout completionHandler:(void (^)(NSData *response, NSError *error, BOOL timedOut))completion;

+ (NZURLConnection *) uploadFile:(NSString *)filePath toURL:(NSString *)urlString withParameterName:(NSString *)paramName  withTimeout:(NSTimeInterval)timeout completionHandler:(void (^)(NSData *response, NSError *error, BOOL timedOut))completion;

+ (NZURLConnection *) sendAsynchronousRequest:(NSURLRequest *)request withTimeout:(NSTimeInterval)timeout completionHandler:(void (^) (NSData *response, NSError *error, BOOL timedOut))completion;

- (NZURLConnection *) initWithRequest:(NSURLRequest *)request;

- (void) startWithTimeout:(NSTimeInterval)timeout;

@end

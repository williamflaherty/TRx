//
//  NZURLConnection.m
//
//  Created by Nathan Ziebart on 7/17/12.
//

#import "NZURLConnection.h"

@implementation NZURLConnection {
    bool completed;
    NSMutableData *storageData;
}

#define FIX(a) a = [self fixURL:a]

////
# pragma mark - INIT
//

- (id)initWithRequest:(NSURLRequest *)request {
    if (self = [super initWithRequest:request delegate:self]) {
        storageData = [[NSMutableData alloc] init];
        completed = NO;
    }
    return self;
}


////
# pragma mark - STATIC INTERFACE
//

+ (NZURLConnection *)sendAsynchronousRequest:(NSURLRequest *)aRequest withTimeout:(NSTimeInterval)aTimeout completionHandler:(void (^)(NSData *, NSError *, BOOL))aHandler {
    NZURLConnection *theConnection = [[NZURLConnection alloc] initWithRequest:aRequest];
    theConnection.completionHandler = aHandler;
    [theConnection startWithTimeout:aTimeout];
    
    return theConnection;
}

+ (NZURLConnection *)postObject:(id)anObject toURL:(NSString *)aURL withTimeout:(NSTimeInterval)aTimeout completionHandler:(void (^)(NSData *, NSError *, BOOL))aHandler {
    FIX(aURL);
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:aURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    theRequest.timeoutInterval = aTimeout;

    [theRequest setHTTPMethod:@"POST"];
    
    NSData *theData = [NSJSONSerialization dataWithJSONObject:anObject options:kNilOptions error:nil];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:[NSString stringWithFormat:@"%d", [theData length]] forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:theData];
    
    NZURLConnection *theConnection = [[NZURLConnection alloc] initWithRequest:theRequest];
    theConnection.completionHandler = aHandler;
    [theConnection startWithTimeout:aTimeout];
    
    return theConnection;
}

+ (NZURLConnection *)uploadFile:(NSString *)aFilePath toURL:(NSString *)aURL withParameterName:(NSString *)aParameterName withTimeout:(NSTimeInterval)aTimeout completionHandler:(void (^)(NSData *, NSError *, BOOL))aHandler {
    FIX(aURL);
    NSURLRequest *theRequest = [self fileUploadRequestWithURL:aURL file:aFilePath name:aParameterName];
    
    NZURLConnection *theConnection = [[NZURLConnection alloc] initWithRequest:theRequest];
    theConnection.completionHandler = aHandler;
    [theConnection startWithTimeout:aTimeout];
    
    return theConnection;
}

+ (NZURLConnection *)getAsynchronousResponseFromURL:(NSString *)aURL withTimeout:(NSTimeInterval)aTimeout completionHandler:(void (^)(NSData *, NSError *, BOOL timedOut))aHandler {
    FIX(aURL);
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:aURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:aTimeout];

    
    NZURLConnection *theConnection = [[NZURLConnection alloc] initWithRequest:theRequest];
    theConnection.completionHandler = aHandler;
    [theConnection startWithTimeout:aTimeout];
    return theConnection;
}


////
# pragma mark - INSTANCE INTERFACE
//

- (void)startWithTimeout:(NSTimeInterval)aTimeout {
    [self performSelector:@selector(cancelWithHandler) withObject:nil afterDelay:aTimeout];
    [self start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    completed = YES;
    if (self.completionHandler) {
        self.completionHandler(nil, error, error.code == -1001);
    }
}


////
# pragma mark - HELPERS
//

+ (NSString *)fixURL:(NSString *)url {
    if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"file://"]) {
        return [@"http://" stringByAppendingString:url];
    }
    return url;
}

+ (NSURLRequest *)fileUploadRequestWithURL:(NSString *)aURL file:(NSString *)aFilePath name:(NSString *)aName
{
    if (aName == nil) aName = @"upload";
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:aURL]];
    [theRequest setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithFormat:@"-----------%d%d", arc4random(), arc4random()];
    NSString *header = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest setValue:header forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *data = [NSMutableData new];
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", aName, [aFilePath lastPathComponent]]dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[NSData dataWithContentsOfFile:aFilePath]];
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [theRequest setHTTPBody:data];
    
    return theRequest;
}


////
# pragma mark - INTERNAL
//

- (void)cancelWithHandler {
    if (!completed) {
        [super cancel];
        if (self.completionHandler) {
            self.completionHandler(nil, nil, YES);
        }
    }
    completed = YES;
}

- (void) cancel {
    [super cancel];
    completed = YES;
}


////
# pragma mark - NSURLCONNECTION DELEGATE
//

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [storageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    completed = YES;
    if (self.completionHandler) {
        self.completionHandler(storageData, nil, NO);
    }     
}


@end

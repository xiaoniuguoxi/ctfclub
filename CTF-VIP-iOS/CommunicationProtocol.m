//
//  CommunicationProtocol.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 23/9/15.
//  Copyright (c) 2015 ctf. All rights reserved.
//

#import "CommunicationProtocol.h"
#import "AFNetworking.h"
#import "LocalizationSystem.h"
#import "UserDefaultsUtil.h"

@interface CommunicationProtocol ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation CommunicationProtocol

- (instancetype)init
{
    if (self = [super init]) {
        if (!self.session) {
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            self.session = [NSURLSession sessionWithConfiguration:config
                                                         delegate:nil
                                                    delegateQueue:nil];
        }
        
        self.indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.indicator.layer.cornerRadius = 5;
        self.indicator.opaque = NO;
        self.indicator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.indicator setColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)startIndicator
{
    UIViewController *controller = self.delegate;
    self.indicator.center = CGPointMake(controller.view.center.x, controller.view.center.y);
    [controller.view addSubview:self.indicator];
    [self.indicator bringSubviewToFront:controller.view];
    
    [self.indicator startAnimating];
}

- (void)stopIndicator
{
    [self.indicator stopAnimating];
}

- (void)fetchRequestToUrl:(NSString *)url parameters:(NSDictionary *)parameters tag:(NSString *)tag
{
    [self fetchRequestToUrl:url isPost:NO parameters:parameters tag:tag];
}

- (void)fetchRequestToUrl:(NSString *)url isPost:(BOOL)isPost parameters:(NSDictionary *)parameters tag:(NSString *)tag
{
    [self fetchRequestToUrl:url isPost:isPost parameters:parameters dataDict:nil tag:tag];
}

- (void)fetchRequestToUrl:(NSString *)url isPost:(BOOL)isPost parameters:(NSDictionary *)parameters dataDict:(NSDictionary *)dataDict tag:(NSString *)tag
{
    // show the indicator at status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    // This will make the AFJSONResponseSerializer accept any content type
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;
    
    url = [url stringByAppendingFormat:@"&language=%@", [UserDefaultsUtil getLanguageCode]];
    
    //NSLog(@"fetchRequestToUrl: %@, %@", url, parameters);
    
    if (isPost) {
        [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (dataDict != nil) {
                NSData *data = dataDict[file_data];
                NSString *name = dataDict[file_name];
                NSString *fileName = dataDict[file_filename];
                NSString *mimeType = dataDict[file_mimetype];
                
                [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
            }
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            // hide the indicator at status bar
            [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
            
            [self handleResponse:responseObject tag:tag parameters:parameters];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //NSLog(@"Error: %@", error);
            
            // hide the indicator at status bar
            [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
            
            //[self handleError];
        }];
    } else {
        [manager GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            // hide the indicator at status bar
            [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
            
            [self handleResponse:responseObject tag:tag parameters:parameters];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //NSLog(@"Error: %@", error);
            
            // hide the indicator at status bar
            [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
            
            //[self handleError];
        }];
    }
}

- (void)handleError
{
    [self stopIndicator];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"error", nil)
                                                    message:AMLocalizedString(@"error_server_failure", nil)
                                                   delegate:nil
                                          cancelButtonTitle:AMLocalizedString(@"ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)handleResponse:(id)responseObject tag:(NSString *)tag parameters:(NSDictionary *)parameters
{
    //NSLog(@"JSON: %@", responseObject);
    
    // convert NSDictionary to NSMutableDictionary
    NSMutableDictionary *jsonObject = [responseObject mutableCopy];
    
    if (jsonObject) {
        [jsonObject setValue:parameters forKey:PARAMETER];
        [jsonObject setValue:tag forKey:TAG];
        
        // Some API use out to present "success", some use status, or even without success tag
        NSString *out = nil;
        if (jsonObject[OUT]) {
            out = jsonObject[OUT];
        } else if (jsonObject[STATUS]) {
            out = jsonObject[STATUS];
        } else {
            out = SUCCESS;
        }
        
        if ([[out lowercaseString] isEqualToString:SUCCESS]) {
            if (self.delegate && [self.delegate conformsToProtocol:@protocol(CommunicatorProtocolDelegate)])
            {
                [self.delegate performSelectorOnMainThread:@selector(handleResponse:)
                                                withObject:jsonObject
                                             waitUntilDone:NO];
            }
        } else {
            if (self.delegate && [self.delegate conformsToProtocol:@protocol(CommunicatorProtocolDelegate)])
            {
                [self.delegate performSelectorOnMainThread:@selector(handleError:)
                                                withObject:jsonObject
                                             waitUntilDone:NO];
            }
        }
    }
}

@end

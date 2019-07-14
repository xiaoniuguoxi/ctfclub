//
//  ServiceProductInquiryViewController.m
//  CTF-VIP-iOS
//
//  Created by Winsey Li on 2/10/15.
//  Copyright © 2015 ctf. All rights reserved.
//

#import "ServiceProductInquiryViewController.h"
#import "ActionSheetStringPicker.h"

@interface ServiceProductInquiryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *formAudioLabel;
@property (weak, nonatomic) IBOutlet UIButton *formAudioButton;
@property (weak, nonatomic) IBOutlet UIButton *formPlayButton;

@end

@implementation ServiceProductInquiryViewController
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBarTitleKey = @"title_service_product_inquiry";
    self.showLoginButton = YES;
    self.showLogoutButton = NO;
    
    [self checkCamera];
    self.isAudioRecorded = NO;
    self.formPlayButton.hidden = YES;
    
    // Set the audio file
    /*
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"audio.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    */
}

- (void)reloadLocalization
{
    [super reloadLocalization];
    
    self.formAudioLabel.text = AMLocalizedString(@"audio", nil);
}

- (IBAction)startAudioRecord:(id)sender
{
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // playback via speaker
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
        
        // Start recording
        [recorder record];
        
        [self.formAudioButton setBackgroundColor:[UIColor greenColor]];
        self.formPlayButton.hidden = YES;
    }
}

- (IBAction)touchUpInsideAudioRecord:(id)sender
{
    [self stopAudioRecord];
}

- (IBAction)touchUpOutsideAudioRecord:(id)sender
{
    [self stopAudioRecord];
}

- (void)stopAudioRecord
{
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (IBAction)selectPlay:(id)sender
{
    if (recorder.recording) {
        return;
    }
    
    if (!player.isPlaying) {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        
        [player play];
        
        [self.formPlayButton setImage:[UIImage imageNamed:@"ic_stop"] forState:UIControlStateNormal];
    } else {
        [player stop];
        
        [self.formPlayButton setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
    }
}

- (IBAction)selectSubmit:(id)sender
{
    if ([self validateForm])
    {
        [self.communicator startIndicator];
        
        // Prepare API request
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setValue:[@(self.nameTitlePosition) stringValue] forKey:GENDER];
        [parameters setValue:self.formNameValueTextField.text forKey:NAME];
        [parameters setValue:self.formEmailValueTextField.text forKey:EMAIL];
        [parameters setValue:self.formEnquiryValueTextView.text forKey:ENQUIRY];
        
        if (self.isImageSelected) {
            NSString *imageBase64Binary = [UIImageJPEGRepresentation(self.previewImageView.image, 0.8) base64Encoding];
            [parameters setValue:imageBase64Binary forKey:IMAGE];
        }
        
        NSMutableDictionary *dataDict = nil;
        
        if (self.isAudioRecorded) {
            dataDict = [NSMutableDictionary new];
            NSData *fileData = [[NSData alloc] initWithContentsOfFile:[recorder.url path]];
            dataDict[file_data] = fileData;
            dataDict[file_name] = @"audio";
            dataDict[file_filename] = @"audio.m4a";
            dataDict[file_mimetype] = @"audio/mp4";
        }
        
        [self.communicator fetchRequestToUrl:[HOST_URL stringByAppendingString:ROUTE_INQUIRY] isPost:YES parameters:parameters dataDict:dataDict tag:ROUTE_INQUIRY];
    }
}

- (IBAction)selectReset:(id)sender
{
    [super selectReset:sender];
    
    self.isAudioRecorded = NO;
    self.formPlayButton.hidden = YES;
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    [self.formAudioButton setBackgroundColor:GRAY_COLOR];
    [self.formPlayButton setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
    self.formPlayButton.hidden = NO;
    self.isAudioRecorded = YES;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.formPlayButton setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
}

@end

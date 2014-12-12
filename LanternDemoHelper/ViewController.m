//
//  ViewController.m
//  LanternDemoHelper
//
//  Created by Tucker Sherman on 12/7/14.
//  Copyright (c) 2014 Tucker Sherman. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>



@interface ViewController () <CBPeripheralManagerDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *kitchenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *labSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *acadSwitch;
@property (strong, nonatomic) CBPeripheralManager* bluetoothManager;

@end

@implementation ViewController{
    NSArray* switches;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    switches = @[self.kitchenSwitch, self.labSwitch,self.acadSwitch];
    
    
    if (!self.bluetoothManager)
    {
        self.bluetoothManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    else
    {
        self.bluetoothManager.delegate = self;
    }
    

    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)kitchenSwitchFlipped:(UISwitch *)sender {
    //setup our beacons
    NSUUID* beaconID = [[NSUUID alloc]initWithUUIDString:@"F7826DA6-4FA2-4E98-8024-BC5B71E0893E"];
    NSNumber *power = [[NSNumber alloc] initWithInt:-10];
    NSDictionary *peripheralData = nil;
    [self thereCanBeOnlyOne:sender];

    //broadcast correct signal
    if (sender.tag == 1){
        CLBeaconRegion* kitchenRegion = [[CLBeaconRegion alloc]initWithProximityUUID:beaconID
                                                                               major:309
                                                                               minor:33838
                                                                          identifier:@"ico1"];
        if (sender.on) {
            NSLog(@"kitchen on!");
            peripheralData = [kitchenRegion peripheralDataWithMeasuredPower:power];
            [self.bluetoothManager startAdvertising:peripheralData];
            

        } else {
            NSLog(@"kitchen off!");
            [self.bluetoothManager stopAdvertising];
        }
        
    } else if (sender.tag == 2){
        CLBeaconRegion *workroomRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconID
                                                                                 major:1964
                                                                                 minor:44674
                                                                            identifier:@"5r b0"];
        if (sender.on) {
            NSLog(@"working room on!");
            peripheralData = [workroomRegion peripheralDataWithMeasuredPower:power];
            [self.bluetoothManager startAdvertising:peripheralData];
            
            
        } else {
            NSLog(@"working room off!");
            [self.bluetoothManager stopAdvertising];
        }
        
    } else if (sender.tag == 3){

        
        
        CLBeaconRegion *launchAcademyRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconID
                                                                                      major:44898
                                                                                      minor:64346
                                                                                 identifier:@"FBcc"];
        if (sender.on) {
            NSLog(@"launch academy room on!");
            peripheralData = [launchAcademyRegion peripheralDataWithMeasuredPower:power];
            [self.bluetoothManager startAdvertising:peripheralData];
            
            
        } else {
            NSLog(@"launch academy off!");
            [self.bluetoothManager stopAdvertising];
        }
        
        
    }

}
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    NSLog(@"Updated State!");
    
}

-(void)thereCanBeOnlyOne:(UISwitch*)switchFlipped{
    [self.bluetoothManager stopAdvertising];
    for (UISwitch* swch in switches) {
        if (swch != switchFlipped){
            [swch setOn:NO animated:YES];
        }
            
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

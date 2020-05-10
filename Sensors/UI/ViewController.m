//
//  ViewController.m
//  Sensors
//
//  Created by Alexey Sobolevsky on 09.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import "ViewController.h"
#import "PDMGPSTrackerTableViewCell.h"
#import "PDMVector3TableViewCell.h"
#import "PDMServiceLocator.h"
#import "PDMAccelerometerServiceProtocol.h"
#import "PDMAccelerometerData.h"
#import "PDMGPSTrackerServiceProtocol.h"
#import "PDMGPSTrackerData.h"
#import "PDMUtils.h"

NSTimeInterval const kPDMDataUpdateInterval = 1 / 8.f;

typedef NS_ENUM(NSInteger, PDMTableSection) {
    PDMTableSectionGPS = 0,
    PDMTableSectionAccelerometer,
};

typedef NS_ENUM(NSInteger, PDMAccelerometerProperty) {
    PDMAccelerometerPropertyCurrent = 0,
    PDMAccelerometerPropertyMin,
    PDMAccelerometerPropertyMax,
    PDMAccelerometerPropertyMedian,
    PDMAccelerometerPropertyMean,
    PDMAccelerometerPropertyStdenv,
    PDMAccelerometerPropertyZeroCrossings,
    PDMAccelerometerPropertyCount,
};


@interface ViewController () <UITableViewDataSource, PDMAccelerometerServiceObserver, PDMGPSTrackerServiceObserver>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary<NSNumber *, NSString *> *properties;
@property (nonatomic, strong) id<PDMAccelerometerServiceProtocol> accelerometerService;
@property (nonatomic, strong) PDMAccelerometerData *accelerometerData;
@property (nonatomic, strong) id<PDMGPSTrackerServiceProtocol> gpsTrackerService;
@property (nonatomic, strong) PDMGPSTrackerData *gpsTrackerData;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.properties = @{
              @(PDMAccelerometerPropertyCurrent): @"Current",
                  @(PDMAccelerometerPropertyMin): @"Min",
                  @(PDMAccelerometerPropertyMax): @"Max",
               @(PDMAccelerometerPropertyMedian): @"Median",
                 @(PDMAccelerometerPropertyMean): @"Mean",
               @(PDMAccelerometerPropertyStdenv): @"Stdev",
        @(PDMAccelerometerPropertyZeroCrossings): @"Zero crossings",
                @(PDMAccelerometerPropertyCount): @"Count"
    };
    self.accelerometerService = [PDMServiceLocator serviceForProtocol:@protocol(PDMAccelerometerServiceProtocol)];
    self.accelerometerData = [[PDMAccelerometerData alloc] init];
    self.gpsTrackerService = [PDMServiceLocator serviceForProtocol:@protocol(PDMGPSTrackerServiceProtocol)];
    self.gpsTrackerData = [[PDMGPSTrackerData alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.accelerometerService registerObserver:self timeinterval:kPDMDataUpdateInterval];
    [self.gpsTrackerService registerObserver:self timeinterval:kPDMDataUpdateInterval];
    [self.gpsTrackerService startUpdates];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.accelerometerService removeObserver:self];
    [self.gpsTrackerService removeObserver:self];
    [self.gpsTrackerService stopUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case PDMTableSectionGPS: return @"GPS";
        case PDMTableSectionAccelerometer: return @"Accelerometer";

        default: return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case PDMTableSectionGPS: return 1;
        case PDMTableSectionAccelerometer: return self.properties.count;

        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case PDMTableSectionGPS: {
            PDMGPSTrackerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GPSTrackerCell" forIndexPath:indexPath];
            [self configureGPSTrackerTableViewCell:cell];
            return cell;
        }

        case PDMTableSectionAccelerometer: {
            PDMVector3TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Vector3Cell" forIndexPath:indexPath];
            [self configureVector3TableViewCell:cell forIndex:indexPath.row];
            return cell;
        }

        default: break;
    }
    return nil;
}

- (void)configureGPSTrackerTableViewCell:(PDMGPSTrackerTableViewCell *)cell
{
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f m", self.gpsTrackerData.distance];
}

- (void)configureVector3TableViewCell:(PDMVector3TableViewCell *)cell forIndex:(NSUInteger)index
{
    cell.propertyLabel.text = self.properties[@(index)];
    PDMVector3 vector3;
    switch (index) {
        case PDMAccelerometerPropertyCurrent:       vector3 = self.accelerometerData.current; break;
        case PDMAccelerometerPropertyMin:           vector3 = self.accelerometerData.min; break;
        case PDMAccelerometerPropertyMax:           vector3 = self.accelerometerData.max; break;
        case PDMAccelerometerPropertyMedian:        vector3 = self.accelerometerData.median; break;
        case PDMAccelerometerPropertyMean:          vector3 = self.accelerometerData.mean; break;
        case PDMAccelerometerPropertyStdenv:        vector3 = self.accelerometerData.stdev; break;
        case PDMAccelerometerPropertyZeroCrossings: vector3 = self.accelerometerData.zeroCrossings; break;
        case PDMAccelerometerPropertyCount: {
            NSUInteger count = self.accelerometerData.count;
            vector3 = (PDMVector3) {.x = count, .y = count, .z = count };
            break;
        }
        default: break;
    }

    cell.xValueLabel.text = [NSString stringWithFormat:@"x: %.6f", vector3.x];
    cell.yValueLabel.text = [NSString stringWithFormat:@"y: %.6f", vector3.y];
    cell.zValueLabel.text = [NSString stringWithFormat:@"z: %.6f", vector3.z];
}

#pragma mark - PDMAccelerometerServiceObserver

- (void)accelerometerDidUpdateWithData:(PDMAccelerometerData *)accelerometerData
{
    self.accelerometerData = accelerometerData;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - PDMGPSTrackerServiceObserver

- (void)gpsTrackerDidUpdateWithData:(PDMGPSTrackerData *)gpsTrackerData
{
    self.gpsTrackerData = gpsTrackerData;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end

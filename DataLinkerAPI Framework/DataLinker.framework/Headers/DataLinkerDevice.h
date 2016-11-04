//
//  DataLinkerDevice.h
//  DataLinkerAPI
//
//  Created by Julius Petraška on 11/2/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//

#import <Foundation/Foundation.h>

/* --
 Those are the types of data format that might be provided by DataLinker.
 -- */
typedef enum {
    NMEA0183,
    SignalK
} DataLinkerDataFormat;

@class DataLinker;
/* --
 DataLinkerDelegate protocol is used to communicate new data and errors 
 received by DataLinker.
 -- */
@protocol DataLinkerDelegate <NSObject>

- (void)dataLinker:(DataLinker*)dataLinker
    didReceiveData:(NSString*)data
        withFormat:(DataLinkerDataFormat)format;

- (void)dataLinker:(DataLinker*)dataLinker
  didStopWithError:(NSError*)error;

@end

/* --
 These are here only to assure complier that such classes do exists.
 -- */
@class GCDAsyncSocket;
@class PSWebSocket;
@class Simulator;

@interface DataLinker : NSObject  {
    GCDAsyncSocket *tcpSocket;
    PSWebSocket *webSocket;
    Simulator *simulator;
}

/* --
 A delegate of DataLinker object. It will receive the data stream and errors.
 -- */
@property (nonatomic, weak) id <DataLinkerDelegate> delegate;

/* --
 This property specifies what format the data is. 
 Available formats: NMEA0183, SignalK
 -- */
@property (nonatomic, readonly) DataLinkerDataFormat dataFormat;

/* --
 These two methods should never be called manually. 
 They are used by DataLinkerAPI.
 -- */
+ (DataLinker*)dataLinkerWithData:(NSDictionary*)data;
- (void)stop;
@end

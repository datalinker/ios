**To install DataLinkerAPI to your project follow these steps:**

1. Download "DataLinker integration library"
3. Drag&Drop "DataLinkerAPI" folder to your xCode project navigator.
2. Check "Copy items if needed" checkbox.
3. Select "Create groups" option and press "Finish".
4. Import header in your project:
	#import "DataLinkerAPI.h"
5. Your'e good to go. 



**User guide:**

1. First of all you need to initiate DataLinkerAPI instance like this:
	DataLinkerAPI *dataLinkerManager = [[DataLinkerAPI alloc] initWithCallbackURLScheme:yourCustomURLScheme];

_* - for more information about URL schemes please see Apple documentation of Inter-App communication:
https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html_


2.To establish connection with DataLinker generate URL using this method of DataLinkerAPI instance:

_- (NSURL*)urlForConnectingToDataLinkerWithUUID:(NSString*)pid 
				      baudRate:(int)brate
				   warnVoltage:(int)wvoltage 
				       tcpPort:(int)port;_


where:
	"pid" is peripheral, which you want to connect to, identifier. (If you pass empty value, if possible DataLinker Server app will connect to last connected DataLinker, if not it will allow user to select DataLinker manually)
	"brate" is desired baudRate you want to set for peripheral. (If not specified DataLinker Server app will set it to default value (19200))
	"wvoltage" is desired warn. voltage you want to set for peripheral. (If not specified DataLinker Server app will set it to default value (8))
	"port" is TCP port over which you want to receive NMEA stream. (If not specified DataLinker Server app will set it to default value (2000))


3.Then open it using [[UIApplication sharedApplication] openURL:]


4.After connection was established DataLinker App will switch back to your app with some response information. To access that information you either need to manipulate URL from your AppDelegate's method _"- (BOOL)application:openURL:options:"_ and retrieve the information yourself or to pass that URL to your initialized DataLinkerAPI instance via function _"- (NSDictionary*)dataLinkerResponseWithURL:(NSURL*)url"_ like this:

	_NSDictionary *responseDict = [yourDataLinkerAPIInstance dataLinkerResponseWithURL:url];_

It will return you dictionary with all response data. For more information about returned dictionary please see DataLinkerAPI.h.


5.The last step is to start TCP socket with the port that was specified in DataLinker Server response to your app.


Check our example application to see how it works.
	- DataLinkerIntegrationController class handles everything related to integration with DataLinker.
## Installation guide:

1. Clone or download the contents of repository.
2. Copy _**DataLinker.framework**_ file from _**DataLinkerAPI Framework**_ directory to your xcode project. You can jus drag&drop it there but make sure that _**Copy items if needed**_ is checked.
3. In your target's or project's _**Build settings**_, under _**Other Linker Flags**_, add _**-lz**_ entry if it does not exists.
4. In your target's _**General**_ section scroll down to the bottom, and make sure that _**DataLinker.framework**_ is in _**Embeded binaries**_. If its not there, add it.
5. In your target's _**Info**_ section scroll down to section _**URL Types**_, expand it and tap _**+**_ button to add new URL type. Specify your desired URL type identifier and _**URL scheme**_. This, newly created URL scheme will be used by DataLinkerAPI to communicate between your app and _**DataLinker Server**_ app.
6. In your project's _**info.plist**_ file add _**datalinker**_ to _**LSApplicationQueriesSchemes**_ array, or simply add these lines of code:
```
<key>LSApplicationQueriesSchemes</key>
<array>
<string>datalinker</string>
</array>
```

7. Implement `- (BOOL)application:openURL:options:` method in AppDelegate to receive response from _**DataLinker Server**_ app. How that should be handled you can see in our example application. It is also described in _**User guide**_.
8. Thats it. You're about good to go. Please check our _**User guide**_ and example application for API usage examples.




## User guide:

### 1. Setting callback URL scheme:
First thing you need to do in your app to start using DataLinkerAPI is tell API about your callback URL scheme. This is the scheme that you should've created in 5th step of installation guide. You can do it this way:
```
[DataLinkerAPI setCallBackScheme:@"YourCallbackScheme"];
```

### 2. Connecting to DataLinker
The connection will be handled by DataLinker Server app, but the data will be streamed to your app. To do that you need to call +(void)connect method of DataLinkerAPI. It will switch to _**DataLinker Server**_ app, and once the connection is estabilished it will return to your app.
```
[DataLinkerAPI connect];
```

### 3. Handling DataLinker connection
As described in point _**2**_ of _**User guide**_, after the connection is estabilished _**DataLinker Server**_ returns to your app. But for _**DataLinker Server**_ to be able to do that you have to implement `- (BOOL)application:openURL:options:` method of your AppDelegate, and return `true`. 

Before returning `true` you have to either save the value of URL that was passed as a parameter to this method, or pass it to some method of some class that will handle _**DataLinker**_ connection. 

After you have that URL at the place you need it to be, you should call `+(DataLinker*)handleResponseURL:(NSURL*)url` method of _**DataLinkerAPI**_. 

If the response states that successful connection was estabilished, it will return you `DataLinker` object, which will provide you with data, if no, it will return `nil`.

```
DataLinker *dataLink = [DataLinkerAPI handleResponseURL:receivedURL];
if (dataLink) {
//Connection was successful
} else {
//Either the connection was unsuccessful or the user disconnected from DataLinker.
}
```
**P.S.** Please keep the reference of returned DataLinker object, because you will need it later.

### 4. Receiving data from DataLinker
To receive data of DataLinker object that you received from DataLinkerAPI method described in point _**3**_ of this _**User guide**_, you have to conform to _**DataLinkerDelegate**_ protocol, and set an object of class that comforms to that protocol as a delegate of _**DataLinker**_ object.
```
dataLink.delegate = self;
```
**P.S.** Protocol description can be found in _**DataLinker.framework/Headers/DataLinkerDevice.h**_.

### 5. Disconnecting from DataLinker
To disconnect from _**DataLinker**_ you have to call `+(void)disconnect` method of _**DataLinkerAPI**_. It wil switch to _**DataLinker Server**_ app, disconnect from connected DataLinker and return to your app with disconnection response.


## Where to go from here?
If you still have questions, please either review our example application, or send me a letter to julius@xplicity.com.

# RECAPP iOS

RECAPP iOS enables researchers to deliver longitudinal memory tests in-the-wild direct to study participant mobile devices including iPhone and iPad.

### Prerequisities & Configuration
RECAPP iOS requires a RECAPP Web Service implementation to be running on an accessible server, for more details please visit the [RECAPP Web Service](https://github.com/Recall-Project/recapp-web-service) github page. The project has been developed against Xcode 10 and has been tested upto iOS 8.1. Before compiling ensure that the 'host' key/value pair is set in the following plist project file with the host of the configured RECAPP Web Service:
```sh
RECAPP/Supporting Files/recapp_configuration.plist
```
Also ensure that an associated bundle identifier is included with your available iOS developer/distribution account.

### Development & Attribution
The RECAPP Framework was developed by Lancaster University and Essex University as part of the EU funded [RECALL Project] (http://recall-fet.eu).The Recall project acknowledges the financial support of the Future and Emerging Technologies (FET) programme within the 7th Framework Programme for Research of the European Commission, under FET grant number: 612933. We kindly ask that any re-use of the RECAPP codebase as part of an application or future research is clearly attributed.   

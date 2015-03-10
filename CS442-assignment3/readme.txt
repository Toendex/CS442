Implemented (1) and (2) in Recommended Extras for MP3;

The initial time-limit is 3.0 sec (start counting after the “dropping animation” is finished). It’s hard coded. If you want to change it, the initialization code is in (or near) line 29 of ViewController.m

Set the _timeInterval to 0.0, and you can see the computer play to itself automatically.

The automatic moving which caused by time-out will never happens in the same time with user acted moving. And no moving will happens if it’s animating the “dropping animation”. So, if you set the _timeInterval too small (like 0 or 0.1), it will be hard to act your own moving. 
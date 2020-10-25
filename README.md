# LocationAuthSampleForiOS14
Think Precise Location Auth.

From iOS 14, user can choose whether to use accurate location information.  
When a dialog of location service shows, we can check this function.  
The difference is location's range.  

|Precise: On|Precise: Off|
|:--:|:--:|
|<img width="467" alt="スクリーンショット 2020-10-26 3 14 11" src="https://user-images.githubusercontent.com/8732417/97115335-9b3d6980-1739-11eb-8987-e17289fda801.png">|<img width="467" alt="スクリーンショット 2020-10-26 3 14 18" src="https://user-images.githubusercontent.com/8732417/97115339-9f698700-1739-11eb-9ade-6e89f06c425d.png">|

User can change settings of precise

This sample app prepared the Settings screen.  
We can get status for precise auth status.  
So If user setted reducedAccuracy, we can bring up a dialog and ask for permission only once.  
However, even if user allow it here, it will be turned off when user restart the app.

|Settings|Allow Once|
|:--:|:--:|
|<img width="467" alt="スクリーンショット 2020-10-26 3 19 17" src="https://user-images.githubusercontent.com/8732417/97115552-9c22cb00-173a-11eb-864e-3b2310262e2d.png">|<img width="467" alt="スクリーンショット 2020-10-26 3 19 52" src="https://user-images.githubusercontent.com/8732417/97115555-a1801580-173a-11eb-9b7b-7812722409fc.png">|

User can turn On at the App's Location Service Screen on Settings.app.

<img width="467" alt="スクリーンショット 2020-10-26 3 28 06" src="https://user-images.githubusercontent.com/8732417/97115683-4bf83880-173b-11eb-9709-0832f545530c.png">

I think it is important to clarify to the user  
why they use location information and why they get accurate location information.

# HSHacks2-iOS

<h2>Screenshots</h2>
![alt tag](http://i.imgur.com/ltS1p3R.gif)
![alt tag](http://i.imgur.com/SkNR2Ve.gif)

(To run the app, you're going to have to add www.fabric.io or comment out twitter code. Keep in mind pretty much nothing will work immediately as you have to add your own Parse/Firebase info, as explained below.)

<h2>Getting Started</h2>
(This project uses cocoapods, so make sure to do a pod install in the directory to get all necessary frameworks)

Hey! If you want to customize parts of this app, follow these instructions:

1. Change the stuff in sharedInstance in <b>HSHackathonManager</b>. (logo, hackathon name, firebasechaturl, parse stuff)
    - Apologies for the way logo works, our HSHacks logo is not a square so the dimensions for your logo will likely be off. Go to HSLoginViewController and change the logo sizes/magnification to whatever you like. 
 
2. Change the color scheme below.
    - The primary color is color for nav bar, tab bar tint
    - The secondary color should be darker, used for the logistics tab's cell (fake) headers
    - The third color is the color of the countdown shade.
 
3. I had to make this app super quickly, so I used storyboard :/ So if you want to change fonts, you'll have to go into storyboard and change all the fonts. Right now it uses Open Sans for all the body text (pretty standard) and DIN Condensed Bold for nav bar/login logo animation.
 
4. For login with facebook, you're going to have to replace all the facebook app id stuff in the Info.plist. 

5. Login with twitter is slightly more complicated as we're using their new Fabric framework, which makes integration super easy but sharing code a bit harder.
   - I deleted our own Fabric account, so the best thing do to here is to <b>go to www.fabric.io and manually add fabric again to this project.</b> Code is the same.
 
6. For Parse:
    - You're going to need 4 parse classes
        - Announcements
            1. title (string) 2. body (string) 3. sender (string) 4. category (string, right now app is configured to take important, general, food, workshops)
        - Schedule
            1. name (string) 2. description (string) 3. time (date)
        - Workshops (you can change this to something like awards or tech talks if you don't have workshops?)
            1. name (string) 2. description (string) 3. time (date)
        - Concierge (confusingly called 'mentors' in HSHacks' case)
            1. name (string) 2. company (string) 3. contactInfo (string - @sample, sample@sample.com, 4081231234) 4. contactType (string - twitter, phone, email) 5. skills (string)
    - If you decide to use different parse classes or rename them, make sure to change the parse class name in each class. It's a constant at the top of each class.
 
7. To change the times of the countdown timer, go into HSLogisticsViewController and change the constants at the top to what your hackathon times are. 
 
8.  Again, apologies for using storyboard/making some stuff weird (containers). Feel free to change anything, but give credit where credit is due :)
    
You probably have complaints or questions, so find me on facebook or github issue or something.
 
Made by Spencer Yen, Aakash Thumaty and Alex Yeh

<h3>To do</h3>
- Fix chat UI sending double messages
- Prevent empty messages from being sent
- Make LoginVC root view controller
- Use autolayout so frames don't have to be adjusted when loaded
- Rely less on singleton and NSUserDefaults (lol)
- General cleaning up
- Ideally, slowly stray away from storyboard 


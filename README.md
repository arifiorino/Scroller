# Scroller

Scroller is a MacOS accessibility app which allows you to scroll with one finger.
This is useful if you're using a stylus to control your trackpad.

Here are the steps to get it working:
1. Clone the repository and open the project in Xcode.
2. Build the app locally with ⌘-B.
3. The compiled app will be in `~/Library/Developer/Xcode/DerivedData/Scroller-.../Build/Products/Debug` where `...` is a long string of characters.
4. Run the app and you will get a popup that it doesn't have permissions.
5. Accept the permissions in the popup.
6. Run the app again and it will work.

Then all you need to do is hold down the option key and move the trackpad to scroll.


All the code is in `AppDelegate.swift` and it is very simple (only 60 lines long).
You can also change the constants in `AppDelegate.swift` to whatever configuration you want.
This allows you to change the speed of the scrolling (`SCROLL_SPEED`) and which key triggers the scrolling (`SCROLL_FLAG`).

Contributions are welcome!

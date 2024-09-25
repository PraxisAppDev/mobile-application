# App Dev General Dynamics Project

Description goes here

## Install Instructions

### Installing Flutter

You can also watch this [video](https://www.youtube.com/watch?v=f09c-nw15K8&t=165s) to Install Flutter, it may be easier.

- Go to this [website](https://docs.flutter.dev/get-started/install/macos/web) to see how to install the Flutter SDK
- Scroll down to the heading “Install the Flutter SDK”
- Click the tab that says “Download and install”
- You should see two zip files, one that says “Intel Processor” and another that says “Apple Silicon”. To know which one you should download, click the Apple logo on the top left of your screen. Then click “About This Mac”. The first property should tell you whether your Mac uses an Intel chip or an Apple chip. If your Mac uses an Intel chip, download the first zip file. If your Mac uses an Apple chip, download the second zip file. 

- (Optional, but recommended) Create a directory where you want to store the Flutter SDK
- Next is to add Flutter to the PATH environment variable. Open a new terminal window and open the file ~/.zshenv using your preferred text editor (vim, nano, etc.)
- Copy the following line at the end of your ~/.zshenv file: `export PATH=$HOME/development/flutter/bin:$PATH`
- Save your ~/.zshenv file with the following command: `source ~/.zshenv`
- Confirm that Flutter has been installed with the following command: flutter doctor

### Get a working local copy of the Afterhours code
- Navigate to the directory where you want to store your local copy of the Afterhours code, then create a local copy of the Afterhours code: `git clone https://github.com/PraxisAppDev/mobile-application.git`
- Once you open the code in an IDE of your choice (VS Code, Android Studio, etc.), navigate to the “client” directory and run flutter pub get to get Dart packages for Flutter

### Using the app
- You should be done with the set up, and can now run flutter run to test the app
- You will be prompted to enter a number to select which browser you want to run the app, as shown below
- After about 15-30 seconds, the app should open up in the browser that you chose

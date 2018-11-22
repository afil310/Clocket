# Clocket

[![Swift 4.2](https://img.shields.io/badge/swift-4.2-orange.svg)](https://developer.apple.com/swift/) [![Platform](https://img.shields.io/badge/platform-iOS-brightgreen.svg)](https://cocoapods.org/pods/Clocket) [![CI Status](https://api.travis-ci.org/afil310/Clocket.svg)](https://travis-ci.org/afil310/Clocket) [![Version](https://img.shields.io/cocoapods/v/Clocket.svg?style=flat)](https://cocoapods.org/pods/Clocket) [![License](https://img.shields.io/badge/licence-MIT-blue.svg)](https://cocoapods.org/pods/Clocket)

## Description
`Clocket` is an iOS framework written in Swift 4.2 that makes it easy to create and customize clock views. 
<p align="center"><img src ="https://raw.githubusercontent.com/afil310/Clocket/master/Example/Screenshots/Clocket%20iPhone%20XR.png" width="300px"/> <img src ="https://raw.githubusercontent.com/afil310/Clocket/master/Example/Screenshots/Clocket%20demo.gif" width="300px"/></p>

## Features
- Real time or custom time clock
- Time setting by dragging or tapping clock hands
- Countdown timer
- Delegate method call on timer expiring
- Reverse time
- Custom time speed from -10X to 10X
- Customizable clock hands: size, shape, color, shadow
- Customizable clockface: logo, digits, marks, fonts, colors

## Requirements

- iOS 11.0+
- Xcode 10.0
- Swift 4.2

## Installation

`Clocket` is available through [CocoaPods](https://cocoapods.org). 
To be able to use the framework in your project:
1. Install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#toc_3) on your computer:
```ruby
$ sudo gem install cocoapods
```
2. Create a [Podfile](https://guides.cocoapods.org/using/the-podfile.html) in your project directory and add the dependency:
```ruby
use_frameworks!
platform :ios, '11.0'
target 'MyApp' do
  pod 'Clocket'
end
```
3. Run `pod install` in the project directory:
```ruby
$ cd <path/to/your/project/directory>
$ pod install
``` 
4. Open `MyApp.xcworkspace` in Xcode and build.
5. From now on you can import and use the framework in your code:
```swift
import Clocket
```

## Usage
1. Import the framework into ViewController.swift.
2. Add a UIView into storyboard/xib file, and change it's class to `Clocket` in the identity inspector.
3. Connect the view to variable `clock` in the ViewController.
4. Set the real time property to `true`.
5. Make `startClock()`  call to start the clock.

```swift
import Clocket                            //1
class ViewController: UIViewController {  
    @IBOutlet weak var clock: Clocket!    //3
    override func viewDidLoad() {
        super.viewDidLoad()
        clock.displayRealTime = true      //4
        clock.startClock()                //5
    }
}
```

For more code examples on `Clocket` usage see the example project.

## Author

Andrey Filonov, andrey.filonov@gmail.com

## License

`Clocket` is available under the MIT license. See the LICENSE file for more info.


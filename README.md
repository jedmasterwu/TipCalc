# Pre-work - *Tip Calculator*

**TipCalc** is a tip calculator application for iOS.

Submitted by: **Wuming Xie**

Time spent: **16** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:
* [x] Light/Dark theme for the app
* [ ] Giving suggested tip amounts like on a restaurant bill

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/b1RBnub.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Project Analysis

As part of your pre-work submission, please reflect on the app and answer the following questions below:

**Question 1**: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")

**Answer:**

My impression so far is that it's easy to jump in and start coding, but it takes a lot of time and effort to make things up to the standards we are used to in a professional app. Making the most basic version of the app wasn't super hard. Simply following the tutorial and playing around with the storyboards was enough. However, creating a well polished, good looking, functional UI required a lot more reading and research. It's also been very fun and rewarding to make this app.

Outlets are references to specific UI elements in your storyboard. Actions are the functions that get called when some specific event happens to an element or view. The IBOutlet and IBAction keywords are used by Xcode and the Interface Builder to determine which properties and functions are outlets and actions. From looking at the source of the storyboard, each outlet has a property attribute which has the name of the reference in the view controller and a destination property which maps it to the UI element in the storyboard.

**Question 2**: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"

**Answer:**

Short version:
If a class has a strong reference to a closure which also happens to capture a reference to that class, a strong reference cycle is created.

Longer version:
Closures can store references to any constants or variables from the context in which it was created. This is useful because closures can make changes to those stored references even if the original scope that created those variables is no longer extant. [Closures are also reference types](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html#//apple_ref/doc/uid/TP40014097-CH11-ID104). Having these two properties creates the opportunity for strong reference cycles to be created.

Consider a class which has a property which is a lazy var and stores a reference to a closure. Inside the closure there are references to self. This is allowed since lazy vars are only created when they are used, and they can only be used after the class has been initialized so self is known to exist.  With this we have created a strong reference cycle.


## License

    Copyright [2017] [Wuming Xie]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

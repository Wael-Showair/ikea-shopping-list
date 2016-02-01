# README #

iKea Shopping List is an app to improve the overall user experience of user while creating list of items to pick-up from different aisles in iKea Store.

### Summary ###

* iKea provides pencil & paper for clients so that they can construct their shopping lists where they should add details for each item such as price, quantity & pick-up information such as aisle number and bin number. I found this is an overhead for me while shopping so I decided to create this app. This is my attitude in life, solve problems using software.


### App Features ###


* The app creates users' shopping lists in smart way by auto detecting all the shopping items details using the camera in any iPhone device.
* The app is very useful when the user picks-up all the items that he/she decided to buy. By default, the shopping lists are grouped by aisle number.
* The app helps users to sort the shopping list by price so that he/she can filter out the most expensive items in the list.

### Technical Details ###

* Objective C is the programming language to develop the app.
* Interface Builder Storyboards is used to design UI of the app using Auto Layout.
* All screens layouts are implemented using Auto layout framework to have flexible UI for different mobile screens (Starting from iPhone 4s till iPhone 6s). Auto Layout is even used programatically to add constraints to some UI Controls using Visual Format Language.
* UI Testing and Unit Tests are included in the app to make sure that code is functional correctly. I would recommned to run these tests to have a quick overview about what features have been implemented in the project up till now. **Please Note that Camera can't be opened in Simulator, you have to use real device for testing**.
* Code Coverage percentage can be calculated after all Unit/UI Tests then can be displayed within Xcode IDE.
* AVFoundation framework is used to create completely custom camera preview and controls.
* Core Image is used for image processing to detect upright text in the camera preview.
* TextKit and CATextLayer are used in character animation using completely custom label.
* Two Sided door animation is created in this app using Core Animation framework without using any third-party libraries/frameworks. 
* Code Documentation (in HTML format) is generated from code comments using [HeaderDoc.](https://developer.apple.com/library/prerelease/mac/documentation/DeveloperTools/Conceptual/HeaderDoc/intro/intro.html) Find it in "documentation" folder in this repository
* All initial phases of app UI/UX design are on the repository so that you can see how did I improve the UI/UX for each screen. Find them on "ui/ux" folder in this repository.
* Don't forget to check the wiki where I document some technical information for myself.

### Contact Me ###

* For further questions or discussion, [email me](mailto:showair.wael@gmail.com) or check [my personal website](http://waelshowair.com) 
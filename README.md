# ASOS Exercise

# Just a brief note
Because of lack of time, in this project I did not had the opportunity to reflect what is my normal day as a developer.
I did not create branches (did committed everything directly in `master` and my commits were not detailed).

# SpaceX
SpaceX is a project created with Swift 5 and UIKit.

The app consists of presenting a list with all the launches of advanced rockets, apply a filter date and give the possibility to user access more information about them.

## Exercise note

In the exercise, it was mentioned that we should show a success or failure icon depending on if the launch was succeded or not. However, in this new API (V4) I noticed that some *launches* were being retrieved with `null`. For this cases I've decided to show a warning icon ⚠️.

# Architecture
This projected was created with VIP architecture.

"The Clean Swift architecture is using a VIP cycle to help you separate logic in your application. The VIP cycle consists of a ViewController, Interactor and a Presenter. All classes are responsible for some logic. The ViewController is responsible for the display logic, the Interactor is responsible for the business logic and the Presenter is responsible for the presentation logic."

https://zonneveld.dev/the-clean-swift-architecture-explained/

![alt text](https://zonneveld.dev/wp-content/uploads/2019/05/VIP-CleanSwift-cycle.png)

Apart from this 3 layers, this app has one more that is the `router`. `Router` is the layer responsible for the navigation between screens. The image gives a better illustration in how `Router` fits in VIP architecture.

![alt text](https://miro.medium.com/max/1400/1*eSER5qbVsRS4snwmVp64Tg.png)

# Dependencies
The project has no third-party dependencies.

# Unit tests
This project has Unit Tests and UI Test

Although I did not covered all the cases (not even close), I think the unit tests I've implemented can give you a perception in how modular is this project and how flexible is to implement unit tests.

Unfortunately the UI Tests are very very basic. They need mocks, they need to be better structure, definitely this is something that needs a big improvement.


**NOTE**

I'm sorry but I did not have time to investigate why after we run UI Tests, when we launch the app, it appears with a black background screen under the tableView. I tried to do a quick investigation and I found some people saying that this might be caused by an XCode issue.
In order to fix this, we need to reset the simulator 😩

# API
The API used for this project was V4 that is documented [here](https://github.com/r-spacex/SpaceX-API/tree/master/docs#rspacex-api-docs).

# Improvements
1. UI
2. Improve Network Reachability and improve integration with UI/Network actions
3. Try to reduce/clean some methods from View/Interator/Presenter protocols (maybe using a single method that receives an enum action)
4. Apply a big improvement on error handling
5. Give a loading feedback to the user (one example is when app is fetching next launches page)
6. Improve `Launch.Request` model (V4 is a bit painful)
7. *Image loader* (used on cells to retrieve images from network) must be improved in order to be testable
8. Add more unit tests
9. Add many more UITests and implicity create mock data in order to be able to run without being dependent on external data (internet)
10. ...

(I'm sure there are more improvements to do but in my opinion, these are the most notorios ones)

# QA tests
For manual tests, I've used the XCode iPhones 12 and 8 (iOS 15.0) from simulator.

There might be some edge cases that I did not found. I apologize for that.

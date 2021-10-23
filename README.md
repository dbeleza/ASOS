# ASOS Exercise

# Just a brief introduction
Because of lack of time, in this project I did not had the opportunity to reflect what is my normal day as a developer.
I did not create branches (did committed everything directly in `master` and my commits were not detailed).

# SpaceX
SpaceX is a project created with Swift 5.0.
It uses UIKit (although I really want to start working with SwiftUI).

The app main propose is to show all the launches of advanced rockets and give the possibility to user access more information about them.

# Architecture
This projected was created with VIP architecture.

"The Clean Swift architecture is using a VIP cycle to help you separate logic in your application. The VIP cycle consists of a ViewController, Interactor and a Presenter. All classes are responsible for some logic. The ViewController is responsible for the display logic, the Interactor is responsible for the business logic and the Presenter is responsible for the presentation logic."

https://zonneveld.dev/the-clean-swift-architecture-explained/

![alt text](https://zonneveld.dev/wp-content/uploads/2019/05/VIP-CleanSwift-cycle.png)

# Dependencies
The project has no third-party dependencies.

# Unit tests
This project has Unit Tests and UI Test

Although I did not covered all the cases (not even close), I think the unit tests I've implemented can give you a perception in how modular is this project and how flexible is to implement unit tests.

Unfortunately the UI Tests are very very basic. They need mocks, they need to be better structure, definitely this is something that needs a big improvement.


**NOTE**

I'm sorry but I did not have time to investigate why after we run UI Tests, when we launch the app, it shows with a background black screen. I tried to do a quick investigation and there are people saying that this might be caused by an XCode issue.
In order to fix this, I needed to reset my simulator. :(

# API
The API used for this project was V4 that is documented here https://github.com/r-spacex/SpaceX-API/tree/master/docs#rspacex-api-docs

# Improvements
1. UI
2. Improve Network Reachability and improve integration with UI actions
3. Try to reduce/clean some methods from View/Interator/Presenter protocols (maybe using a single method that receives an enum action)
4. Apply a big improvement how error handling is being done
5. Give loading feedback to the user (when app is fetching next launches page)
6. Improve `Launch.Request` model (V4 is a bit painful)
7. Add persistance
8. Image loader must be testable

**I'm sure there are more improvements to do but I am here, eager to improve myself as a developer. Hope to count with your help.**

# QA tests
For manual tests, I've used the XCode iPhones 12 and 8 (iOS 15.0) from simulator.

There might be some edge cases that I did not found. I apologize for that.

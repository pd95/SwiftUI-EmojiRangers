# Emoji Rangers

The code is based on the sample project for the ["Widgets Code-Along"](https://developer.apple.com/wwdc20/10034) video series of Apples WWDC20:

  [https://developer.apple.com/documentation/widgetkit/building_widgets_using_widgetkit_and_swiftui](https://developer.apple.com/documentation/widgetkit/building_widgets_using_widgetkit_and_swiftui)
    
I started with the "part 1" project and went on with my own code.

The following differences are note worthy:

- the `DynamicCharacterSelection` intent is "shortcut app"-enabled
- when visiting a character detail page, the corresponging Siri intent is donated (enabling the siri based surfacing of widgets)
- when a donated intent is selected later again, the app is handling this NSUserActivity and opens the details screen.


Here follows the regular README:

-----------------------------------

# Building Widgets Using WidgetKit and SwiftUI

Create widgets to show your app's content on the Home screen, with custom intents for user-customizable settings.

## Overview

- Note: This sample code project is associated with WWDC20 session [10034: Widgets Code-Along, Part 1: The Adventure Begins](https://developer.apple.com/wwdc20/10034/); session [10035: Widgets Code-Along, Part 2: Alternate Timelines](https://developer.apple.com/wwdc20/10035/); and session [10036: Widgets Code-Along, Part 3: Advancing Timelines](https://developer.apple.com/wwdc20/10036/).

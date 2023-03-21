
# BottomSheetView
A SwiftUI implementation of a BottomSheetView, a resizable and draggable container that can be displayed over other content. This is useful for displaying additional information, options, or menus without navigating to  a separate view.
## Features
 - Resizable and draggable bottom sheet
 - Automatically adjusts for safe area insets
 - Allows tap-to-dismiss functionality
 - Customizable content view

## Installation
Simply copy the `BottomSheetView.swift` file into your SwiftUI project. 

## Usage
### Basic Usage
To use `BottomSheetView`, first add the `BottomSheetModifier` to the view you want to display as a Sheet View. Provide a binding to a boolean property to control the visibility of the bottom sheet.

``` swift
struct ContentView: View {
    
    @State var isBottomSheetShown = false
    
    var body: some View {
        ZStack{
            VStack {
                Button(action: {
                    isBottomSheetShown.toggle()
                }) {
                    Text("Show Bottom Sheet")
                }
            }
            VStack(spacing: 8){
                ForEach(Array(1...7), id: \.self) { number in
                    Text("\(number). Item")
                        .foregroundColor(Color.black)
                }
            }.modifier(BottomSheetModifier(isShown: $isBottomSheetShown))
        }
    }
}
```

### Wrap Usage
To use BottomSheetView and wrap the height of the content, simply replace the modifier with `BottomSheetWrapModifier`

``` swift
import SwiftUI

struct ContentView: View {
    
    @State var isBottomSheetShown = false
    
    var body: some View {
        ZStack{
            VStack {
                Button(action: {
                    isBottomSheetShown.toggle()
                }) {
                    Text("Show Bottom Sheet")
                }
            }
            VStack(spacing: 8){
                ForEach(Array(1...7), id: \.self) { number in
                    Text("\(number). Item")
                        .foregroundColor(Color.black)
                }
            }.modifier(BottomSheetWrapModifier(isShown: $isBottomSheetShown))
        }
    }
}
```

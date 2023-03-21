//
//  BottomSheetView.swift
//
//  Created by Muhammad Ghifari on 09/04/22.
//

import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    
    @GestureState private var translation: CGFloat = 0
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color.white)
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}

struct BottomSheetWrapModifier:ViewModifier{
    
    @Binding var isShown: Bool
    @State private var frame: CGFloat = 0
    @State private var bottomSafeArea: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack{
                Rectangle().foregroundColor(.black).opacity(isShown ? 0.4 : 0).onTapGesture {
                    isShown.toggle()
                }
                BottomSheetView(
                    isOpen: $isShown,
                    maxHeight: frame == 0 ? geometry.size.height * 0.9 : frame
                ) {
                    VStack{
                        content
                            .onAppear{
                                if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                                    bottomSafeArea = window.safeAreaInsets.bottom
                                }
                            }
                        Spacer()
                            .frame(height: bottomSafeArea)
                    }.background(ViewGeometry()).onPreferenceChange(ViewHeightKey.self){
                        frame = $0 > geometry.size.height * 0.9 ? geometry.size.height * 0.9 : $0
                    }
                }.foregroundColor(.white)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct BottomSheetModifier:ViewModifier{
    
    @Binding var isShown: Bool
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack{
                Rectangle().foregroundColor(.black).opacity(isShown ? 0.4 : 0).onTapGesture {
                    isShown.toggle()
                }
                BottomSheetView(
                    isOpen: $isShown,
                    maxHeight: geometry.size.height * 0.9
                ) {
                    content
                }.foregroundColor(.white)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}


struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct ViewGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ViewHeightKey.self, value: geometry.size.height)
        }
    }
}


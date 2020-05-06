//
//  SegmentedView.swift
//  CustomSegmentedControl
//
//  Created by Stefan on 05.05.20.
//  Copyright © 2020 Stefan Gerard. All rights reserved.
//

import SwiftUI

// ScrollIssue
// https://stackoverflow.com/questions/57700396/adding-a-drag-gesture-in-swiftui-to-a-view-inside-a-scrollview-blocks-the-scroll

struct SegmentedView: View {
    @State private var selectedSegment: Int = 0

    @State private var offsetX: CGFloat = 0
    @State private var oldOffsetX: CGFloat = 0

    @State private var contentOffsetX: CGFloat = 0
    @State private var oldContentOffsetX: CGFloat = 0

    @State private var shownViews: [Int] = [0]
    @State private var currentScrollPosition: CGFloat = 0

    @State private var dragStartTime: Date?

    public var highlightingColor: Color = Color.green
    public var secondaryColor: Color = Color.secondary
    public var padding: EdgeInsets = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

    public var firstControlTitle: String
    public var firstControlBody: AnyView

    public var secondControlTitle: String
    public var secondControlBody: AnyView

    public var thirdControlTitle: String
    public var thirdControlBody: AnyView

    var body: some View {
        VStack {
            GeometryReader { geometry -> AnyView in
                DispatchQueue.main.async {
                    print(" value didn't change \(self.currentScrollPosition)")
                    if geometry.frame(in: .global).minY != self.currentScrollPosition {
                        print("value changed")
                        self.shownViews = [self.selectedSegment]
                    }
                    self.currentScrollPosition = geometry.frame(in: .global).minY
                }
                return AnyView(EmptyView())
            }
            .frame(height: 0)

            SegmentedControl()
                .padding(padding)
            content
        }
        .frame(maxWidth: 1)
    }

    private var content: some View {
        HStack(alignment: .top, spacing: padding.leading + padding.trailing) {
            VStack(spacing: 0) {
                if shownViews.contains(0) {
                    self.firstControlBody
                }
            }
            .frame(width: self.calculateWidth())

            VStack(spacing: 0) {
                if shownViews.contains(1) {
                    self.secondControlBody
                }
            }
            .frame(width: self.calculateWidth())

            VStack(spacing: 0) {
                if shownViews.contains(2) {
                    self.thirdControlBody
                }
            }
            .frame(width: self.calculateWidth())
        }
        .contentShape(Rectangle())
        .offset(x: contentOffsetX)
        .animation(.spring())
        .onTapGesture {}
        .gesture(
            DragGesture(minimumDistance: 1)
                .onChanged({ value in
                    if self.dragStartTime == nil {
                        self.dragStartTime = value.time
                    }
                    if value.translation.width < 0 {
                        if !self.shownViews.contains(self.selectedSegment + 1) {
                            self.shownViews.append(self.selectedSegment + 1)
                        }
                    } else {
                        if !self.shownViews.contains(self.selectedSegment - 1) {
                            self.shownViews.append(self.selectedSegment - 1)
                        }
                    }

                    if (value.translation.width > 0 && self.selectedSegment == 0) || (value.translation.width < 0 && self.selectedSegment == 2) {
                        self.contentOffsetX = self.oldContentOffsetX + value.translation.width / 2
                        self.offsetX = self.oldOffsetX - value.translation.width / 3 / 2
                    } else {
                        self.contentOffsetX = self.oldContentOffsetX + value.translation.width
                        self.offsetX = self.oldOffsetX - value.translation.width / 3
                    }

                })
                .onEnded({ value in
                    if abs(value.predictedEndTranslation.width) > self.calculateWidth() / 2 {
                        if value.predictedEndTranslation.width > 0 {
                            // swipe to right but go to left
//                            let animationDuration = self.calculateAnimationDuration(value: value, isSwipeAllowed: self.selectedSegment != 0)
//                            withAnimation(.interactiveSpring()) { // (duration: animationDuration)) {
                            self.selectSegment(selectedSegment: self.selectedSegment != 0 ? self.selectedSegment - 1 : self.selectedSegment)
//                            }
                        } else {
                            // swipe to left but go to right
//                            let animationDuration = self.calculateAnimationDuration(value: value, isSwipeAllowed: self.selectedSegment != 2)
//                            withAnimation(.interactiveSpring()) { // .linear(duration: animationDuration)) {
                            self.selectSegment(selectedSegment: self.selectedSegment != 2 ? self.selectedSegment + 1 : self.selectedSegment)
//                            }
                        }
                    } else {
//                        withAnimation {
                        self.selectSegment(selectedSegment: self.selectedSegment)
//                        }
                    }
                })
        )
    }

    private func calculateAnimationDuration(value: _ChangedGesture<DragGesture>.Value, isSwipeAllowed: Bool) -> Double {
        // default 0.35
        let maxAnimationDuration = 0.2

        var animationSeconds = maxAnimationDuration
        if let startTime = self.dragStartTime, isSwipeAllowed {
            let endTimeInMilliseconds = value.time.millisecondsSince1970 - startTime.millisecondsSince1970
            let widthToGo = self.calculateWidth() - abs(value.translation.width)

            let animationMilliseconds = widthToGo * CGFloat(endTimeInMilliseconds) / abs(value.translation.width)
            animationSeconds = Double(animationMilliseconds / CGFloat(1000))
            if animationSeconds > maxAnimationDuration {
                animationSeconds = maxAnimationDuration
            }
            self.dragStartTime = nil
        }
        return animationSeconds
    }

    private func SegmentedControl() -> some View {
        HStack(spacing: 0) {
            Group {
                HStack {
                    Text(self.firstControlTitle)
                        .foregroundColor(self.selectedSegment == 0 ? self.highlightingColor : self.secondaryColor)
                }
                .frame(width: calculateWidth() / 3)
                .padding(.vertical)
                .onTapGesture {
                    self.shownViews.append(0)
                    withAnimation(.spring()) {
                        self.selectSegment(selectedSegment: 0)
                    }
                }

                HStack {
                    Text(self.secondControlTitle)
                        .foregroundColor(self.selectedSegment == 1 ? self.highlightingColor : self.secondaryColor)
                }
                .frame(width: calculateWidth() / 3)
                .padding(.vertical)
                .onTapGesture {
                    self.shownViews.append(1)
                    withAnimation(.spring()) {
                        self.selectSegment(selectedSegment: 1)
                    }
                }

                HStack {
                    Text(self.thirdControlTitle)
                        .foregroundColor(self.selectedSegment == 2 ? self.highlightingColor : self.secondaryColor)
                }
                .frame(width: calculateWidth() / 3)
                .padding(.vertical)
                .onTapGesture {
                    self.shownViews.append(2)
                    withAnimation(.spring()) {
                        self.selectSegment(selectedSegment: 2)
                    }
                }
            }
        }
        .background(
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    self.highlightingColor
                        .frame(width: calculateWidth() / 3)
                        .offset(x: self.offsetX, y: 0)
                }
                .frame(height: 2)
            }
        )
        .onAppear {
            self.selectSegment(selectedSegment: self.selectedSegment)
        }
    }

    private func calculateWidth() -> CGFloat {
        let width = UIScreen.main.bounds.width - self.padding.leading - self.padding.trailing
        return width
    }

    private func selectSegment(selectedSegment: Int) {
        let screenWidth = UIScreen.main.bounds.width
        if selectedSegment == 0 {
            self.offsetX = -self.calculateWidth() / 3
            self.selectedSegment = 0
            self.contentOffsetX = screenWidth
        } else if selectedSegment == 1 {
            self.offsetX = 0
            self.selectedSegment = 1
            self.contentOffsetX = 0
        } else {
            self.offsetX = self.calculateWidth() / 3
            self.selectedSegment = 2
            self.contentOffsetX = -screenWidth
        }
        self.oldOffsetX = self.offsetX
        self.oldContentOffsetX = self.contentOffsetX
    }
}

struct SegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedView(firstControlTitle: "Control 1", firstControlBody: AnyView(Color.blue), secondControlTitle: "Control 2", secondControlBody: AnyView(Text("Control 2 body")), thirdControlTitle: "Control 3", thirdControlBody: AnyView(Image(systemName: "heart").resizable().frame(width: 50, height: 50).foregroundColor(Color.orange)))
    }
}

public extension Date {
    var millisecondsSince1970: Int64 {
        return timeIntervalSince1970.milliseconds
    }

    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

public extension TimeInterval {
    var milliseconds: Int64 {
        return Int64((self * 1000.0).rounded())
    }
}

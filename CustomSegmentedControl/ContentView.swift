//
//  ContentView.swift
//  CustomSegmentedControl
//
//  Created by Stefan on 05.05.20.
//  Copyright © 2020 Stefan Gerard. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var selectedSegment: Int = 0
    @State private var offsetX: CGFloat = 0
    @State private var contentOffsetX: CGFloat = 0
    @State private var oldContentOffsetX: CGFloat = 0
    @State private var dragStartTime: Date?

    public var highlightingColor: Color = Color.green
    public var secondaryColor: Color = Color.secondary
    public var padding: EdgeInsets = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                SegmentedControl()
                    .padding(padding)
                content
            }
        }
    }

    private var content: some View {
        HStack(spacing: padding.leading + padding.trailing) {
            VStack {
                Color.purple
            }
            .frame(width: self.calculateWidth(), height: 300)

            VStack {
                Color.pink
            }
            .frame(width: self.calculateWidth(), height: 300)

            VStack {
                Color.orange
            }
            .frame(width: self.calculateWidth(), height: 300)
        }
        .offset(x: contentOffsetX)
        .gesture(
            DragGesture(minimumDistance: 1)
                .onChanged({ value in
                    if self.dragStartTime == nil {
                        self.dragStartTime = value.time
                    }
                    if (value.translation.width > 0 && self.selectedSegment == 0) || (value.translation.width < 0 && self.selectedSegment == 2) {
                        self.contentOffsetX = self.oldContentOffsetX + value.translation.width / 2
                    } else {
                        self.contentOffsetX = self.oldContentOffsetX + value.translation.width
                    }

                })
                .onEnded({ value in
                    if abs(value.predictedEndTranslation.width) > self.calculateWidth() / 2 {
                        if value.predictedEndTranslation.width > 0 {
                            // swipe to right but go to left
                            withAnimation(.linear(duration: self.calculateAnimationDuration(value: value, isSwipeAllowed: self.selectedSegment != 0))) {
                                self.selectSegment(selectedSegment: self.selectedSegment != 0 ? self.selectedSegment - 1 : self.selectedSegment)
                            }
                        } else {
                            // swipe to left but go to right
                            withAnimation(.linear(duration: self.calculateAnimationDuration(value: value, isSwipeAllowed: self.selectedSegment != 2))) {
                                self.selectSegment(selectedSegment: self.selectedSegment != 2 ? self.selectedSegment + 1 : self.selectedSegment)
                            }
                        }
                    } else {
                        withAnimation {
                            self.selectSegment(selectedSegment: self.selectedSegment)
                        }
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
                    Text("Control 1")
                        .foregroundColor(self.selectedSegment == 0 ? self.highlightingColor : self.secondaryColor)
                }
                .frame(width: calculateWidth() / 3)
                .padding(.vertical)
                .onTapGesture {
                    withAnimation {
                        self.selectSegment(selectedSegment: 0)
                    }
                }

                HStack {
                    Text("Control 2")
                        .foregroundColor(self.selectedSegment == 1 ? self.highlightingColor : self.secondaryColor)
                }
                .frame(width: calculateWidth() / 3)
                .padding(.vertical)
                .onTapGesture {
                    withAnimation {
                        self.selectSegment(selectedSegment: 1)
                    }
                }

                HStack {
                    Text("Control 3")
                        .foregroundColor(self.selectedSegment == 2 ? self.highlightingColor : self.secondaryColor)
                }
                .frame(width: calculateWidth() / 3)
                .padding(.vertical)
                .onTapGesture {
                    withAnimation {
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
            self.oldContentOffsetX = screenWidth
        } else if selectedSegment == 1 {
            self.offsetX = 0
            self.selectedSegment = 1
            self.contentOffsetX = 0
            self.oldContentOffsetX = 0
        } else {
            self.offsetX = self.calculateWidth() / 3
            self.selectedSegment = 2
            self.contentOffsetX = -screenWidth
            self.oldContentOffsetX = -screenWidth
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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

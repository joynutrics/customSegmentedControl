//
//  ContentView.swift
//  CustomSegmentedControl
//
//  Created by Gerard, Stefan on 06.05.20.
//  Copyright © 2020 Stefan Gerard. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var selectedPage = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Image(systemName: "circle.fill")
                    .resizable().frame(width: 200, height: 200)
                    .foregroundColor(.orange)
                HStack {
                    Spacer()
                }
                .frame(height: 100)
                .background(Color.blue)
                Image(systemName: "circle.fill")
                    .resizable().frame(width: 200, height: 200)
                    .foregroundColor(.orange)
                HStack {
                    Spacer()
                }
                .frame(height: 100)
                .background(Color.blue)
                Image(systemName: "circle.fill")
                    .resizable().frame(width: 200, height: 200)
                    .foregroundColor(.orange)
                HStack {
                    Spacer()
                }
                .frame(height: 100)
                .background(Color.blue)

                SegmentedView(firstControlTitle: "Images", firstControlBody: firstControlBody(), secondControlTitle: "Devices", secondControlBody: secondControlBody(), thirdControlTitle: "Cards", thirdControlBody: thirdControlBody())

                Rectangle()
                    .frame(height: 100)
                    .foregroundColor(Color.orange)

//                PagerView(pageCount: 3, currentIndex: $selectedPage) {
//                    firstControlBody()
//                    secondControlBody()
//                    thirdControlBody()
//                }
            }
            .padding(10)
        }
    }

    private func firstControlBody() -> AnyView {
        return AnyView(
            VStack {
                Text("Image 1")
                Text("Image 2")
            }
        )
    }

    private func secondControlBody() -> AnyView {
        return AnyView(
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFill()
                .foregroundColor(Color.pink)
        )
    }

    private func thirdControlBody() -> AnyView {
        return AnyView(
            HStack {
                Text("test1")
                Text("test2")
                Text("test3")
                Text("test4")
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ScrollViewTestView.swift
//  CustomSegmentedControl
//
//  Created by Stefan on 05.05.20.
//  Copyright © 2020 Stefan Gerard. All rights reserved.
//

import SwiftUI

struct Item: Identifiable {
    var id = UUID().uuidString
    var value: String
}

struct ScrollViewTestView: View {

    var body: some View {
        GeometryReader { g in
            ScrollView {
                VStack {
                    GridView(columns: 2, items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]) { num in
                        Text("Item \(num)").frame(width: g.size.width / 2, height: g.size.width / 2)
                    }
                    .background(Color.red.opacity(0.5))
                    .padding()
                }.background(Color.green.opacity(0.2))
            }.background(Color.blue.opacity(0.2))
        }
    }
}

struct GridView<Content>: View where Content: View {
    var columns: Int
    let items: [Int]
    let content: (Int) -> Content

    init(columns: Int, items: [Int], @ViewBuilder content: @escaping (Int) -> Content) {
        self.columns = columns
        self.items = items
        self.content = content
    }

    var rowCount: Int {
        let (q, r) = items.count.quotientAndRemainder(dividingBy: columns)
        return q + (r == 0 ? 0 : 1)
    }

    func elementFor(_ r: Int, _ c: Int) -> Int? {
        let i = r * columns + c
        if i >= items.count { return nil }
        return items[i]
    }

    var body: some View {
        VStack {
            ForEach(0..<self.rowCount) { ri in
                HStack {
                    ForEach(0..<self.columns) { ci in
                        Group {
                            if self.elementFor(ri, ci) != nil {
                                self.content(self.elementFor(ri, ci)!)
                            } else {
                                Text("")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ScrollViewTestView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewTestView()
    }
}

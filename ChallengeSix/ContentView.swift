//
//  ContentView.swift
//  ChallengeSix
//
//  Created by Ivan Pryhara on 16/03/2024.
//

import SwiftUI

struct CustomStack: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
    ) -> CGSize {
        subviews.reduce(CGSize.zero) { result, subview in
            let size = subview.sizeThatFits(.unspecified)
            
            let width = proposal.width ?? 0
            let height = size.height + result.height
            
            return CGSize(
                width: width,
                height: height)
        }
    }
    
    func placeSubviews( in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
    ) {
        var origin = bounds.origin
        var xPoint = bounds.maxX - subviews[0].dimensions(in: .unspecified).width
        let step = abs(bounds.minX - xPoint) / Double(subviews.count - 1)
        
        let reveresedSubview = subviews.reversed()
        
        for subview in reveresedSubview {
            let subviewHeight = subview.dimensions(in: .unspecified).height
            
            origin.x = xPoint
            subview.place(at: origin, anchor: .zero, proposal: .unspecified)
            origin.y += subviewHeight
            
            xPoint -= step
        }
    }
}

struct ContentView: View {
    @State private var isVertical = false
    
    private let data = (1...7)
    private let spacing: CGFloat = 10
    private let cornerRadius: CGFloat = 10
    
    private var layout: AnyLayout {
        return isVertical ? AnyLayout(CustomStack()) : AnyLayout(HStackLayout(spacing: spacing))
    }
    
    var body: some View {
        GeometryReader { proxy in
            layout {
                ForEach(data, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.blue)
                        .frame(width: dimension(isVertical, proxyDimension: isVertical ? proxy.size.height : proxy.size.width), 
                               height: dimension(isVertical, proxyDimension: isVertical ? proxy.size.height : proxy.size.width))
                        .onTapGesture {
                            withAnimation {
                                self.isVertical.toggle()
                            }
                        }
                }
            }
            .frame(height: proxy.size.height)
        }
    }
    
    private func dimension(_ isVertical: Bool, proxyDimension: CGFloat) -> CGFloat {
        if isVertical {
            return proxyDimension / CGFloat(data.count)
        } else {
            return (proxyDimension - spacing * (CGFloat(data.count) - 1)) / CGFloat(data.count)
        }
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  MapboxScratchpad
//
//  Created by Jim Margolis on 10/31/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DraggableWaypointView()
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}

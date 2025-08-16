//
//  ContentView.swift
//  iOS Task
//
//  Created by Md Akhlak on 15/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            UploadView()
                .tabItem {
                    Label("Upload", systemImage: "house.fill")
                }
            
            ImagesView()
                .tabItem {
                    Label("Images", systemImage: "person.circle")
                }
        }
        .tint(.green)
    }
}

#Preview {
    ContentView()
}

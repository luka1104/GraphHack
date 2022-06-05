// Copyright © 2022 Planogy Inc. All rights reserved.

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      MainView()
        .background(Color("LightBrown"))
        .tabItem { Label("Meetn", systemImage: "menucard") }

      ContactsView()
        .background(Color("LightBrown"))
        .tabItem { Label("Contacts", systemImage: "list.bullet") }
    }
    .edgesIgnoringSafeArea(.all)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

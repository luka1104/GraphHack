// Copyright © 2022 Planogy Inc. All rights reserved.

import SwiftUI

struct CardView: View {
  let card: Card

  var body: some View {
    ZStack {
      // Background blur
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color("Brown"))
        .shadow(color: Color("Brown"), radius: 30, y: 20)
        .padding(.horizontal, 50)

      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color("Brown"))

      VStack(alignment: .leading, spacing: 24) {
        // ENS name
        Text(card.ens ?? "")
          .lineLimit(1)
          .font(.largeTitle)

        HStack {
          // Wallet Address
          Text(card.shortAddress)
          Spacer()

          // Bean count
          Text(card.beans)
            .font(.largeTitle)
          Image("BrownBean")
        }
      }
      .foregroundColor(.white)
      .padding(.horizontal, 40)
    }
    .frame(maxHeight: 160)
  }
}

struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    CardView(card: Card.example)
  }
}

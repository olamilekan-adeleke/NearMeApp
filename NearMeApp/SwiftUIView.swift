//
//  SwiftUIView.swift
//  NearMeApp
//
//  Created by Enigma Kod on 02/07/2023.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("Hello-bro").resizable().frame(width: 200, height: 200)
            Spacer().frame(height: 50)

            Text("Join us today in our fun and games!")
                .font(.system(size: 18))
                .fontWeight(.bold)

            Spacer().frame(height: 10)
            Text("As can be seen in the highlighted changes above, we use the Either type provided by the Dartz package.")
                .font(.system(size: 13))
                .fontWeight(.light)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 34)

            Spacer()
            bottomControlView
        }
    }

    var bottomControlView: some View {
        return HStack {
            CustomButton(title: "Prev")
                .scaledToFit()
            Spacer()
            CustomButton(title: "Next", color: .red)
                .scaledToFit()
        }
        .padding([.leading, .trailing], 50)
    }

    struct CustomButton: View {
        let title: String
        var color: Color?

        var body: some View {
            Button(title, action: {})
                .foregroundColor(color ?? .gray)
                .font(.system(size: 14))
                .fontWeight(.bold)
                .tint(.red)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

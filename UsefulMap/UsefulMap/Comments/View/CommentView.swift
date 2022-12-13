//
//  CommentView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 24.11.22.
//

import SwiftUI

struct CommentView: View {
    
    //MARK: - Properties

    @Binding var comment: Comment
    
    @State private var isLiked: Bool = false
    
    //MARK: - Body
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.userName)
                        .bold()
                        .padding(.vertical, 4)
                    Spacer()
                    Button {
                        isLiked.toggle()
                    } label: {
                        Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    Text(String(comment.likesCount))
                        .font(.footnote.bold())
                }//-HStack
                Text(comment.text)
                    .font(.subheadline)
                Text(comment.date)
                    .font(.footnote.bold())
                    .padding(.vertical, 4)
            }//-VStack
            Spacer()
        }//-HStack
        .padding()
        .background(.gray)
        .cornerRadius(20)
    }
}

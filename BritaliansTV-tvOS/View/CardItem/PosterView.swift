//
//  PosterItem.swift
//  MovieTV
//
//  Created by miqo on 06.12.23.
//

import SwiftUI
import TVUIKit
import Kingfisher

struct PosterView: UIViewRepresentable {
    let imageURL: String
    let width: CGFloat
    let height: CGFloat

    func makeUIView(context: Context) -> UIPoster {
        UIPoster(imageURL: imageURL, width: width, height: height)
    }

    func updateUIView(_ uiView: UIPoster, context: Context) {
        if uiView.superview != nil {
            //uiView.leftAnchor.constraint(equalTo: uiView.superview!.leftAnchor, constant: 0).isActive = true
            //uiView.rightAnchor.constraint(equalTo: uiView.superview!.rightAnchor, constant: 0).isActive = true
            //uiView.topAnchor.constraint(equalTo: uiView.superview!.topAnchor, constant: 0).isActive = true
            //uiView.bottomAnchor.constraint(equalTo: uiView.superview!.bottomAnchor, constant: 0).isActive = true
            uiView.centerXAnchor.constraint(equalTo: uiView.superview!.centerXAnchor, constant: 0).isActive = true
            uiView.centerYAnchor.constraint(equalTo: uiView.superview!.centerYAnchor, constant: 0).isActive = true
        }
        
        uiView.widthAnchor.constraint(equalToConstant: width).isActive = true
        uiView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

class UIPoster: TVPosterView {
    init(
        imageURL: String,
        width: CGFloat,
        height: CGFloat
    ) {
        super.init(frame: .zero)
        let options: KingfisherOptionsInfo = [
            .transition(.fade(0.3)),
            .cacheOriginalImage
        ]
        
        imageView.kf.setImage(
            with: URL(string: imageURL),
            options: options,
            completionHandler: { result in
                switch result {
                case .success(let value):
                    let resizedImage = value.image.kf.resize(to: CGSize(width: width, height: height))
                    self.imageView.image = resizedImage
                case .failure(_):
                    let resizedImage = UIImage(named: "cardPlaceholder")!
                        .kf.resize(to: CGSize(width: width, height: height))
                        //.resized(to: CGSize(width: width, height: height))
                    self.imageView.image = resizedImage
                }
            }
        )
    
        title = ""
        translatesAutoresizingMaskIntoConstraints = false

        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//struct PosterView_Previews: PreviewProvider {
//    static var previews: some View {
//        PosterView(imageURL: "https://www.themoviedb.org/t/p/w440_and_h660_face/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg", width: 300, height: 600)
//            .previewLayout(.sizeThatFits)
//    }
//}

//
//  ExtUIImageView.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 25/02/24.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func setImage(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: "https://raw.githubusercontent.com/andreascandle/p2p_json_test/main" + link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

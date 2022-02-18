//
//  LanguageColorModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

// Source: https://github.com/ozh/github-colors

struct LanguageColor: Codable {
    let hex: String?
    enum CodingKeys: String, CodingKey {
        case hex = "color"
    }
}

class LoadLanguageColor {
    static let shared = LoadLanguageColor()
    private var languages: [String: LanguageColor]?
    
    init() {
        guard let path = Bundle.main.path(forResource: "colors", ofType: "json") else { fatalError("json file not found") }
        guard let data = try? String(contentsOfFile: path).data(using: .utf8) else { fatalError("cannnot open json file") }
        guard let rawLanguages = try? JSONDecoder().decode([String: LanguageColor].self, from: data) else { return }
        self.languages = rawLanguages
    }
    
    func getColorOf(lang: String) -> LanguageColor? {
        guard
            let languages = self.languages,
            let color = languages[lang]
        else { return nil }
        return color
    }
}

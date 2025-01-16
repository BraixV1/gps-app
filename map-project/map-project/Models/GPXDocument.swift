//
//  GPXDocument.swift
//  map-project
//
//  Created by Brajan Kukk on 31.12.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct GPXDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.xml] }
    
    var fileURL: URL?
    
    init(fileURL: URL? = nil) {
        self.fileURL = fileURL
    }
    
    init(configuration: ReadConfiguration) throws {
        self.fileURL = nil
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let fileURL = fileURL else {
            throw CocoaError(.fileWriteUnknown)
        }
        let data = try Data(contentsOf: fileURL)
        return FileWrapper(regularFileWithContents: data)
    }
}

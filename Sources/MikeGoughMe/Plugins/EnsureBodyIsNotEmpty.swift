import Foundation
import Publish

extension Plugin {
    static var ensureBodyIsNotEmpty: Self {
        Plugin(name: "Ensure that body of articles are not empty") { context in
            let allItems = context.sections.flatMap { $0.items }

            for item in allItems {
                guard !item.body.isEmpty else {
                    throw PublishingError(
                        path: item.path,
                        infoMessage: "Article has no body"
                    )
                }
            }
        }
    }
}
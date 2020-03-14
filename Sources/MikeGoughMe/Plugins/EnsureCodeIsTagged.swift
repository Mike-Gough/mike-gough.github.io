import Foundation
import Publish

extension Plugin {
    static var ensureCodeIsTagged: Self {
        Plugin(name: "Ensure that code blocks are tagged with a language") { context in
            let allItems = context.sections.flatMap { $0.items }

            for item in allItems {
                //guard item.body.html.contains("```\n") else {
                    
                   guard !item.body.html.contains("<pre data-language=\"undefined\">") else {
                    throw PublishingError(
                        path: item.path,
                        infoMessage: "Code block has no language"
                    )
                }
            }
        }
    }
}
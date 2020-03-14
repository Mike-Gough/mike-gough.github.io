import Foundation
import Publish
import Plot
import CNAMEPublishPlugin
import VerifyResourcesExistPublishPlugin
import MinifyCSSPublishPlugin
import ColorfulTagsPublishPlugin
import HighlightJSPublishPlugin

// This type acts as the configuration for your website.
struct MikeGoughMe: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case articles
        case basics
        case tips
        case tags
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
        var description: String
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://mike.gough.me/")!
    var name = "Integration Architecture"
    var description = "Articles by Mike Gough."
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try MikeGoughMe()
    .publish(using: [
        .installPlugin(.highlightJS()),
        .addMarkdownFiles(),
        .installPlugin(.readingTime()),
        .copyResources(),
        .installPlugin(.ensureAllItemsAreTagged),
        .installPlugin(.ensureBodyIsNotEmpty),
        .installPlugin(.ensureCodeIsTagged),
        .installPlugin(.verifyResourcesExist()),
        .installPlugin(.generateCNAME(with: "mike.gough.me")),
        .installPlugin(.colorfulTags(defaultClass: "tag", variantPrefix: "variant", numberOfVariants: 18)),
        .generateHTML(withTheme: .personal),
        .installPlugin(.minifyCSS()),
        .generateRSSFeed(including: [.articles, .basics, .tips]),
        .generateSiteMap(),
        .deploy(using: .gitHub("Mike-Gough/mike-gough.github.io", useSSH: false))
    ])
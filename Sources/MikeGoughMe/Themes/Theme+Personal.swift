import Publish
import Plot
import ColorfulTagsPublishPlugin
import ReadingTimePublishPlugin

public extension Theme {
    static var personal: Self {
        Theme(
            htmlFactory: PersonalHTMLFactory(),
            resourcePaths: [
                "/Resources/PersonalTheme/fontawesome/all.min.css",
                "/Resources/PersonalTheme/styles.css"
            ]
        )
    }
}

func itemToReadingTime<T: Website>(_ item: Item<T>) -> String {
    let minutes = Int((item.readingTime.minutes).rounded(.up))
    if (minutes > 1) {
        return "🕑 \(minutes) minutes read."
    } else {
        return "🕑 \(minutes) minute read."
    }
}

private struct PersonalHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {

        let articles = context.items(taggedWith: "Articles", sortedBy: \.date, order: .descending)
        let basics = context.items(taggedWith: "Basics", sortedBy: \.date, order: .descending)
        let tips = context.items(taggedWith: "Tips", sortedBy: \.date, order: .descending)
                           
        return HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .head(
                .link(.rel(.stylesheet),.href("https://fonts.googleapis.com/css?family=Karla:400,400i,700,700i")),
                .link(.rel(.stylesheet),.href("/PersonalTheme/fontawesome/all.min.css"))
            ),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .div(
                        .class("animated fadeIn"),
                        .h1(
                            .class("section-header"),
                            .a(
                                .href("/articles/"),
                                .span(
                                    .class("far fa-newspaper")
                                ),
                                .text("Articles")
                            )
                        ),
                        .a(
                            .class("section-header browse-all-link"),
                            .href("/articles/"),
                            .text("Browse all \(articles.count) articles")
                        )
                    ),
                    .div(
                        .class("animated fadeIn"),
                        .itemList(
                            for: Array(articles.prefix(2)),
                            on: context.site
                        )
                    ),

                    .div(
                        .class("animated fadeIn"),
                        .h1(
                            .class("section-header"),
                            .a(
                                .href("/basics/"),
                                .span(
                                    .class("far fa-lightbulb")
                                ),
                                .text("Basics")
                            )
                        ),
                        .a(
                            .class("section-header browse-all-link"),
                            .href("/basics/"),
                            .text("Browse all \(basics.count) basics")
                        )
                    ),
                    .div(
                        .class("animated fadeIn"),
                        .itemList(
                            for: Array(basics.prefix(2)),
                            on: context.site
                        )
                    ),

                    .div(
                        .class("animated fadeIn"),
                        .h1(
                            .class("section-header"),
                            .a(
                                .href("/tips/"),
                                .span(
                                    .class("far fa-star")
                                ),
                                .text("Tips")
                            )
                        ),
                        .a(
                            .class("section-header browse-all-link"),
                            .href("/tips/"),
                            .text("Browse all \(tips.count) Tips")
                        )
                    ),
                    .div(
                        .class("animated fadeIn compact"),
                        .itemList(
                            for: Array(tips.prefix(3)),
                            on: context.site
                        )
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .head(
                .link(.rel(.stylesheet),.href("https://fonts.googleapis.com/css?family=Karla:400,400i,700,700i")),
                .link(.rel(.stylesheet),.href("/PersonalTheme/fontawesome/all.min.css"))
            ),
            .body(
                .class(section.id.rawValue),
                .header(for: context, selectedSection: section.id),
                .wrapper(
                    .class("wrapper animated fadeIn expanded"),
                    .contentBody(
                        section.body
                    ),
                    .itemList(
                        for: section.items.sorted(
                            by: {
                                $0.date > $1.date
                            }
                        ),
                        on: context.site)
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .head(
                .link(.rel(.stylesheet),.href("https://fonts.googleapis.com/css?family=Karla:400,400i,700,700i")),
                .link(.rel(.stylesheet),.href("/PersonalTheme/fontawesome/all.min.css"))
            ),
            .body(
                .class("item-page"),
                .header(for: context, selectedSection: item.sectionID),
                .wrapper(
                    .article(
                        .class("animated fadeIn"),
                        .span(
                            .class("date"),
                            .text("Published on \(item.date.australianFormatted).")
                        ),
                        .span(
                            .class("read-time"),
                            .text(itemToReadingTime(item))
                        ),
                        .h1(
                            .text(item.title)
                        ),
                        .tagList(for: item, on: context.site),
                        .p(.text(item.description)),
                        .div(
                            .class("content"),
                            .contentBody(item.body),
                            .p(
                                .class("footer"),
                                .text("Thanks for reading! 🚀")
                            )
                        ),
                        .ul(
                            .class("share grid compact"),
                            .li(
                                .a(
                                    .class("twitter"),
                                    .href("https://twitter.com/intent/tweet?via=MikeRyanGough&text=\(item.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&url=\(context.site.url)\(item.path)"),
                                    .text("Share on Twitter")
                                )
                            ),
                            .li(
                                .a(
                                    .class("facebook"),
                                    .href("https://www.facebook.com/sharer/sharer.php?u=\(context.site.url)\(item.path)"),
                                    .text("Share on Facebook")
                                )
                            ),
                            .li(
                                .a(
                                    .class("linkedin"),
                                    .href("https://www.linkedin.com/shareArticle?mini=true&&title\(item.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)=&summary=&source=&url=\(context.site.url)\(item.path)"),
                                    .text("Share on LinkedIn")
                                )
                            )
                        )
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .head(
                .link(.rel(.stylesheet),.href("https://fonts.googleapis.com/css?family=Karla:400,400i,700,700i")),
                .link(.rel(.stylesheet),.href("/PersonalTheme/fontawesome/all.min.css"))
            ),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .contentBody(page.body)
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .head(
                .link(.rel(.stylesheet),.href("https://fonts.googleapis.com/css?family=Karla:400,400i,700,700i")),
                .link(.rel(.stylesheet),.href("/PersonalTheme/fontawesome/all.min.css"))
            ),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .class("wrapper animated fadeIn"),
                    .h1(
                        .text("Browse all tags")
                    ),
                    .ul(
                        .class("all-tags"),
                        .forEach(page.tags.sorted()) { tag in
                            .li(
                                .class(tag.colorfiedClass),
                                .a(
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            )
                        }
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .head(.link(.rel(.stylesheet),.href("https://fonts.googleapis.com/css?family=Karla:400,400i,700,700i"))),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .class("wrapper animated fadeIn expanded"),
                    .h1(
                        .text("Tagged with "),
                        .span(
                            .class(page.tag.colorfiedClass), 
                            .text(page.tag.string)
                        )
                    ),
                    .a(
                        .class("browse-all"),
                        .text("Browse all tags"),
                        .href(context.site.tagListPath)
                    ),
                    .itemList(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        let sectionIDs = T.SectionID.allCases

        return .header(
            .wrapper(
                .a(
                    .class("site-name"), 
                    .href("/"), 
                    .text(context.site.name)
                ),
                .p(
                    .text(context.site.description)
                ),
                .if(sectionIDs.count > 1,
                    .nav(
                        .ul(.forEach(sectionIDs) { section in
                            var icon = ""
                            switch section.rawValue {
                                case "articles":
                                    icon = "far fa-newspaper"
                                case "basics":
                                    icon = "far fa-lightbulb"
                                case "tips":
                                    icon = "far fa-star"
                                case "tags":
                                    icon = "fas fa-hashtag"
                                case "about":
                                    icon = "far fa-user"
                                default:
                                    icon = ""
                            }
                            return .li(.a(
                                .span(
                                    .class(
                                        icon
                                    )
                                ),
                                .class(section == selectedSection ? "selected" : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].title)
                            ))
                        })
                    )
                )
            )
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list grid"),
            .forEach(items) { item in
                .li(
                    .article(
                        .span(
                            .class("date"),
                            .text("Published on \(item.date.australianFormatted).")
                        ),
                        .span(
                            .class("read-time"),
                            .text(itemToReadingTime(item))
                        ),
                        .h1(
                            .a(
                                .href(item.path),
                                .text(item.title)
                            )
                        ),
                        .tagList(for: item, on: site),
                        .a(
                            .href(item.path),
                            .p(
                                .text(item.description)
                            )
                        )
                    )
                )
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(
                .class(tag.colorfiedClass),
                .a(
                .href(site.path(for: tag)),
                .text(tag.string)
            ))
        })
    }

    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .class("animated fadeIn"),
            .p(
                .text("Mike Gough © 2020.")
            ),
            .p(
                .text("Powered by "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                ),
                .text(" and hosted on "),
                .a(
                    .text("GitHub Pages"),
                    .href("https://github.com/Mike-Gough/Mike-Gough.github.io")
                ),
                .text(". 100% JavaScript-free.")
            ),
            .p(
                .text("Notice a broken link or other issue? "),
                .a(
                    .text("Open an issue!"),
                    .href("https://github.com/Mike-Gough/Mike-Gough.github.io/issues")
                )
            ),
            .p(
                .a(
                    .text("RSS feed"),
                    .href("/feed.rss")
                )
            )
        )
    }
}

import SwiftUI
import SafariServices
import WebKit

public struct WebView: View {
    private let props: Props
    public init(props: Props) {
        self.props = props
    }

    public var body: some View {
        if let url = URL(string: props.url) {
            WKWebViewRepresentable(url: url)
        } else {
            ProgressView { EmptyView() }
        }
    }
}

struct WKWebViewRepresentable: UIViewRepresentable {

    var url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

import SwiftUI
import SafariServices
import WebKit

public struct WebView: View {
    private let props: Props
    public init(props: Props) {
        self.props = props
    }

    public var body: some View {
        WKWebViewRepresentable(request: props.request)
    }
}

class FullScreenWKWebView: WKWebView {
    override var safeAreaInsets: UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

struct WKWebViewRepresentable: UIViewRepresentable {
    var request: URLRequest

    func makeUIView(context: Context) -> FullScreenWKWebView {
        let wv = FullScreenWKWebView()
        wv.backgroundColor = .black
        wv.underPageBackgroundColor = .black
        return wv
    }

    func updateUIView(_ webView: FullScreenWKWebView, context: Context) {
        webView.load(request)
    }
}

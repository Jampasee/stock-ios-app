import SwiftUI
import WebKit

final class WebViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var estimatedProgress: Double = 0.0
    
    weak var webView: WKWebView?
    
    func reload() {
        errorMessage = nil
        webView?.reload()
    }
    
    func goBack() {
        if webView?.canGoBack == true {
            webView?.goBack()
        }
    }
    
    func goForward() {
        if webView?.canGoForward == true {
            webView?.goForward()
        }
    }
    
    func loadInitialURL() {
        errorMessage = nil
        if let url = URL(string: "http://stock99.xo.je/projects.html?i=1") {
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            webView?.load(request)
        }
    }
}

struct WebViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    let startURL = URL(string: "http://stock99.xo.je/projects.html?i=1")!

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        
        // Persistent cookies and localStorage
        configuration.websiteDataStore = WKWebsiteDataStore.default()

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 1.0)
        webView.scrollView.backgroundColor = UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 1.0)
        webView.scrollView.bounces = true

        // Pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl(_:)), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl

        viewModel.webView = webView
        context.coordinator.setupProgressObserver(for: webView)
        
        var request = URLRequest(url: startURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.setValue("StockApp-iOS/1.0", forHTTPHeaderField: "X-Requested-With")
        webView.load(request)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebViewContainer
        private var progressObservation: NSKeyValueObservation?

        init(_ parent: WebViewContainer) {
            self.parent = parent
        }

        func setupProgressObserver(for webView: WKWebView) {
            progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] wv, change in
                DispatchQueue.main.async {
                    self?.parent.viewModel.estimatedProgress = wv.estimatedProgress
                }
            }
        }

        deinit {
            progressObservation?.invalidate()
        }

        @objc func handleRefreshControl(_ sender: UIRefreshControl) {
            parent.viewModel.webView?.reload()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                sender.endRefreshing()
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.viewModel.isLoading = true
                self.parent.viewModel.errorMessage = nil
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.viewModel.isLoading = false
                self.parent.viewModel.canGoBack = webView.canGoBack
                self.parent.viewModel.canGoForward = webView.canGoForward
            }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            let nsError = error as NSError
            if nsError.code == NSURLErrorCancelled { return }
            DispatchQueue.main.async {
                self.parent.viewModel.isLoading = false
                self.parent.viewModel.errorMessage = error.localizedDescription
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            let nsError = error as NSError
            if nsError.code == NSURLErrorCancelled { return }
            DispatchQueue.main.async {
                self.parent.viewModel.isLoading = false
                self.parent.viewModel.errorMessage = error.localizedDescription
            }
        }

        // Support for window.open / target="_blank"
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
        
        // Handle JS Alert
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            guard let rootVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController else {
                completionHandler()
                return
            }
            let alert = UIAlertController(title: "การแจ้งเตือน", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: { _ in completionHandler() }))
            rootVC.present(alert, animated: true)
        }
        
        // Handle JS Confirm
        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            guard let rootVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController else {
                completionHandler(false)
                return
            }
            let alert = UIAlertController(title: "ยืนยัน", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: { _ in completionHandler(true) }))
            alert.addAction(UIAlertAction(title: "ยกเลิก", style: .cancel, handler: { _ in completionHandler(false) }))
            rootVC.present(alert, animated: true)
        }
    }
}

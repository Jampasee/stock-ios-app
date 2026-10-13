import SwiftUI

struct ContentView: View {
    @StateObject private var webViewModel = WebViewModel()
    @State private var showBottomBar: Bool = true
    
    // Background color matching website: oklch(0.145 0 0) -> roughly #1c1c1e / #121212
    private let themeBg = Color(red: 0.12, green: 0.12, blue: 0.12)
    
    var body: some View {
        ZStack {
            themeBg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Progress Bar
                if webViewModel.isLoading && webViewModel.estimatedProgress < 1.0 {
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            Color.black.opacity(0.3)
                            LinearGradient(
                                colors: [Color.cyan, Color.blue, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(width: proxy.size.width * CGFloat(webViewModel.estimatedProgress))
                            .animation(.linear(duration: 0.2), value: webViewModel.estimatedProgress)
                        }
                    }
                    .frame(height: 2.5)
                }
                
                // Main WKWebView
                WebViewContainer(viewModel: webViewModel)
                    .ignoresSafeArea(.keyboard)
                
                // Bottom Quick Action Bar
                if showBottomBar {
                    HStack {
                        Button(action: { webViewModel.goBack() }) {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(webViewModel.canGoBack ? .white : .gray.opacity(0.4))
                                .frame(width: 44, height: 40)
                        }
                        .disabled(!webViewModel.canGoBack)
                        
                        Spacer()
                        
                        Button(action: { webViewModel.goForward() }) {
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(webViewModel.canGoForward ? .white : .gray.opacity(0.4))
                                .frame(width: 44, height: 40)
                        }
                        .disabled(!webViewModel.canGoForward)
                        
                        Spacer()
                        
                        Button(action: { webViewModel.loadInitialURL() }) {
                            Image(systemName: "house")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 40)
                        }
                        
                        Spacer()
                        
                        Button(action: { webViewModel.reload() }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 40)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 6)
                    .background(Color.black.opacity(0.85))
                    .overlay(
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(Color.white.opacity(0.15)),
                        alignment: .top
                    )
                }
            }
            
            // Error State Overlay
            if let error = webViewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "wifi.exclamationmark")
                        .font(.system(size: 52))
                        .foregroundColor(.cyan)
                    
                    Text("ไม่สามารถโหลดหน้าเว็บได้")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    
                    Text("โปรดตรวจสอบการเชื่อมต่ออินเทอร์เน็ต แล้วลองใหม่อีกครั้ง\n(\(error))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: { webViewModel.reload() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.clockwise")
                            Text("ลองใหม่อีกครั้ง")
                        }
                        .font(.callout.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(colors: [Color.cyan, Color.blue], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(12)
                    }
                    .padding(.top, 8)
                }
                .padding(28)
                .background(Color(red: 0.18, green: 0.18, blue: 0.20))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.6), radius: 20, x: 0, y: 10)
                .padding(24)
            }
        }
    }
}

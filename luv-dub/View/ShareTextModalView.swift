import SwiftUI

struct ShareTextModalView: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareTextModalView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareTextModalView>) {}
}


struct ShareText: Identifiable {
    let id = UUID()
    let text: String
}

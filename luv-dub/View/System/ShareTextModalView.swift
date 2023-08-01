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
    let invitationCode: String
    
    
    func kakaoTalkMessage() -> String{
        return """
               상대방과 연동하세요
               상대방의 초대코드 : \(self.invitationCode)
               """
    }
}

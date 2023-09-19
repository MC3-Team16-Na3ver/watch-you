//
//  TutorialView.swift
//  luv-dub
//
//  Created by 조한동 on 2023/09/19.
//

import SwiftUI

var tutorialData : [[String]] = [
    ["게이지가 다 찰 때까지 버튼을 꾹 눌러주세요","tutorialImage1"],
    ["잘했어요! 연인에게 시그널이 전송될거에요", "tutorialImage2"],
    ["대신, 시그널을 보낼 때 마다 하트가 하나씩 소모돼요", "tutorialImage3"],
    ["하트는 30분에 하나씩 충전되며,모두 사용한 뒤엔 보낼 수 없어요", "tutorialImage4"],
    ["스와이프로 화면을 넘기면 연동상대와 디데이를 볼 수 있어요", "tutorialImage5"]]


struct TutorialView: View {
    @State var tutorialIndex: Int = 0
    
    var body: some View {
        ZStack {
            Image("tutorialBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            VStack(spacing: 30) {
                TutorialBox()
                Text("\(tutorialData[tutorialIndex][0])")
                    .fontWeight(.heavy)
                    .frame(width: .infinity, height: 50, alignment: .center)
                Image("\(tutorialData[tutorialIndex][1])")
                TutorialButtons(tutorialIndex: $tutorialIndex)
            }
        }
    }
}



struct TutorialBox: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .frame(width: 110, height: 33)
                .foregroundColor(.pink.opacity(0.2))
            Text("TUTORIAL")
                .foregroundColor(.red.opacity(0.9))
                .fontWeight(.bold)
        }
    }
}

struct TutorialButtons: View {
    @Binding var tutorialIndex: Int
    
    var body: some View {
        HStack(spacing: -5) {
            ZStack() {
                Image("leftButton")
                Image(systemName: "lessthan")
                    .font(.system(size: 30))
                    .foregroundColor(tutorialIndex == 0 ? .gray : .pink)
                    .onTapGesture {
                        if tutorialIndex > 0 {
                            tutorialIndex -= 1
                        }
                    }
            }
            ZStack {
                Image("centerPageLabel")
                Text("\(tutorialIndex + 1)/5")
                    .font(.system(size: 30))
                    .foregroundColor(.pink)
                
            }
            ZStack {
                Image("rightButton")
                Image(systemName: "greaterthan")
                    .font(.system(size: 30))
                    .foregroundColor(tutorialIndex == 4 ? .gray : .pink)
                    .onTapGesture {
                        if tutorialIndex < 4 {
                            tutorialIndex += 1
                        }
                    }
            }
        }
    }
}


struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}

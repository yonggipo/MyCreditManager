//
//  main.swift
//  MyCreditManager
//
//  Created by 조기열 on 2023/04/26.
//

import Foundation


struct MyCreditManager {
    
    enum Menu {
        case addStudent
        case deleteStudent
        case patchGrade
        case deleteGrade
        case checkGrade
        case endProgram
        
        func descript() {
            switch self {
            case .addStudent:
                print("추가할 학생의 이름을 입력해주세요")
            case .deleteStudent:
                print("삭제할 학생의 이름을 입력해주세요")
            case .patchGrade:
                print("""
            성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.
            입력예) Mickey Swift A+
            만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.
            """)
            case .deleteGrade:
                print("""
            성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.
            입력예) Mickey Swift
            """)
            case .checkGrade:
                print("..?")
            default:
                return
            }
        }
        
        func action(_ info: StudentInfo, isContain: Bool) {
            switch self {
            case .addStudent:
                if isContain {
                    print("\(info.name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
                } else {
                    MyCreditManager.shared.students.insert(info.name)
                    print("\(info.name) 학생을 추가했습니다.")
                }
            case .deleteStudent:
                if isContain {
                    print("\(info.name) 학생을 삭제하였습니다.")
                    MyCreditManager.shared.students.remove(info.name)
                } else {
                    print("\(info.name) 학생을 찾지 못했습니다.")
                }
            case .patchGrade:
                print("\(info.name) 학생의 \(info.subject) 과목의 성적이 \(info.grade)로 추가(변경)되였습니다.")
                let filteredInfo = MyCreditManager.shared.studentInfos.filter { $0.subject == info.subject }
                MyCreditManager.shared.studentInfos = MyCreditManager.shared.studentInfos.subtracting(filteredInfo)
                MyCreditManager.shared.studentInfos.insert(info)
            case .deleteGrade:
                if isContain {
                    print("\(info.name) 학생을 찾지 못했습니다.")
                } else {
                    print("\(info.name) 학생의 \(info.grade) 과목의 성적이 삭제되었습니다.")
                    let filteredInfo = MyCreditManager.shared.studentInfos.filter { $0.subject == info.subject }
                    MyCreditManager.shared.studentInfos = MyCreditManager.shared.studentInfos.subtracting(filteredInfo)
                }
            case .checkGrade:
                if isContain {
                    let filteredInfo = MyCreditManager.shared.studentInfos.filter { $0.subject == info.subject }
                    for i in filteredInfo {
                        print(i.subject + ":" + i.grade)
                    }
                } else {
                    print("\(info.name) 학생을 찾지 못했습니다.")
                }
            default:
                return
            }
        }
    }
    
    struct StudentInfo: Hashable {
        let name: String
        var subject: String = ""
        var grade: String = ""
    }
    
    static var shared = MyCreditManager()
    
    var students = Set<String>()
    var studentInfos = Set<StudentInfo>()
    let startMessage = """
        원하는 기능을 입력해주세요
        1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료
        """
    
    private init() {}
    
    func runManager() {
        print(startMessage)
        
        while true {
            let input = readLine()
            if let input = input {
                switch input {
                case "1": didMenuChosen(.addStudent)
                case "2": didMenuChosen(.deleteStudent)
                case "3": didMenuChosen(.patchGrade)
                case "4": didMenuChosen(.deleteGrade)
                case "5": didMenuChosen(.checkGrade)
                case "X":
                    print("프로그램을 종료합니다...")
                    return
                default:
                    print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
                    print(startMessage)
                }
            }
        }
    }

    func didMenuChosen(_ menu: Menu) {
        
        let errorMessage = "입력이 잘못되었습니다. 다시 확인해주세요."
        menu.descript()
        
        let input = readLine()
        
        switch menu {
            
        case .addStudent, .deleteStudent, .checkGrade:
            guard let name = input, name != "" else {
                print(errorMessage)
                print(startMessage)
                return
            }
            
            let info = StudentInfo(name: name)
            
            guard MyCreditManager.shared.students.contains(info.name) else {
                menu.action(info, isContain: false)
                print(startMessage)
                return
            }
            
            menu.action(info, isContain: true)
            print(startMessage)
            return
            
        case .patchGrade:
            guard let input = input, input != "" else {
                print(errorMessage)
                print(startMessage)
                return
            }
            
            let texts = input.split(separator: " ", omittingEmptySubsequences: false)
            if texts.count != 3 {
                print(errorMessage)
                print(startMessage)
                return
            } else if texts[0] == "" || texts[1] == "" || texts[2] == "" {
                print(errorMessage)
                print(startMessage)
                return
            }
            
            let info = StudentInfo(name: String(texts[0]), subject: String(texts[1]), grade: String(texts[2]))
            
            guard MyCreditManager.shared.students.contains(info.name) else {
                menu.action(info, isContain: false)
                print(startMessage)
                return
            }
            
            menu.action(info, isContain: true)
            print(startMessage)
            return
            
        case .deleteGrade:
            guard let input = input, input != "" else {
                print(errorMessage)
                print(startMessage)
                return
            }
            
            let texts = input.split(separator: " ", omittingEmptySubsequences: false)
            if texts.count != 2 {
                print(errorMessage)
                print(startMessage)
                return
            } else if texts[0] == "" || texts[1] == "" {
                print(errorMessage)
                print(startMessage)
                return
            }
            
            let info = StudentInfo(name: String(texts[0]), subject: String(texts[1]))
            
            guard MyCreditManager.shared.students.contains(info.name) else {
                menu.action(info, isContain: false)
                print(startMessage)
                return
            }
            
            menu.action(info, isContain: true)
            print(startMessage)
            return
            
        default:
            return
        }
    }
}

MyCreditManager.shared.runManager()


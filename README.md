# Hahow iOS-recruit-project
## System Requirements
本專案使用 Xcode 15.0.0 和 Swift 5 開發，deployment target 為 iOS 15.0。

## App 使用說明
在 iPhone 上  
- 課程區塊至多顯示 3 堂課程，其中第 1 堂課程的設計樣式為大圖，其餘為小圖。   
- 文章區塊至多顯示 3 篇文章。   
- 沒有課程就不顯示課程區塊。   
- 沒有文章就不顯示文章區塊。
    
在 iPad 上  
- 課程區塊至多顯示 5 堂課程，其中第 1 堂課程的設計樣式為大圖，其餘為小圖，第二項開始 1 個 row 會顯示 2 堂課程。  
- 文章區塊至多顯示 6 篇文章，1 個 row 會顯示 2 篇文章。  
- 沒有課程就不顯示課程區塊。  
- 沒有文章就不顯示文章區塊。  

## System Design
資料取得用 Singleton pattern 處理，UI 的部分採用 MVVM pattern 處理業務邏輯的溝通。

### DataLoaderProvider
```
protocol DataLoaderProvider {
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> AnyPublisher<T, DataError>
}
```
DataLoaderProvider 用來加載 json 資料，具體實作交由實作端處理

```
/// 具體實作
class DataLoader {
    static let shared = DataLoader()
    
    private init() {}
}

extension DataLoader: DataLoaderProvider {
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> AnyPublisher<T, DataError> {
            Future { promise in
                guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
                    print("File not found: \(filename)")
                    promise(.failure(.fileNotFound(filename)))
                    return
                }
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(T.self, from: data)
                    promise(.success(jsonData))
                } catch {
                    promise(.failure(DataError.decodeFailed(error)))
                }
            }
            .eraseToAnyPublisher()
        }
}
```
### ConfigUI
```
protocol ConfigUI {
    associatedtype ViewData
    func configure(viewData: ViewData)
}

extension ConfigUI {
    func configure(viewData: ViewData) {}
}
```
Protocol ConfigUI 用來為 view 設定資料，具體實作交由實作端處理
```
/// 具體實作
HeaderCollectionReusableView: ConfigUI {
    typealias ViewData = HeaderCollectionViewData

    func configure(viewData: HeaderCollectionViewData) {
    }
}
```
### ImageAsset
ImageAsset 用來存放所有的圖片字串
```
/// 具體實作
enum ImageAsset: String {
    case iconEye = "eye"
    case iconStarFill = "star.fill"
    case iconTimer = "timer"
    case iconPerson = "person"
}
```
## 技術選型
- ViewModel 和 functional reactive programming 的部分使用 Combine。  
- 列表使用 DiffableDataSource 與 CompositionalLayout 實作。  
- Third party libraries 採用 Swift Package Manager 管理。  
- 網路圖片請求使用 Kinfisher。  
- 刻 UI 使用 Snapkit。  

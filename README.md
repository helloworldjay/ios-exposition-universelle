# 🇰🇷 만국박람회 프로젝트 저장소

<br/>

## 📝 This Repository Rules

- commit의 단위는 issue Number 입니다.
- 총 3가지의 STEP으로 진행합니다.
  - JSON 파일을 받아서 담을 타입을 구현
  - View(Table View 등) 구현
  - 오토레이아웃 적용

<br/>

## 🎯 모델 구현

<br/>

- JSON 포맷의 데이터와 매칭할 모델을 구현합니다.

<br/>

## 📈 JSON 파일을 받아서 담을 타입을 구현

- 가져올 JSON 파일의 구조는 아래와 같습니다.

  ```json
  {
    "name":"직지심체요절",
  
    "image_name":"jikji",
  
    "short_desc":"백운화상 경한(景閑)이 1372년에 초록한 불교 서적",
  
    "desc":"《'백운화상초록불조직지심체요절》(白雲和尙抄錄佛祖直指心體要節)은 백운화상 경한(景閑)이 1372년에 초록한 불교 서적이다. 간단히 직지심체요절(直指心體要節) 또는 직지(直指, JUKJI)라고 부르기도 한다...
  }
  ```

   이 예시의 경우 key는 name, image_name, short_desc, desc로 총 4가지 입니다. 우선 이러한 정보를 넣을 수 있는 타입을 하나 만들었습니다. 이름은 출품작에 맞게 exhibitionProduct로 하겠습니다.

  ```swift
  struct ExhibitionProduct: Decodable {
      let name: String
      let imageName: String
      let shortDescription: String
      let description: String
  }
  ```

  ### 🧐 고민 Point!

  - 구현 타입 class vs struct vs enum:

    우선 세가지 타입 중 class로 구현할 이유는 없었습니다. JSON 파일의 내용을 담을 타입이라 상속의 상황이 발생할 계획이 없고 저장 타입의 역할이라면 값타입이 더 유리할 것이라고 판단했습니다. 중요한 것은 struct와 enum입니다.

    enum은 우선 구별되는 값을 case로 나눠줍니다. 관련 고민을 Stack Overflow의 답변에서 찾아볼 수 있었습니다.

    > One difference between the two is that **structs** can be instantiated where as **enums** cannot. So in most scenarios where you just need to use constants, it's probably best to use **enums** to avoid confusion...
    >
    > ref: [Stack Overflow](https://stackoverflow.com/questions/38585344/swift-constants-struct-or-enum#:~:text=One%20difference%20between%20the%20two,use%20enums%20to%20avoid%20confusion.&text=The%20above%20code%20would%20still%20be%20valid.&text=The%20above%20code%20will%20be%20invalid%20and%20therefor%20avoid%20confusion.)

    해석하면 인스턴스화가 필요 없고 값으로 단순히 상수만을 필요로 할 때에 대부분의 경우 enum을 사용하는 것이 struct보다 낫다는 뜻입니다. 위의 값은 상수만을 가지므로 enum을 고려해볼 수 있을 것 같습니다. 하지만 다음의 이유로 struct로 구현했습니다.

    1. 위의 타입을 기반으로 각각의 product들이 인스턴스로 구현될 예정입니다. 위에서 말한 instantiated 될 필요가 있습니다.
    2. 위의 상황과 다르게 JSON의 value가 String 뿐만 아니라 Int로도 나올 수 있습니다. enum의 경우 case의 rawValue 타입이 일치해야하기 때문에 struct로 구현했습니다.

  ExhibitProduct 타입은 Decoding을 위한 것이므로 Decodable을 채택하며, 4개의 프로퍼티를 갖습니다. 하지만 이렇게 되면 JSON에 존재하는 key와 이름이 다르게 됩니다. 그래서 CodingKeys라는 요소를 정의해줍니다.

  ```swift
  enum CodingKeys: String, CodingKey {
      case name
      case imageName = "image_name"
      case shortDescription = "short_desc"
      case description = "desc"
  }
  ```

  이 CodingKeys를 통해 좀 더 Swift에 맞는 네이밍으로 변경할 수 있습니다. CodingKeys는 Decodable을 채택하는 타입 안에 위치합니다. CodingKey의 경우 위의 고민 point에 언급한 것처럼 인스턴스화가 될 일이 없고 각 개별 case마다 String 값만 갖기 때문에 enum으로 구현된 것을 확인할 수 있습니다.

  여기에 추가로 Contents라는 자료를 추가하기 위한 구조도 생성하겠습니다. Contents의 구조는 아래와 같습니다.

  ```json
  "images" : [
      {
        "filename" : "buddhism~universal@1x.png",
        "idiom" : "universal",
        "scale" : "1x"
      },
      {
        "filename" : "buddhism~universal@2x.png",
        "idiom" : "universal",
        "scale" : "2x"
      },
      {
        "filename" : "buddhism~universal@3x.png",
        "idiom" : "universal",
        "scale" : "3x"
      }
    ],
    "info" : {
      "author" : "xcode",
      "version" : 1
    }
  ```

  위와 마찬가지 방식으로 구현했습니다.

  ```swift
  struct ExhibitionContent: Decodable {
      let images: [Image]
      let info: Information
      
      struct Image: Decodable {
          let fileName: String
          let idiom: String
          let scale: String
          
          enum CodingKeys: String, CodingKey {
              case fileName = "filename"
              case idiom, scale
          }
      }
      
      struct Information: Decodable {
          let author: String
          let version: Int
      }
  }
  ```

  이번엔 Camel case와 Snake Case의 차이가 없는 이름이 많아 CodingKeys는 filename에만 적용했습니다. 이번에는 ExhibitionProduct와 다르게 JSON의 value가 단일 값이 아닌 JSON 형식, 혹은 JSON 형식의 값을 갖는 배열로 구성되어있습니다. 이를 위해 struct 안에 다시 struct를 구현하는 방식으로 구조화하였습니다.

<br/>

## 📱 View 구현

<br/>

### 💻 메인 화면 구현

- View를 구현하기 위해 요구서의 화면을 이해할 필요가 있습니다.

  <구현 후 메인 화면 그림 추가>

  우선 메인 화면은 전시회의 전체적인 설명을 화면에 그려줍니다. JSON에서 받아온 자료를 decoding하기 위해 메인 화면 자료용 구조체를 구현했습니다. 

  ```swift
  struct ExhibitionExplanation: Decodable {
      let title, location, duration, description: String
      let visitors: Int
  }
  ```

  title, location, duration, description은 모두 camel case를 위배하지 않으며 그 자체로 변수 이름으로 쓸 수 있기 때문에 String으로 선언해주었고, visitors는 방문자 수가 데이터에 Int로 존재하므로 Int로 선언했습니다.

  그리고 첫 메인화면의 가장 아래에 "한국의 출품작 보러가기" 라는 버튼이 존재합니다. 

  <구현 후 메인 화면 하단 버튼 그림 추가>

  이 버튼을 누르면 출품작이 나오는 화면으로 넘어갑니다. 출품작이 나오는 화면은 테이블뷰로 구현합니다.

### 💻 출품작 화면 구현

​	<구현 후 출품작 리스트 그림 추가>

- 한국의 출품작 리스트에서는 우선 bar에 이름이 나오고, 메인으로 돌아가는 버튼이 존재합니다. 이것은 일반 버튼이 아닌 bar button을 통해 구현하려고합니다.

- 🧐 고민! Stanford 강의에서 일반 버튼을 네비게이션 바에 사용하면 엉망이 된다는데 구체적으로 어떤 부분이 문제가 되는지 알기 어렵습니다. 구글링에서 button과 bar button의 차이를 찾아보는데 나오지 않아서 직접 실험해볼 필요가 있을 것 같습니다.

- Table View는 리스트로 나오고 기능요구서를 보면 각 row의 높이는 그 컨텐츠 양에 따라 다른 것을 볼 수 있습니다. 그래서 rowHeight(항상 같은 높이)가 아닌 Auto Layout을 사용할 계획입니다.
- 각 row를 클릭하면 해당 컨텐츠의 디테일한 설명 확인이 나옵니다.

### 💻 출품작 디테일 화면 구현

​	<구현 후 출품작 디테일 화면 그림 추가>

- JSON으로부터 받아온 정보들을 화면에서 보여줍니다. 출품작 테이블 화면과 마찬가지로 한국의 출품작 테이블로 돌아갈 수 있는 bar button을 구현합니다.

 

<br/>

## 💿 JSON 데이터를 구현해놓은 타입에 넣기

<br/>

- JSON 형식의 데이터를 파일에서 가져와 구현해놓은 타입에 넣도록 하겠습니다.

  🧐 고민 Point!

  - 데이터를 타입에 넣는 것을 MVC 중 어느 부분에 구현하는게 좋을지 고민했습니다. 우선 View는 화면 관련 요소이므로 구현하지 않고 Model과 Controller 를 고려했습니다. 로직이라는 측면에서 Controller라고 생각할 수 있지만 Model 관련된 로직이므로 Model에서 parsing을 해준 후 그 결과물을 Controller에 넘기는게 더 적합하다고 판단했습니다. 이후 관련 정보를 찾아보니 저와 생각이 비슷한 글을 찾았습니다.

    > The Model(M)
    >
    > *Parsing code*: You should include objects that parse network responses in the model layer. For example, in Swift model objects, you can use JSON encoding/decoding to handle parsing...
    >
    > ref: https://www.raywenderlich.com/1000705-model-view-controller-mvc-in-ios-a-modern-approach
  
    해석하면 " network response를 파싱하는 객체들을 모델 계층에 포함시킨다. 예를 들어 JSON 인코딩/디코딩시에 모델 객체를 사용할 수 있습니다."의 의미입니다.

- JSON을 parsing 하기 위해 DataManager라는 구조체를 구현했습니다. 받아와야하는 JSON 형식은 총 3가지 입니다. 

  ```swift
  struct ExhibitionProduct: Decodable
  ...
  struct ExhibitionContent: Decodable 
  ...
  struct ExhibitionExplanation: Decodable
  ...
  ```

  구조가 세가지이다보니 처음에는 반환하는 타입이 위의 세가지인 메소드 3개를 구현하는 것을 생각했습니다. 아래는 예시로 구현한 함수입니다.

  ```swift
  func parseJSONDataToExhibitionProduct(with jsonData: Data) throws -> ExhibitionProduct {
          let jsonDecoder = JSONDecoder()
          
          do {
              let decodedData = try jsonDecoder.decode(ExhibitionProduct.self, from: jsonData)
              return decodedData
          } catch {
              throw ParsingError.JSONParsingError
          }
      }
  ```

  위의 코드는 문제가 없어보이지만 다른 타입을 반환하기위해 바뀌는 요소는 사실 타입 뿐입니다. 예를 들면 ExhibitionContent를 반환하려면

  ```swift
  func parseJSONDataToExhibitionContent(with jsonData: Data) throws -> ExhibitionContent {
          let jsonDecoder = JSONDecoder()
          
          do {
              let decodedData = try jsonDecoder.decode(ExhibitionContent.self, from: jsonData)
  				...
  ```

  의 구조가 되고 이것을 반복하는 것은 매우 비효율적이라고 판단됩니다. 그래서 제네릭을 생각했습니다. 다만 제네릭을 단순히 적용하면 오류가 발생합니다.

  ```swift
  func parseJSONDataToExhibitionProduct<T>(with jsonData: Data) throws -> T {
          let jsonDecoder = JSONDecoder()
          
          do {
              let decodedData = try jsonDecoder.decode(T.self, from: jsonData)
          ...
  ```

  오류 메세지는 다음과 같습니다. 

  > Instance method 'decode(_:from:)' requires that 'T' conform to 'Decodable'

  당연히 발생할 문제입니다. decode는 decode가 가능한 구조만 받을 수 있으므로 decodable이 필요한 구조인데 일반화된 타입 T는 decodable이 아니므로 오류가 발생합니다. 그래서 where절을 추가하거나 T 자체에 Decodable을 주면되는데 이 경우는 단순히 프로토콜 conform이므로 where를 사용하지 않고 구현했습니다.

  ```swift
  func parseJSONDataToExhibitionData<T: Decodable>(with jsonData: Data) throws -> T
  
  // where 사용
  func parseJSONDataToExhibitionData<T>(with jsonData: Data) throws -> T where T: Decodable
  ```

  🧐 고민 Point!

  - 메소드 안에 선언한 상수 jsonDecoder의 네이밍에 json을 소문자로 하는데 근거가 필요하다고 생각했습니다. 한번 봤던 기억이 있어서 이전에 공부했던 Swift Naming Convention을 다시 찾아봤습니다.

    > [Acronyms and initialisms](https://en.wikipedia.org/wiki/Acronym) that commonly appear as all upper case in American English should be uniformly up- or down-cased according to case conventions:
    >
    > ```swift
    > var utf8Bytes: [UTF8.CodeUnit]
    > ```
    > ref: https://swift.org/documentation/api-design-guidelines/

    인스턴스 명이므로 lower camel case이어야하고 initialism이므로 모두 소문자로 작성(uniformly down-cased)하면 됩니다.


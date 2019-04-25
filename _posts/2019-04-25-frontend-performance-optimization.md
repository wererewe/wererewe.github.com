---
layout: single
title:  "프론트엔드 성능 최적화"
categories: dev
tags: [ blog, frontend]
---
### 브라우저 렌더링 과정
파싱 > 스타일 > 레이아웃(=리플로우) > 페인트 > 합성 & 렌더  
 ![브라우저 렌더링 과정](/assets/img/render.png)

#### 파싱
다운받은 HTML을 파싱하여 DOM 트리 구축, 인라인 CSS나 다운받은 CSS를 해석해 CSSOM 트리를 구축  

#### 스타일
렌더트리 생성. ( 렌더트리를 만드는 소스는 Dom 트리와 CSSOM 트리 )  
결과물: render layer, GPU 처리가 필요하면 graphic layer도 만들어짐  
GPU 처리가 필요한 경우  
* CSS 3d Transform(translate 3d, preserve-3d 등)
* CSS 애니메이션 함수, 필터 함수
* video, canvas 
* 등!

#### 레이아웃(=리플로우)
브라우저의 뷰포트 안에서 노드가 가져야 할 정확한 위치와 크기를 계산하는 과정.  
(ex, width: 50% 를 실제 뷰포트에 해당하는 '픽셀'로 계산함)  
```
<p> ABCED </p>
```
위 코드를 표시하기 위한 과정  
2D 그래픽을 렌더링 (크로미늄에서는 SKIA 라이브러리)  
폰트엔진이 각 문자에 대한 크기를 계산  
각 글자마다 (x,y) 좌표를 지정  
렌더링 과정 중 가장 비용이 큰 작업  

#### 페인트(=래스터라이징)
레이아웃에서 계산된 값을 이용해 렌더트리의 각 노드를 화면 상의 실제 픽셀로 변환함.  
한 장의 레이어로 메모리 공간에 그려놓는 과정.  
#### 합성 & 렌더
페인트 된 레이어들을 합성(composite)하여 스크린을 업데이트  
CSS Transform 속성은 이 과정에서 동작함.  


### 렌더링 최적화란?
디스플레이는 60fps로 화면을 그림. 그러므로, 웹페이지 렌더링 최적화란 브라우저가 1초에 60번 렌더링 할 수 있게 하는 것.  

렌더링 관련 알면 좋은 단어들  
* FCP(First Contentful Pain): 렌더링된 첫 번째 비트가 보여지는 시점.
* FMP(First Meaningful Paint): 주요 컨텐츠가 화면에 보여지는 시점. 
* Critical Rendering Path가 모드 로드됨
* [First Interactive and Consistently Interactive: 측정 방법 연구](https://docs.google.com/document/d/1BR94tJdZLsin5poeet0XoTW60M0SjvOJQttKT-JK8HI/view)
위 페이퍼에 따르면 FMP는 서비스 마다 다른 의미를 가지는데, 검색 사이트에서는 검색 결과가, 29CM과 같은 e-commerce에서는 이미지가 보여지는 시점이 주요 측정 포인트라고 함
* DCL: DOMContentLoaded 이벤트
* L: Load 이벤트
* FI: First Interactive, First CPU Idle  
    * 전부는 아니지만 대부분의 UI가 움직임.  
    * 사용자의 입력에 일정 시간 이내에 동작함  
    * 부드럽지 않게 움직일 수 있음  
    * UI 동작에 필요한 JS 로딩이 마무리 되었음  

* TTI(Time to interactive): 
    * 최소한 메인스레드가 50ms 이내의 컨트롤을 확보하여 부드러운 반응이 가능함
    * 네트워크에서 다운로드 되고있는 리소스가 2개 이하

* 뭔가 진행되고 있구나: FP, FCP
* 이제 원하는 내용을 읽을 수 있다: FMP
* 이제 동작하는구나: TTI


### 간단한 최적화 팁
1. 애니메이션이 들어간 노드는 position: fixed 또는 absolute로 지정한다.
    * 애니메이션은 Layout 비용이 매우 크다. fixed나 absolute로 전체 레이아웃과 분리해주면 애니메이션이 필요한 노드만 계산하게 된다. 그렇지 않을 경우 전체 노드를 재계산 하기 때문에 많은 비용이 들어 느려지게 됨.
2. 초기 렌더링에 쓰이지 않는 스크립트는 defer, async 속성을 명시하여 Blocking을 방지
    1. defer는 IE10 >= 지원
    1. [async vs defer attributes](https://www.growingwiththeweb.com/2014/02/async-vs-defer-attributes.html)
3. link rel preload 사용
4. 네트워크 요청 줄이기
    1. 중복되거나 불필요 파일 제거
    1. webpack을 이용한 번들링
    1. 이미지 Sprites 사용
5. 불필요 데이터 제거
    1. 간결한 css selector 사용
        1. selector가 길어질수록 비용이 큼
    1. 불필요한 css rule 제거
    1. 오버스펙 라이브러리 지양 (대표적으로 lodash)
6. 그 외
    1. DOM 요소 추가 시에도 appendChild를 여러 번 하면 리플로우 여러 번 발생 → innerHTMl 사용
    1. DOM 깊이 최소화 (태그의 중첩을 최소화)
    1. 가능한 하위 노드의 스타일을 변경
    
#### 메모리 관리
* 의도하지 않은 전역 변수 사용
* 잊혀진 타이머
* 참조된 DOM Node 삭제
    * 메모리 누수

```javascript
const elements = {
    button: document.getElementById('button'),
    image: document.getElementById('image'),
    text: document.getElementById('text')
};
 
 
function doStuff() {
    elements.image.src = 'http://some.url/image';
    elements.button.click();
    console.log(elements.text.innerHTML);
    // ...
}
 
 
function removeButton() {
    document.body.removeChild(document.getElementById('button'));
}
``` 
removeButton()을 수행할 경우 '#button'은 삭제되지만 '#button'에 대한 참조(elements.button)는 남아 있게 됨  
이 때문에 '#button'은 GC되지 않음  
  
**해결 방법**  
removeButton() 함수에서 #button 삭제 시 참조도 같이 삭제함
```javascript
function removeButton() {
    document.body.removeChild(document.getElementById('button'));
    elements.button = null;
}
```
* 클로저 사용에 따른 누수
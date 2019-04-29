---
layout: single
title:  "자바스크립트 promise, async/await"
categories: dev
tags: [ blog, frontend, javascript]
---

## promise
1. 자바스크립트 비동기 처리에 사용되는 객체
2. 비동기 처리
    - 특정 코드의 실행이 완료될 때까지 기다리지 않고 다음 코드를 먼저 수행하는 자바스크립트의 특성
3. 주로 서버에서 받아온 데이터에 사용

  
4. 구문
```
new Promise(executor)
```
    1. 매개변수
    executor  
    resolve 및 reject 인수를 전달할 실행 함수.  
    실행 함수는 resolve와 reject 함수를 받아 실행.  
    resolve: 비동기 작업이 모두 끝난 후 호출  
    reject: 오류가 발생한 경우 호출

5. 상태
프라미스는 다음 중 하나의 상태를 가진다.
    1. 대기(pending): resolve 되거나 reject 되지 않은 초기 상태.
    2. 이행(fulfilled): 연산이 성공적으로 완료됨.
    3. 거부(rejected): 연산이 실패함

프라미스 처리 흐름. 출처: MDN  
 ![프라미스 처리 흐름, 출처: MDN](/assets/img/promise.svg)

6. promise 생성하기  

```javascript
var jsonPromise = new Promise(function(resolve, reject) {
  // JSON.parse throws an error if you feed it some
  // invalid JSON, so this implicitly rejects:
  resolve(JSON.parse("This ain't JSON"));
});

jsonPromise.then(function(data) {
  // This never happens:
  console.log("It worked!", data);
}).catch(function(err) {
  // Instead, this happens:
  console.log("It failed!", err);
})
```

- 참고
[https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Promise](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Promise)
[https://joshua1988.github.io/web-development/javascript/promise-for-beginners/](https://joshua1988.github.io/web-development/javascript/promise-for-beginners/)  
[https://developers.google.com/web/fundamentals/primers/promises?hl=ko] (https://developers.google.com/web/fundamentals/primers/promises?hl=ko)


## async/await

<!-- ### iterator

### generator -->
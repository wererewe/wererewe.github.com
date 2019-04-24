---
layout: single
title:  "TypeScript - 고급 타입"
categories: dev
tags: [ blog, typescript]
---

### 공용체(Union)
2개 이상의 타입을 조합하는 표현식.  
공용체는 `파이프 기호(|)`를 사용한다.  
```javascript
var unionType: string | number;
```
위 예제의 unionType에는 string과 number 타입의 값을 할당할 수 있다.

#### 타입가드
공용체 타입을 사용하는 경우, 컴파일러는 타입이 섞여 동작하지 않도록 강타입 규칙을 적용한다.  
타입가드는 코드 안에서 변수의 타입을 확인해 타입을 보장하는 방법이다.
```javascript
function addWithUnion(
    arg1: string | number,
    arg2: string | number
) {
    return arg1 + arg2;
}
```
2개의 인자를 받아 더하는 함수이다.  
arg1과 arg2는 공용체 타입으로 문자열이나 숫자가 될 수 있다. 하지만 코드를 컴파일하면 다음 오류가 발생한다.
```
errer: Operator '+' cannot be applied to types 'string | number'and 'string | number'.
```

타입가드를 통해 타입에 따른 동작을 보장해 주도록 하자.
```javascript
function addWithUnion(
    arg1: string | number,
    arg2: string | number
) {
    if (typeof arg1 === 'string') {
        return arg1 + arg2;
    }
    if (typeof arg1 === 'number' && typeof arg2 === 'number') {
        return arg1 + arg2;
    }

    return arg1.toString() + arg2.toString();
}
```
동일한 함수에 2개의 if문을 추가했다.  
첫 번째 if는 arg1이 문자열인지 확인하고, if문 안쪽에서 문자열로 취급한다. 두 번째 if는 두 개의 인자가 숫자인지 확인하고, if문 안쪽에서 숫자로 취급한다.  
_이 2개의 if가 타입가드다._  
마지막 return에서는 arg1과 arg2의 toString 함수를 호출한다.  
모든 자바스크립트 기본 타입은 toString 함수를 갖고 있어서 실질적으로 두 인자를 모두 문자열로 취급하여 결과를 반환한다.


#### 타입 별명
공용체 타입을 쓰다 보면 어떤 타입을 사용했는지 기억하기 어려울 때도 있다.  
이런 문제를 해결하기 위해 공용체 타입에 특별한 이름을 부여하는 타입 별명 개념을 도입했다.  
타입 별명은 `type` 키워드로 선언해 일반 타입처럼 사용할 수 있다.
```javascript
type StringOrNumber = string | number;

function addWithAlias(
    arg1: StringOrNumber,
    arg2: StringOrNumber
) {
    ...
}
```
타입 별명은 함수 시그니처에도 사용할 수 있다.
```javascript
type CallbackWithString = (string) => void;

function usingCallbackWithString(
    callback: CallbackWithString) {
        callback('this is a string');
    }
```


### Null과 undefined
자바스크립트에서 변수를 선언만 하고 값을 할당하지 않은 채 조회하면 `undefined`가 반환된다.  
`null`은 현재 범위에서 변수를 알고 있고, 값이 없는 경우이다.

### 객체 나머지, 전개(Object rest and spread)
기본 자바스크립트 객체를 사용할 때 객채의 속성을 다른 객체로 복사하거나, 다양한 객체를 섞거나, 일치시키는 작업이 자주 필요하다.  
이런 필요성을 위해 타입스크립트는 ES7에 제안된 객체 나머지(rest)와 전개(spread) 구문을 도입했다.  
```javascript
let firstObj = {id: 1, name: 'firstObj'};
let secondObj = { ...firstObj };
console.log(`secondObj.id: ${secondObj.id}`)
console.log(`secondObj.name: ${secondObj.name}`)
```
해당 문법을 사용해 firstObj의 모든 속성을 secondObj로 복사한다.
콘솔 결과
```
secondObj.id: 1
secondObj.name: firstObj
```
여러 개의 객체를 조합할 수도 있다.
```javascript
let nameObj = {name: 'nameObj'};
let idObj = {id: 2};

let obj3 = { ...nameObj, ...idObj };
console.log(`obj3.id: ${obj3.id}`)
console.log(`obj3.name: ${obj3.name}`)
```
실행 결과는 다음과 같다.
```
obj3.id: 2
obj3.name: nameObj
```
**나머지와 전개 문법은 속성 복사를 점진적으로 적용한다.  두 객체가 같은 이름의 속성을 갖고 있을 경우, 마지막에 지정된 속성값이 우선된다.**
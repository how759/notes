## Extendable Proxy
```javascript
    class ExtendableProxy {
        constructor() {
            return new Proxy(this, {
                set: (object, key, value, proxy) => {
                    object[key] = value;
                    console.log('PROXY SET');
                    return true;
                }
            });
        }
    }

    class ChildProxyClass extends ExtendableProxy {}

    let myProxy = new ChildProxyClass();

    // Should set myProxy.a to 3 and print 'PROXY SET' to the console:
    myProxy.a = 3;
```

## Proxy principle

### [[Get]] and [[Set]] in ecma-262

+ See Section 9.1.8 and Section 9.5.8
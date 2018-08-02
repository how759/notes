+ location

    src/objects.h HeapObject

+ Structure
    + HeapObject
        + header 16 bytes
            + map: 8 bytes
            + pointer: 8 bytes

    + LookupIterator
        + receiver_
        + initial_holder_ 
            + derived by GetRoot(receiver_)
                + if receiver_ is JSReceiver, cast it to this type, otherwise (such as string), call GetRootForNonJSReceiver()
        + holder_
            + init by initial_holder_, and can change based on the prototype chain
            

+ Class
    + JSReceiver
        + SetOrCopyDataProperties()
            + FastAssign() if possible
            + GetKeys() from source -> FixedArray from
            + For each key in keys FixedArray:
                + get descriptor for key -> PropertyDescriptor
                + If descriptor is not undefined and  is enumerable:
                    + Let prop_value be GetObjectProperty(from, key)
                        + get iterator by LookupIterator::PropertyOrElement(from, key) -> LookupIterator it
                            + from -> holder
                            + call LookupInHolder<is_element>() (if key is index, is_element=true)
                                + LookupInSpecialHolder()
                                + LookupInRegularHolder()
                                    + if is_element:
                                        + FixArrayBase* backing_store = elements()
                                        + uint32_t number_ = GetEntryForIndex(). return the actual entry at index, if not found, set it to kMaxUInt32 and return NOT_FOUND
                                    + else if map is not a dictionary map:
                                        + do something
                                    + else:
                                        + NameDictionary* dict = property_dictionary();
                                        + get entry by name, and set it to number_ (uint32_t)
                                        + return NotFound() if not found
                                    + return state like DATA or ACCESSOR
                                    
                            + if is found, return. otherwise call NextInternal<is_element>
                                + search in prototype chain

                        + call Object::GetProperty(it)
                    + Call Runtime::SetObjectProperty(object, key, value) to set prop_value to target at key
                        + get iterator by object and key
                            + for integer key, get iterator from elements by LookupIterator(object, index)
                                + receiver = object
                                + holder = GetRoot(object)
                                    + GetRoot(object): if object is JSReceiver, just cast it to JSReceiver, otherwise (such as string) create a receiver
                        + Object::SetProperty(iterator, value)
                            + if iterator is found, call SetPropertyInternal()
                                + check iterator's state:
                                    + case DATA:
                                        + call SetDataProperty()
                                    + case ACCESSOR:
                                        + call SetPropertyWithAccessor()



+ Case
    + var a = []; a[10000] = 0

        + Call Runtime::SetObjectProperty(object, key, value) to set prop_value to target at key
            + get iterator by object and key
                + for integer key, get iterator from elements by LookupIterator(object, index)
                    + receiver_ = object
                    + initial_holder_ = GetRoot(object)
                        + GetRoot(object): if object is JSReceiver, just cast it to JSReceiver, otherwise (such as string) create a receiver
                    + state_ = LookupInHolder<is_element=true>(map, holder);
                        + holder_ is initialized to initial_holder_, and can change through prototype chain in the process 
                        + state_ = LookupInRegularHolder<is_element=true>(), or LookupInSpecialHolder() in other case (Interceptors or access checks imply special receiver.)
                            + number_ = GetEntryForIndex() from FixedArrayBased backing_store.
                                + return kMaxUInt32 in this case
                                + thus return NOT_FOUND to state_
            + call Object::SetProperty(&iterator, value)
                + Since iterator's state is NOT_FOUND
                    + call AddDataProperty(iterator, value)
                        + in this case receiver is JSArray, call JSObject::AddDataElement(receiver, index, value)
                            + ShouldConvertToSlowElements() = true, so kind = DICTIONARY_ELEMENTS
                                + if index < capacity, return false
                                + if index - capacity > 1024, return true
                                + let new_capacity = 1.5*(index+1) + 16
                                + if (new_capacity <= 500) || (new_capacity <= 5000 && InNewSpace()), return false
                                + If the fast-case backing storage takes up much more memory than a dictionary backing storage would, return true, otherwise return false
                            + accessor = DictionaryElementsAccessor(), accessor->Add()
                                + existing elements are normalized to dictionary structure
                            + Similarly, there is ShouldCovertToFastElement() to check whether dictionary should convert to FixedArray
                                + If properties with non-standard attributes or accessors were added, return false
                                + If index > Smi::kMaxValue or array's length > Smi::kMaxValue, return false
                                + let new_capacity = Max(index+1, array's length)
                                + if the dictionary cannot saves more than 50% space, return true, otherwise return false




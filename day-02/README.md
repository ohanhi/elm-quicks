# Day 2: As a user I want to check my palindrome

Using the [day-01](../day-01) as a base, we started by renaming things: `palindrome` became `model`, the old `main` became `view` and so on. We also introduced a new kind of entry point `Html.beginnerProgram` and added the `update` function, which simply returned the same model as before.

```elm
-- new kind of program, refers to the functions below
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


-- new function
update msg model =
    model


-- the old `main`, but NOTE: a parameter was added
view model =
    Html.text (toString (isPalindrome model))


-- the old `palindrome`
model =
    "Are we not drawn onward, we few, drawn onward to new era?"
```

This resulted in no visible change to how the program works.

Next, we made the `view` a little more complex by adding an input field on top. The `view` given to the `Html.beginnerProgram` needs to produce a single HTML element, so we wrapped the text in a `div` first.

```elm
-- added `exposing (..)` to bring in all the HTML element functions
import Html exposing (..)
-- ...

view model =
    div []
        [ input [] []
        , br [] []
        , text (toString (isPalindrome model))
        ]
```

All HTML elements work the same in Elm: they are functions with the pattern `tagname attributeList childList`. In the code above, none of the elements have any attributes. `div []` means we have a `div` element with an empty attribute list. The div does have children though, namely the input, br, and text.

Now we had a blank input field displayed on the page right above the text "True". Typing into the field didn't do anything either, so we went on to add the value from the parameter `model` as the value of the input. We were not listening for user events at all either, so we added an `onInput` attribute too.

In Elm, event handlers like `onInput` are already wired up to pass the value (in this case the text written) through to the Elm runtime. We could also "tag" the values coming from several sources to tell them apart, but for now we don't need to do that. Instead, we give `onInput` a function that does nothing to the string and just returns it as is: `\text -> text`.


```elm
-- added `Html.Attributes`, which is where all the attributes come from
import Html.Attributes exposing (..)


-- within `view`
    input [ value model, onInput (\text -> text) ] []
```

This made the input "broken": no matter how you try to type in it, the text would always switch back to the original. Our `update` was always returning the original value.

In our application, the value coming from the `onInput` was in fact the new string we wanted to check for palindrome-ness. It is the text that the user has written in the input field. This means just switching the `update` to return that new string, we get the end result we were looking for.

```elm
update textThatTheUserHasWritten model =
    textThatTheUserHasWritten
```

The user can now type in their own potential palindromes and our program tells their validity as they type. Sweet!


---

You can try out the application and play with the code on Ellie: [https://ellie-app.com/LGftKnn9a1/0](https://ellie-app.com/LGftKnn9a1/0)

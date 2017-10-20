# Day 1: Check that palindrome

For the first day of live-coding on elm-quicks we created a tiny program that can tell whether a phrase is a palindrome or not. We started with the most simple Elm program possible:

```elm
import Html

main =
    Html.text "Hello Elm"
```

Next, we added a potential palindrome and a stub for a function that would check the palindrome-ness of a string.

```elm
palindrome =
    "Are we not drawn onward, we few, drawn onward to new era?"

isPalindrome input =
    False
```

This was then used in `main`:

```elm
main =
    Html.text (toString (isPalindrome palindrome))
```

`toString` was needed to turn the boolean value from `isPalindrome` into a string, which is what `Html.text` expects to receive.

From then on, we filled out the logic for the function in a `let-in` structure. The `let` block is where you can define local variables for a function. The code after `in` is the actual function body. We also used `Debug.log` at times to make sure things looked like we thought they should.

The idea for how we can check for palindrome-ness was: turn the phrase into lower case letters only, and then check if it is equal to its reverse. At the live-coding session, I used a silly method to check if a character is a letter. Thanks to one of the participants I found a much nicer way to do this, so the final code looks like this:

```elm
isPalindrome input =
    let
        characters =
            String.toList (String.toLower input)

        justLetters =
            List.filter Char.isLower characters

        lettersInReverse =
            List.reverse justLetters
    in
    justLetters == lettersInReverse
```

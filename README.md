# MeowMeaning
An iOS PoC that uses CoreML + SwiftUI to identify the meow feeling and classifies it into three different classes:

- Brushing
- Food
- Isolation

This PoC first executes a ML Model that filters the record looking for a cat sound. This model was created using the following dataset:

https://github.com/karolpiczak/ESC-50

Then a second ML Model is executed in order to analize the cat's feeling (note: This ML Model is not accurate enough yet, but don't hesitate if you want to improve it).

The dataset used for the cat's feeling is the following one:

https://www.kaggle.com/datasets/andrewmvd/cat-meow-classification

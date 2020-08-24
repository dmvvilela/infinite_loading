# infinite_loading

A Flutter Package for rendering an infinite loading widget.

It will animate the loading container to a check mark if successfull or to an error image if it should finish with error.

I will be releasing gifs showing the package and updating dependencies in the next release.

## Usage

If completeWithSuccess is null, the widget will load forever.

Just use setState(() {}) setting completeWithSuccess with true to finish the loading with success or false to finish it with error.

Example:

```dart
bool _completeWithSuccess;

InfiniteLoading(
    MediaQuery.of(context).size.width * 2 / 3,
    trackColor: Color(0xFF4E4E4E),
    progressBorderColor: Color(0xFF4E4E4E),
    completeBorderColor: Colors.transparent,
    completeWithSuccess: _completeWithSuccess,
),
```

After doing some work and you need to update the widget:

```dart
setState(() {
    _completeWithSuccess = true;
})
```

If you like the package please like it in pub.dev.

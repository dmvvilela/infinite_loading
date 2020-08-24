# infinite_loading

A Flutter Package for rendering an infinite loading widget.

It will animate the loading container to a check mark if successfull or to an error image if it should finish with error.

## Usage

If completeWithSuccess is null, the widget will load forever.

Just use setState(() {}) setting completeWithSuccess with true to finish the loading with success or false to finish it with error.

# Omnipipe

"What if the URL bar supported unix pipe semantics? ex: "http://longurl.com | bitly", "http://foo.cn | translate english", ..."

Demo @ [http://omnipipe.herokuapp.com/](http://omnipipe.herokuapp.com/)

## How does it work?

Unfortunately Chrome doesn't provide an API to listen to "url submit" events, but we can approximate what this functionality would "feel" like by creating and leveraging a custom search engine. This "search engine" simply takes in the URL and the pipe parameters as a query string, and then does the right thing.

## Example commands

* **googl**: Take the input URL, shorten it via goo.gl shortener and redirect me to the resulting page.
* **grep**: World's simplest grep.. Download the page, walk over the content line by line and output matching lines.

For instructions on how to install & use, check [http://omnipipe.herokuapp.com/](http://omnipipe.herokuapp.com/)

### License

MIT License - Copyright (c) 2011 Ilya Grigorik
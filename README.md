Shares
======

Shares is a mobile stock investing app that creates the intersection between realtime stock updates (quotes and news), investing in social circles, and managing a watchlist of equities. The app connects with the MarkitOnDemand API on the backend to get stock quotes and connects with various news outlets to retrive current news stories relating to a stock. Additionally, user profiles are easy to create via email/password or Facebook OAuth.

**Visit the website**: http://financialshares.com


Table of Contents
-----------------

- [Pre-Requisites](#prerequisites)
- [Features](#features)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)


Features
--------

- **Local Authentication** using Email and Password
- **OAuth 1.0a Authentication** via Twitter
- **OAuth 2.0 Authentication** via Facebook, Google, GitHub, LinkedIn, Instagram
- Flash notifications
- MVC Project Structure
- Node.js clusters support
- Rails 3.1-style asset pipeline by connect-assets (See FAQ)
- LESS stylesheets (auto-compiled without any Gulp/Grunt hassle)
- Bootstrap 3 + Flat UI + iOS7
- Contact Form (powered by Mailgun, Sendgrid or Mandrill)
- **Account Management**
 - Gravatar
 - Profile Details
 - Change Password
 - Forgot Password
 - Reset Password
 - Link multiple OAuth strategies to one account
 - Delete Account
- CSRF protection
- **API Examples**: Facebook, Foursquare, Last.fm, Tumblr, Twitter, Stripe, LinkedIn and more.


Prerequisites
-------------

- [XCode](https://developer.apple.com/xcode/download)
- [Cocoapods](https://cocoapods.org)


Getting Started
---------------

Get started by first cloning the repository:

```bash
# Get the latest version:
$ git clone https://github.com/danXyu/shares.git
$ cd shares/Shares

# Then, just open up the workspace and compile/run:
$ open Shares.xcworkspace
```


Contributing
------------

If something is unclear, confusing, or needs to be refactored, please let me know.
Pull requests are always welcome, but due to the opinionated nature of this
project, I cannot accept every pull request. Please open an issue before
submitting a pull request. This project uses [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
with a few minor exceptions.


License
-------

The MIT License (MIT)

Copyright (c) 2015-2016 Dan Yu

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

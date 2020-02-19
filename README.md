# Portfolio Manager
Portfolio Manager is an app to keep track of securities in an investment portfolio.

## Installation
1. Clone or download the repo: https://github.com/big32mike/portfolio-manager
2. In your terminal, navigate to the app directory and run:
   >$ bundle install
3. Launch a local server with `shotgun':
   >$ shotgun
4. Visit `http://localhost:9393` in your browser.

To end the server session, type `ctrl+c`

## Usage
First time users will need to create an account at `/signup`. Returning users can login with their username and password at `/login`.
Once logged in, Users will be greeted by their previously created portfolios, or a link to create a new portfolio. Clicking a portfolio link brings you to its view page, where Users can edit or delete portfolios.

Users can also add new stocks from the portfolio edit page. Stocks created from the portfolio page will automatically be added to the current portfolio. Users can visit the stock index page at `/stocks` to list all stocks, and create new stocks not associated with any portfolio. Clicking a stock's symbol here will take you to the stock edit page, where stocks can be updated or deleted.

All logged in Users can create, edit, and delete stocks, but Users can only edit and delete portfolios that belong to them.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/big32mike/portfolio-manager.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
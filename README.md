# Project Management

## Install
### Clone the repository

```shell
git clone https://github.com/saudsaleemdev/ProjectManagement.git
cd ProjectManagement
```
### Dependencies

* `ruby -> 2.6.5 `
* `rails -> 6.1.7`
* You should have postgres installed on your system - [see here for more info](https://www.postgresql.org/download/macosx/)
### Check your Ruby version

```shell
ruby -v
```

You should expect `ruby 2.6.5`

If not, install the right ruby version using [rvm](https://rvm.io/) (it could take a while):

```shell
rvm install 2.6.5
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler)

```shell
bundle install
```

### Initialize the database

```shell
rails db:setup
```
## Serve

```shell
rails s
```

## API testing using RSwag
##### visit [API docs](http://localhost:3000/api-docs/index.html)

```shell
rake rswag:specs:swaggerize
```
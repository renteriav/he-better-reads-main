# Dependencies

1. Ruby 2.7.3
2. Bundler 2.2.9
3. Rails 6.1.3
4. Postgres

# Installation

1. `bundle install`
2. `rake db:setup`

# Running the Specs
`rails spec` or `rspec spec`

# Start the Server
`rails s`

# REST API

The REST API is described below.

## Authorization
In order to add a review we need to obtain a token by either creating a new user or loging in an existing user. The response returns an **authentication token** in the **Authentication Header** that is valid for 24 hours. This token needs to be included in following POST requests. GET requests don't need an authorization token.

## Create a User

### Request

`POST /api/signup`

**user** *hash* required

**first_name** *string* required

**last_name** *string* required

**email** *string* required

**password** *string* required

```
{   
  "user": {
    "first_name": "John",
    "last_name": "Smith",
    "email": "email@test.com",
    "password": "mypassword"
  }
}
```

### Response

```
{
  "status": {
    "code": 200,
    "message": "Signed up sucessfully."
  },
  "data": {
    "id": 3,
    "email": "email@test.com",
    "first_name": "John",
    "last_name": "Smith",
    "created_at": "2021-11-09T01:50:00.831Z"
  }
}

Headers

authorization: Bearer eyJhbGciOiJIUzI1NiJ9
```

## Login User

### Request

`POST /api/login`

**user** *hash* required

**email** *string* required

**password** *string* required

Headers

**Authorization** *token* required

```
{ 
  "user": {
    "email": "email@test.com",
    "password": "mypassword"
  }
}

Authorization: Bearer eyJhbGciOiJIUzI1NiJ9
```

### Response

```
{
  "status": {
    "code": 200,
    "message": "Logged in sucessfully."
  },
  "data": {
    "id": 1,
    "email": "email@test.com",
    "first_name": "John",
    "last_name": "Smith",
    "created_at": "2021-11-06T23:10:47.375Z"
  }
}
```

## Add a review for a book

### Request

`POST /api/books/{book_id}/reviews`

**book_id** *url param* required

**rating** *integer* required

**description** *string* optional

Headers

**Authorization** *token* required

```
{
  "rating": 4,
  "description": "I liked the book"
}

Authorization: Bearer eyJhbGciOiJIUzI1NiJ9
```

### Response

```
{
  "id": 19,
  "created_at": "2021-11-09T00:08:45.952Z",
  "description": "I liked the book",
  "rating": 4,
  "reviewer_id": 2
}
```

## Add a review for an Author

### Request

`POST /api/authors/{author_id}/reviews`

**author_id** *url param* required

**rating** *integer* required

**description** *string* optional

Headers

**Authorization** *token* required

```
{
  "rating": 4,
  "description": "I liked this author"
}

Authorization: Bearer eyJhbGciOiJIUzI1NiJ9
```

### Response

```
{
  "id": 13,
  "created_at": "2021-11-09T00:08:45.952Z",
  "description": "I liked this author",
  "rating": 4,
  "reviewer_id": 2
}
```

## Get book reviews
It returns the reviews for a book. There are three optional parameters that can be included in the call.
1. **rating** - When this parameter is included, only reviews that match that rating are returned. If the parameter is not a number between 1 and 5, the parameter is ignored.
2. **sort_by_rating** - When this parameter is included, the reviews are ordered by rating from lowest to highest or highest to lowest. When this parameter is not included, reviews are ordered from most recent to oldest.
3. **with_description_only** - By default, only reviews with a description are returned. In order to include reviews without a description, this parameter must be included with a false value.

### Request

`GET /api/books/{book_id}/reviews`

**book_id** *url param* required

**rating** *integer* optional

**sort_by_rating** *string* optional (options: asc, desc)

**with_description_only** *string* optional (options: true, false, default: true)

```
{
  "sort_by_rating": "asc",
  "with_description_only": false
}
```

### Response

```
[
  {
    "id": 3,
    "created_at": "2021-11-07T21:48:54.430Z",
    "description": "It was a good book.",
    "rating": 3,
    "reviewer_id": 2
  },
  {
    "id": 2,
    "created_at": "2021-11-07T21:37:47.131Z",
    "description": null,
    "rating": 4,
    "reviewer_id": 1
  }
]
```

## Get author reviews
Same as get book reviews.

### Request

`GET /api/authors/{author_id}/reviews`

**book_id** *url param* required

**rating** *integer* optional

**sort_by_rating** *string* optional (options: asc, desc)

**with_description_only** *string* optional (options: true, false, default: true)

```
{
  "sort_by_rating": "asc",
  "with_description_only": false
}
```

### Response

```
[
  {
    "id": 3,
    "created_at": "2021-11-07T21:48:54.430Z",
    "description": "It was a good author.",
    "rating": 3,
    "reviewer_id": 2
  },
  {
    "id": 2,
    "created_at": "2021-11-07T21:37:47.131Z",
    "description": null,
    "rating": 4,
    "reviewer_id": 1
  }
]
```

##  Other endpoints

`api/books`

`api/books/{book_id}`

`api/authors`

`api/authors/{author_id}`
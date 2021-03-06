### API

#### GET /api/version

Use this method in order to get the current version of this application

**Parameters**


**Response**

200: The version of this application
```json
{
  "type": "version",
  "data": "Check v0.0.1"
}
```

401: Access denied
```json
{
  "errors": [
    {
      "message": "Unauthorized",
      "code": 1,
      "data": {
      }
    }
  ]
}
```


#### GET /api/me

Use this method in order to get information about current user, either by session or token

**Parameters**


**Response**

200: Information about current user, or nil if not authenticated
```json
{
  "type": "user"
}
```


#### POST /api/graphql

Use this method in order to send queries to the GraphQL server

**Parameters**

* `query`: GraphQL query _(required)_

**Response**

200: GraphQL result
```json
{
  "data": {
    "about": {
      "name": "Check",
      "version": "0.0.1"
    }
  },
  "extensions": {
    "tracing": {
      "version": 1,
      "startTime": "2020-08-13T18:51:25.685Z",
      "endTime": "2020-08-13T18:51:29.874Z",
      "duration": 4189505100,
      "execution": {
        "resolvers": [
          {
            "path": [
              "about"
            ],
            "parentType": "Query",
            "fieldName": "about",
            "returnType": "About",
            "startOffset": 2713203,
            "duration": 4185518980
          },
          {
            "path": [
              "about",
              "name"
            ],
            "parentType": "About",
            "fieldName": "name",
            "returnType": "String",
            "startOffset": 4188745260,
            "duration": 85353
          },
          {
            "path": [
              "about",
              "version"
            ],
            "parentType": "About",
            "fieldName": "version",
            "returnType": "String",
            "startOffset": 4189048051,
            "duration": 146389
          }
        ]
      }
    }
  }
}
```

401: Access denied
```json
{
  "data": {
    "about": {
      "name": "Check",
      "version": "0.0.1"
    }
  },
  "extensions": {
    "tracing": {
      "version": 1,
      "startTime": "2020-08-13T18:51:29.967Z",
      "endTime": "2020-08-13T18:51:33.563Z",
      "duration": 3596071958,
      "execution": {
        "resolvers": [
          {
            "path": [
              "about"
            ],
            "parentType": "Query",
            "fieldName": "about",
            "returnType": "About",
            "startOffset": 2356767,
            "duration": 3592782258
          },
          {
            "path": [
              "about",
              "name"
            ],
            "parentType": "About",
            "fieldName": "name",
            "returnType": "String",
            "startOffset": 3595492124,
            "duration": 98228
          },
          {
            "path": [
              "about",
              "version"
            ],
            "parentType": "About",
            "fieldName": "version",
            "returnType": "String",
            "startOffset": 3595772027,
            "duration": 52928
          }
        ]
      }
    }
  }
}
```


#### POST /api/users/sign_in

Use this method in order to sign in

**Parameters**

* `api_user[email]`: E-mail _(required)_
* `api_user[password]`: Password _(required)_

**Response**

200: Signed in
```json
{
  "errors": [
    {
      "message": "Invalid Email or password.",
      "code": 1,
      "data": {
      }
    }
  ]
}
```

401: Could not sign in
```json
{
  "errors": [
    {
      "message": "Invalid Email or password.",
      "code": 1,
      "data": {
      }
    }
  ]
}
```


#### DELETE /api/users/sign_out

Use this method in order to sign out

**Parameters**


**Response**

200: Signed out


#### POST /api/users

Use this method in order to create a new user account

**Parameters**

* `api_user[email]`: E-mail _(required)_
* `api_user[name]`: Name _(required)_
* `api_user[password]`: Password _(required)_
* `api_user[password_confirmation]`: Password Confirmation _(required)_

**Response**

200: Account created
```json
{
  "errors": [
    {
      "message": "Please check your email to verify your account.",
      "code": 1,
      "data": {
      }
    }
  ]
}
```

400: Password is too short
```json
{
  "errors": [
    {
      "message": "has already been taken",
      "code": 4,
      "data": {
      }
    }
  ]
}
```

400: Passwords do not match
```json
{
  "errors": [
    {
      "message": "has already been taken",
      "code": 4,
      "data": {
      }
    }
  ]
}
```

400: E-mail missing
```json
{
  "errors": [
    {
      "message": "has already been taken",
      "code": 4,
      "data": {
      }
    }
  ]
}
```

400: Password is missing
```json
{
  "errors": [
    {
      "message": "has already been taken",
      "code": 4,
      "data": {
      }
    }
  ]
}
```

400: Name is missing
```json
{
  "errors": [
    {
      "message": "has already been taken",
      "code": 4,
      "data": {
      }
    }
  ]
}
```


#### PATCH /api/users

Use this method in order to update your account

**Parameters**

* `api_user[email]`: E-mail
* `api_user[name]`: Name
* `api_user[password]`: Password
* `api_user[password_confirmation]`: Password Confirmation
* `api_user[current_password]`: Current Password

**Response**

200: Account updated
```json
{
  "errors": [
    {
      "message": "You need to sign in or sign up before continuing.",
      "code": 1,
      "data": {
      }
    }
  ]
}
```

400: Password is too short
```json
{
  "errors": [
    {
      "message": "You need to sign in or sign up before continuing.",
      "code": 1,
      "data": {
      }
    }
  ]
}
```

400: Passwords do not match
```json
{
  "errors": [
    {
      "message": "You need to sign in or sign up before continuing.",
      "code": 1,
      "data": {
      }
    }
  ]
}
```

400: E-mail missing
```json
{
  "errors": [
    {
      "message": "You need to sign in or sign up before continuing.",
      "code": 1,
      "data": {
      }
    }
  ]
}
```

400: Password is missing
```json
{
  "errors": [
    {
      "message": "You need to sign in or sign up before continuing.",
      "code": 1,
      "data": {
      }
    }
  ]
}
```

400: Name is missing
```json
{
  "errors": [
    {
      "message": "You need to sign in or sign up before continuing.",
      "code": 1,
      "data": {
      }
    }
  ]
}
```


#### DELETE /api/users

Use this method in order to delete your account

**Parameters**


**Response**

200: Account deleted
```json
{
  "errors": [
    {
      "message": "You need to sign in or sign up before continuing.",
      "code": 1,
      "data": {
      }
    }
  ]
}
```


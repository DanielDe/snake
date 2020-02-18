# snake

A simple command line utility for transforming input with spaces to different cases:

```
$ snake add date of birth to users table
add_date_of_birth_to_users_table

$ snake --kebab add date of birth to users table
add-date-of-birth-to-users-table

$ snake --pascal add date of birth to users table
AddDateOfBirthToUsersTable

$ snake --camel add date of birth to users table
addDateOfBirthToUsersTable
```

## Why?

Hitting the space bar is easier than typing an underscore. And this was easy to do.

This was my motivating use case:

```
rails g migration $(snake add date of birth to users table)
```

But I bet it'll be useful elsewhere too.

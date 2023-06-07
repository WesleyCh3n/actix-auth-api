# Fullstack with Actix & React

A small practice to create an authentication and db restful server with Actix
backend and React frontend.

## Frontend

## Backend API

Authentication:

- post("/auth"): verify user and return unique jwt to cookie
- delete("/auth"): remove cookie

Database restful api (with valid jwt):

- get("/station")
- get("/station/{id}")
- get("/chip")
...
